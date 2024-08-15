package main

import (
  "log"
  "net/http"
  
  "github.com/gin-gonic/gin"
  "github.com/gin-contrib/multitemplate"
  "github.com/gin-contrib/sessions"
)

func createRenderer() multitemplate.Renderer {
  r := multitemplate.NewRenderer()
  r.AddFromFiles("index", "templates/base.html", "templates/index.html")
  r.AddFromFiles("login", "templates/base.html", "templates/login.html")
  r.AddFromFiles("home", "templates/base-user.html", "templates/home.html")
  return r
}

func getIndex(ctx *gin.Context) {
  messages = []string{}
  ctx.HTML(http.StatusOK, "index", gin.H{"title": "Welcome"})
}

func getLoginPage(ctx *gin.Context) {
  messages = []string{}
  ctx.HTML(http.StatusOK, "login", gin.H{"title": "Welcome"})
}

func postLoginAuth(ctx *gin.Context) {
  session := sessions.Default(ctx)
  loginUsername := ctx.PostForm("username")
  loginPassword := ctx.PostForm("password")
  entity, err := dbGetUserByUsername(loginUsername)
  if err != nil {
    log.Printf("Error: %v", err)
    messages = append(messages, "Incorrect Login credentials")
    ctx.Redirect(http.StatusNotFound, "/login")
  }
  _, err = compareHashedPasswords(loginPassword, []byte(entity.Password))
  if err != nil {
    log.Printf("Error: %v", err)
    messages = append(messages, "Incorrect Login credentials")
    ctx.Redirect(http.StatusUnauthorized, "/login")
  }
  session.Set("user", entity.Username)
  session.Save()
  messages = append(messages, "Logged in")
  ctx.Redirect(http.StatusFound, "/home")
}

func getLogout(ctx *gin.Context) {
  session := sessions.Default(ctx)
  session.Clear()
  session.Save()
  messages = append(messages, "Logout")
  ctx.Redirect(http.StatusFound, "/")
}

func getHomeView(ctx *gin.Context) {
  messages = []string{}
  session := sessions.Default(ctx)
  loginuser := session.Get("user")
  if loginuser == nil {
    messages = append(messages, "You must be logged in to view")
    ctx.Redirect(http.StatusFound, "/login")
  }
  sessionID := session.ID()
  userlist, err := dbGetUsers()
  if err != nil {
    log.Printf("Error: %v", err)
  }
  ctx.HTML(http.StatusOK, "home", gin.H{"title": "Home", "loginuser": loginuser, "userlist": userlist, "sessionid": sessionID})
}