from fastapi import Depends, APIRouter

from sqlalchemy.orm import Session

from . import models, schema
from .database import SessionLocal


router = APIRouter()

def get_db():
  db = SessionLocal()
  try:
    yield db
  finally:
    db.close()


@router.get("/transaction/", tags=["transactions"])
async def get_transactions(db: Session = Depends(get_db)):
  transactions = db.query(models.Transaction).order_by(models.Transaction.id).all()
  return transactions

@router.get("/transaction/{id}", tags=["transactions"])
async def get_transaction(id: int, db: Session = Depends(get_db)):
  transaction = db.query(models.Transaction).filter(models.Transaction.id == id).first()
  return transaction

@router.post("/transaction/create", tags=["transactions"])
async def create_transaction(name: str, amount: float, category: str, datetimestamp: str, description: str, db: Session = Depends(get_db)):
  if not name:
    return {"error":"Name needed"}
  if not amount:
    return {"error":"Value needed"}
  if not category:
    category = " "
  if not datetimestamp:
    datetimestamp = " "
  if not description:
    description = " "
  transaction = models.Transaction(name=name, amount=amount, category=category, datetimestamp=datetimestamp, description=description)
  db.add(transaction)
  db.commit()
  return transaction

@router.post("/transaction/delete/{id}", tags=["transactions"])
async def delete_transaction(id: int, db: Session = Depends(get_db)):
  transaction = db.query(models.Transaction).filter(models.Transaction.id == id).first()
  if transaction is None:
    raise HTTPException(status_code=404, detail="Transaction not found")
  db.delete(transaction)
  db.commit()
  return {"message":"Successfully delete transaction item"}

##
