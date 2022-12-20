import functools
import subprocess

from flask import Blueprint, flash, g, redirect, render_template, request, session, url_for
from werkzeug.security import check_password_hash, generate_password_hash
from sqlalchemy import text

from webapp1.database import db_session
from webapp1.models import User

bp = Blueprint('auth', __name__, url_prefix='/auth')


def login_required(view):
  """View decorator that redirects anonymous users to the login page."""
  @functools.wraps(view)
  def wrapped_view(**kwargs):
    if g.user is None:
      return redirect(url_for("auth.login"))
    return view(**kwargs)
  return wrapped_view

@bp.before_app_request
def load_logged_in_user():
  """If a user id is stored in the session, load the user object from
  the database into ``g.user``."""
  user_id = session.get("user_id")
  if user_id is None:
    g.user = None
  else:
    g.user = User.query.filter_by(id=user_id).one()

def password_complexity_check(password):
  specialchars = ["!","@","#","$","%","^","&","*","(",")"]
  specialcharsfound = False
  tmppwd = password
  if len(tmppwd) <= 9:
    return False
  for x in specialchars:
    if tmppwd.find(x) > 0:
      specialcharsfound = True
      tmppwd = tmppwd.replace(x,"")
  if specialcharsfound == False:
    return False
  elif len(tmppwd) < 4:
    return False
  elif tmppwd.isalnum() == False:
    return False
  else:
    return True
  return False

@bp.route("/login", methods=("GET", "POST"))
def login():
  """Log in a registered user by adding the user id to the session."""
  if request.method == "POST":
    user_name = request.form["username"]
    pass_word = request.form["password"]
    error = None
    user = User.query.filter_by(username=user_name).one()
    passhash = user.password
    if user is None:
      error = "Incorrect username."
    elif not check_password_hash(passhash, pass_word):
      error = "Incorrect password."
    if error is None:
      # store the user id in a new session and return to the index
      session.clear()
      session["user_id"] = user.id
      return redirect(url_for("views.index"))
    flash(error)
    return redirect(url_for("auth.login"))
  return render_template("auth/login.html")

@bp.route("/logout")
def logout():
  """Clear the current session, including the stored user id."""
  session.clear()
  return redirect(url_for("views.index"))
