package main

import (
  "fmt"
  "log"
  "net/http"

  "github.com/gin-gonic/gin"
  "github.com/gin-contrib/multitemplate"
  "github.com/gin-contrib/sessions"
  "github.com/golang-jwt/jwt"
)

func createRenderer() multitemplate.Renderer {
  r := multitemplate.NewRenderer()
  r.AddFromFiles("index", "templates/base.html", "templates/index.html")
  r.AddFromFiles("login", "templates/base.html", "templates/login.html")
  r.AddFromFiles("home", "templates/base.html", "templates/home.html")
  return r
}

func getIndexPage(ctx *gin.Context) {
  messages = []string{}
  ctx.HTML(http.StatusOK, "index", gin.H{"title": "Welcome", "messages": messages})
}

func getLoginPage(ctx *gin.Context) {
  messages = []string{}
  ctx.HTML(http.StatusOK, "login", gin.H{"title": "Login", "messages": messages})
}

func postLogin(ctx *gin.Context) {
  messages = []string{}
  username := ctx.PostForm("username")
  password := ctx.PostForm("password")
  loginToken, err := getLoginToken(username,password)
  if err != nil {
    messages = append(messages, fmt.Sprintf("Error: %v", err))
    ctx.HTML(http.StatusForbidden, "login", gin.H{"title": "Login", "messages": messages})
  } else {
    session := sessions.Default(ctx)
    session.Set("token", loginToken)
    session.Save()
    if err != nil {
      messages = append(messages, fmt.Sprintf("Error: %v", err))
    }
    userlist, err := dbGetUsers()
    if err != nil {
      messages = append(messages, "Error fetching users")
    }
    messages = append(messages, "Login Successful")
    ctx.HTML(http.StatusOK, "home", gin.H{"title": "Home", "messages": messages, "loginuser": username, "userlist": userlist})
  }  
}

func getHomePage(ctx *gin.Context) {
  messages = []string{}
  session := sessions.Default(ctx)
  sessiontoken := session.Get("token").(string)
  result, err := validateToken(sessiontoken)
  if err != nil {
    messages = append(messages, fmt.Sprintf("Error: %v", err))
    ctx.HTML(http.StatusForbidden, "login", gin.H{"title": "Login", "messages": messages})
  }
  if result == "" {
    messages = append(messages, fmt.Sprintf("Error: %v", err))
    ctx.HTML(http.StatusForbidden, "login", gin.H{"title": "Login", "messages": messages})
  }
  userlist, err := dbGetUsers()
  if err != nil {
    messages = append(messages, "Error fetching users")
  }
  ctx.HTML(http.StatusOK, "home", gin.H{"title": "Home", "messages": messages, "loginuser": result, "userlist": userlist})
}

func getLogout(ctx *gin.Context) {
  messages = []string{}
  session := sessions.Default(ctx)
  session.Clear()
  session.Save()
  log.Printf("Logout")
  messages = append(messages, "Logout")
  ctx.HTML(http.StatusOK, "index", gin.H{"title": "Welcome", "messages": messages})
}

func parseToken(sessionToken string) (*jwt.Token, error) {
  var token *jwt.Token
  token, err := jwt.Parse(sessionToken, func(token *jwt.Token) (interface{}, error) {
	  // Don't forget to validate the alg is what you expect:
	  if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
		  return token, fmt.Errorf("Unexpected signing method: %v", token.Header["alg"])
	  }
	  return []byte(runConfig.SessionToken), nil
  })
  if err != nil {
    return token, err
  }
  return token, nil
}

func validateToken(sessionToken string) (string, error) {
  token, err := jwt.Parse(sessionToken, func(token *jwt.Token) (interface{}, error) {
	  // Don't forget to validate the alg is what you expect:
	  if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
		  return nil, fmt.Errorf("Unexpected signing method: %v", token.Header["alg"])
	  }
	  return []byte(runConfig.SessionToken), nil
  })
  if err != nil {
	  log.Printf("Error: %v", err)
	  return "", err
  }
  if claims, ok := token.Claims.(jwt.MapClaims); ok {
    return claims["aud"].(string), nil
  } else {
    return "", nil
  }
}