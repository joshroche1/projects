import os

from flask import Flask, render_template
from flask_mobility import Mobility


def create_app(test_config=None):
  app = Flask(__name__, instance_relative_config=True)
  app.config.from_mapping(
    SECRET_KEY="dev",
    DATABASE=os.path.join(app.instance_path, "flaskr.sqlite"),
  )
  if test_config is None:
    app.config.from_pyfile("config.py", silent=True)
  else:
    app.config.update(test_config)

  try:
    os.makedirs(app.instance_path)
  except OSError:
    pass

  Mobility(app)

  from webapp1 import config
  app.app_config = config.init_application_properties()

  from webapp1 import database
  @app.teardown_appcontext
  def shutdown_session(exception=None):
    database.db_session.remove()

  from webapp1 import models

  from webapp1 import views
  app.register_blueprint(views.bp)

  app.add_url_rule("/", endpoint="views.index")

  return app
