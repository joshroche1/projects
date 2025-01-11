from typing import Annotated

from fastapi import Depends, FastAPI, HTTPException, Request
from fastapi.responses import RedirectResponse, HTMLResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates

app = FastAPI()
app.mount("/static", StaticFiles(directory="static"), name="static")
templates = Jinja2Templates(directory="templates")

@app.get("/", response_class=HTMLResponse)
async def index(request: Request):
  return templates.TemplateResponse("index.html", {"request": request})

@app.get("/lists", response_class=HTMLResponse)
async def page_lists(request: Request):
  return templates.TemplateResponse("lists.html", {"request": request})

@app.get("/tables", response_class=HTMLResponse)
async def page_tables(request: Request):
  return templates.TemplateResponse("tables.html", {"request": request})

@app.get("/forms", response_class=HTMLResponse)
async def page_forms(request: Request):
  return templates.TemplateResponse("forms.html", {"request": request})

@app.get("/graphics", response_class=HTMLResponse)
async def page_graphics(request: Request):
  return templates.TemplateResponse("graphics.html", {"request": request})
#