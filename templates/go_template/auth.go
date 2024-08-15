package main

import (
  bcrypt "golang.org/x/crypto/bcrypt"
)

func hashPassword(strpasswd string) ([]byte, error) {
  bytepasswd := []byte(strpasswd)
  passhash, err := bcrypt.GenerateFromPassword(bytepasswd, 10)
  if err != nil {
    return nil, err
  }
  return passhash, nil
}

func compareHashedPasswords(formpasswd string, dbpasswd []byte) (string, error) {
  formbytes := []byte(formpasswd)
  err := bcrypt.CompareHashAndPassword(dbpasswd, formbytes)
  if err != nil {
    return "", err
  }
  return formpasswd, nil
}