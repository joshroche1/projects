from typing import Union

from fastapi import Depends, FastAPI, HTTPException, Form, Request
from fastapi.responses import RedirectResponse, HTMLResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates

from pydantic import BaseModel
from sqlalchemy.orm import Session

from .database import SessionLocal, engine
from . import models, schema
from .auth import authenticate_user, create_user, get_current_user, oauth2_scheme, test_authenticate
#from .module import ???


### Initialization

models.Base.metadata.create_all(bind=engine)

app = FastAPI()

app.mount("/static", StaticFiles(directory="static"), name="static")

templates = Jinja2Templates(directory="templates")

messages = []
g = {}

def get_db():
  db = SessionLocal()
  try:
    yield db
  finally:
    db.close()

def message(message: str = ""):
  messages.clear()
  messages.append(message)

### Routing


@app.get("/token")
async def token_auth(token: str = Depends(oauth2_scheme)):
  return {"token": token}

@app.get("/user")
async def read_users_me(current_user: schema.User = Depends(get_current_user)):
  return current_user
#

@app.get("/", response_class=HTMLResponse)
async def index(request: Request):
  message()
  return templates.TemplateResponse("index.html", {"request": request, "messages": messages, "g": g})

@app.get("/login", response_class=HTMLResponse)
async def loginpage(request: Request):
  message()
  return templates.TemplateResponse("login.html", {"request": request, "messages": messages, "g": g})

@app.post("/login")
async def loginform(request: Request, username: str = Form(), password: str = Form(), db: Session = Depends(get_db)):
  message()
  #db_user = authenticate_user(db, username, password)
  db_user = test_authenticate(db, username, password)
  if db_user is None:
    messages.append("User not found")
    return templates.TemplateResponse("login.html", {"request": request, "messages": messages, "g": g})
  g["user"] = db_user
  return templates.TemplateResponse("index.html", {"request": request, "messages": messages, "g": g})

@app.get("/logout", response_class=HTMLResponse)
async def logout(request: Request):
  message()
  g.clear()
  return templates.TemplateResponse("index.html", {"request": request, "messages": messages, "g": g})

###