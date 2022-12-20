from sqlalchemy import Table, Column, Integer, String
from sqlalchemy.orm import mapper
from flask_sqlalchemy import BaseQuery

from webapp1.database import metadata, db_session



class User(object):
  query = db_session.query_property(query_cls=BaseQuery)

  def __init__(self, username=None, password=None, email=None):
    self.username = username
    self.password = password
    self.email = email

  def __repr__(self):
    return f'<User {self.username!r}>'

users = Table('users', metadata,
  Column('id', Integer, nullable=False, primary_key=True),
  Column('username', String(48), nullable=False, unique=True),
  Column('password', String(48), nullable=False),
  Column('email', String(128), nullable=False, unique=True)
)
mapper(User, users)
