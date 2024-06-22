package main

import (
  "log"
  "time"

  "github.com/golang-jwt/jwt"
  bcrypt "golang.org/x/crypto/bcrypt"
)

func getLoginToken(loginUsername string, loginPassword string) (string, error) {
  entity, err := dbGetUserByUsername(loginUsername)
  if err != nil {
    return "", err
  }
  _, err = compareHashedPasswords(loginPassword, []byte(entity.Password))
  if err != nil {
    return "", err
  } else {
    mySigningKey := []byte(runConfig.SessionToken)
    dateTimeNow := time.Now()
    expDateTime := dateTimeNow.Add(time.Minute * 5)
    newClaims := jwt.MapClaims {
      "iss": "gowebapp",
      "exp": expDateTime.Unix(),
      //"sub": "subject",
      "aud": entity.Username,
      //"nbf": "not before",
      "iat": dateTimeNow.Unix(),
    }
    token := jwt.NewWithClaims(jwt.SigningMethodHS256, newClaims)
    stoken, err := token.SignedString(mySigningKey)
    if err != nil {
      log.Printf("Error: %v", err)
      return "", err
    }
    return stoken, nil
  }
}

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
