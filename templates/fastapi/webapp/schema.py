from typing import List, Union

from pydantic import BaseModel


class UserBase(BaseModel):
  email: str
  username: str


class UserCreate(UserBase):
  password: bytes


class User(UserBase):
  id: int

  class Config:
    orm_mode = True


class TransactionBase(BaseModel):
  name: str
  amount: float
  datetimestamp: str


class TransactionCreate(TransactionBase):
  category: str
  description: str


class Transaction(UserBase):
  id: int

  class Config:
    orm_mode = True
