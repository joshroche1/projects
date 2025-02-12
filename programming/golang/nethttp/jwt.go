package main

import (
  "fmt"
  "strings"
  "time"

  jwt "github.com/golang-jwt/jwt/v5"
)


var tokenset []*jwt.Token

type CustomClaims struct {
  Name string `json:"name"`
  jwt.RegisteredClaims
}

func createJWT() (string, error) {
  claims := CustomClaims{
    "JWT-claims",
    jwt.RegisteredClaims{
      ExpiresAt: jwt.NewNumericDate(time.Now().Add(24*time.Hour)),
      IssuedAt: jwt.NewNumericDate(time.Now()),
      NotBefore: jwt.NewNumericDate(time.Now()),
      Issuer: "TEST",
      Subject: "jwt_auth",
      ID: "1",
      Audience: []string{"user"},
    },
  }
  token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
  tokenString, err := token.SignedString(runConfig.JWTSigningKey)
  if err != nil {
    logger.Error(fmt.Sprintf("ERROR: %v", err))
    return "", err
  }
  tokenset = append(tokenset, token)
  return tokenString, nil
}

func parseJWT(strValue string) (map[string]string, error) {
  tok := strings.Replace(strValue, "Bearer","",-1)
  tokn := strings.Trim(tok, " ")
  token, err := jwt.ParseWithClaims(tokn, &CustomClaims{}, func(token *jwt.Token) (interface{}, error) {
    if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
      return nil, fmt.Errorf("Unexpected signing method: %v", token.Header["alg"])
    }
    return []byte(runConfig.JWTSigningKey), nil
  })
  if err != nil {
    logger.Error(fmt.Sprintf("ERROR: %v", err))
    return nil, err
  }
  if claims, ok := token.Claims.(*CustomClaims); ok {
    result := map[string]string{
      "Name": claims.Name,
      "IssuedAt": fmt.Sprintf("%v", claims.RegisteredClaims.IssuedAt), 
      "NotBefore": fmt.Sprintf("%v", claims.RegisteredClaims.NotBefore), 
      "ExpiresAt": fmt.Sprintf("%v", claims.RegisteredClaims.ExpiresAt), 
      "Issuer": fmt.Sprintf("%v", claims.RegisteredClaims.Issuer), 
      "Subject": fmt.Sprintf("%v", claims.RegisteredClaims.Subject), 
      "ID": fmt.Sprintf("%v", claims.RegisteredClaims.ID), 
      "Audience": fmt.Sprintf("%v", claims.RegisteredClaims.Audience),
    }
    return result, nil
  } else {
    logger.Error(fmt.Sprintf("ERROR: %v", err))
    return nil, err
  }
}