from sqlalchemy import create_engine, MetaData
from sqlalchemy.orm import scoped_session, sessionmaker
from flask_sqlalchemy import BaseQuery

from sqlalchemy.ext.declarative import declarative_base


#engine = create_engine('sqlite:///instance/app.sqlite')
engine = create_engine('postgresql://webapp:webapp@localhost/webapp')
metadata = MetaData()
db_session = scoped_session(sessionmaker(autocommit=False,
                                         autoflush=False,
                                         bind=engine))
Base = declarative_base()
Base.query = db_session.query_property(query_cls=BaseQuery)

def init_db():
  # import all modules here that might define models so that
  # they will be registered properly on the metadata.  Otherwise
  # you will have to import them first before calling init_db()
  metadata.create_all(bind=engine)
#  import flaskr.models
#  Base.metadata.create_all(bind=engine)
