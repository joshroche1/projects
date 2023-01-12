import functools

from flask import Blueprint, current_app, flash, g, redirect, render_template, request, session, url_for

#from webapp1.MODULE import bp as MODULE_bp


bp = Blueprint('views', __name__, url_prefix='/')
# bp.register_blueprint(MODULE_bp)


@bp.route('/')
def index():
  return render_template('index.html')

@bp.route('/test_1')
def test_1():
  return render_template('test1.html')

@bp.route('/test_2')
def test_2():
  return render_template('test2.html')