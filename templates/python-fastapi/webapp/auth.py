from fastapi import Depends, HTTPException
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm

from sqlalchemy.orm import Session

from . import models, schema


oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")
# token: str = Depends(oauth2_scheme)


def get_user(db: Session, user_id: int):
  return db.query(models.User).filter(models.User.id == user_id).first()

def get_user_by_email(db: Session, email: str):
  return db.query(models.User).filter(models.User.email == email).first()

def get_user_by_username(db: Session, username: str):
  return db.query(models.User).filter(models.User.username == username).first()

def get_users(db: Session, skip: int = 0, limit: int = 100):
  return db.query(models.User).offset(skip).limit(limit).all()

def create_user(db: Session, user: schema.UserCreate):
  fake_hashed_password = user.password + "notreallyhashed"
  db_user = models.User(email=user.email, username=user.username, password=fake_hashed_password)
  db.add(db_user)
  db.commit()
  db.refresh(db_user)
  return db_user

def authenticate_user(db: Session, username: str, password: str):
  db_user = get_user_by_username(db, username)
  return db_user

#
def fake_decode_token(token):
  return models.User(email="user@test.tst", username="user" + token, password="testTEST")

def get_current_user(token: str = Depends(oauth2_scheme)):
  user = fake_decode_token(token)
  return user

def test_authenticate(db: Session, username: str, password: str):
  db_user = get_current_user("TESTtoken")
  if db_user.username.find(username) < 0:
    raise HTTPException(status_code=400, detail="User not found") 
  if not db_user.password == password:
    msg = "Password is " + db_user.password + " but given: " + password
    raise HTTPException(status_code=400, detail=msg) 
  return {"access_token":username, "token_type":"bearer", "username": username}

#