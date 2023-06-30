from typing import Union

from fastapi import Depends, FastAPI, HTTPException, Form, Request
from fastapi.responses import RedirectResponse, HTMLResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates

from pydantic import BaseModel
from sqlalchemy.orm import Session

from .database import SessionLocal, engine
from . import models, schema, transaction
from .transaction import get_transactions, get_transaction, create_transaction, delete_transaction
from .auth import authenticate_user, create_user, get_current_user, oauth2_scheme, get_users


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

app.include_router(transaction.router)

@app.get("/", response_class=HTMLResponse)
async def index(request: Request):
  message()
  return templates.TemplateResponse("index.html", {"request": request, "messages": messages, "g": g})

@app.get("/test", response_class=HTMLResponse)
async def test(request: Request, db: Session = Depends(get_db)):
  message()
  userlist = get_users(db)
  return templates.TemplateResponse("test.html", {"request": request, "messages": messages, "g": g, "userlist": userlist})

@app.get("/login", response_class=HTMLResponse)
async def loginpage(request: Request):
  message()
  return templates.TemplateResponse("login.html", {"request": request, "messages": messages, "g": g})

@app.post("/login")
async def loginform(request: Request, username: str = Form(...), password: str = Form(...), db: Session = Depends(get_db)):
  message()
  db_user = authenticate_user(db, username, password)
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

@app.get("/list", response_class=HTMLResponse)
async def list_view(request: Request, db: Session = Depends(get_db)):
  message()
  transactions = await get_transactions(db)
  return templates.TemplateResponse("transactions.html", {"request": request, "messages": messages, "g": g, "transactions": transactions})

@app.post("/list/create_transaction", response_class=HTMLResponse)
async def list_view_create_transaction(request: Request, name: str = Form(...), amount: str = Form(...), category: str = Form(...), datetimestamp: str = Form(...), description: str = Form(...), db: Session = Depends(get_db)):
  error = ""
  if name == "": error = "Name cannot be empty"
  if amount == "": error = "Amount cannot be empty"
  if category == "": category = "Default"
  if datetimestamp == "": datetimestamp = "2023-01-01 00:00:00"
  if description == "": description = " "
  if error != "": 
    message(error)
  else:
    amt = float(amount)
    transaction = create_transaction(name, amt, category, datetimestamp, description, db)
  transactions = await get_transactions(db)
  return templates.TemplateResponse("transactions.html", {"request": request, "messages": messages, "g": g, "transactions": transactions})
