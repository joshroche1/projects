import os

from flask import Blueprint, flash, g, current_app


application_config_file = "webapp1/application.properties"

bp = Blueprint("config", __name__)


def init_application_properties():
  file = open(application_config_file, 'r')
  application_properties_file = file.read()
  tmplines = application_properties_file.splitlines()
  application_properties = {}
  for line in tmplines:
    tmplist = line.split('=')
    tmpkey = tmplist[0].strip()
    tmpval = tmplist[1].strip()
    application_properties[tmpkey] = tmpval
  return application_properties

application_properties = init_application_properties()
