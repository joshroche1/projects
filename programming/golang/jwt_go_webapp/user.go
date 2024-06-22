package main

import (
  "log"
  "net/http"
  "strconv"
  "github.com/gin-gonic/gin"
)

// GET /user
func getUsers(ctx *gin.Context) {
  userlist, err := dbGetUsers()
  if err != nil {
    ctx.IndentedJSON(http.StatusNotFound, gin.H{"message": "Error getting user list"})
  }
  ctx.IndentedJSON(http.StatusOK, userlist)
}

// GET /user/{id}
func getUserByID(ctx *gin.Context) {
  id := ctx.Param("id")
  idint, err := strconv.Atoi(id)
  if err != nil {
    log.Fatal(err)
  }
  entity, err := dbGetUserByID(idint)
  if err != nil {
    ctx.IndentedJSON(http.StatusNotFound, gin.H{"message": "Error getting user"})
  }
  ctx.IndentedJSON(http.StatusOK, entity)
}

// POST /user
func createUser(ctx *gin.Context) {
  var newUser User
  newUsername := ctx.PostForm("username")
  newPassword := ctx.PostForm("password")
  newPassHash, err := hashPassword(newPassword)
  if err != nil {
    log.Printf("Error: %v", err)
    messages = append(messages, "Error pashing password")
    ctx.Redirect(http.StatusFound, "home")
  }
  newUser.Username = newUsername
  newUser.Password = string(newPassHash)
  _, err = dbAddUser(newUser)
  if err != nil {
  log.Printf("Error: %v", err)
    log.Printf("Error: %v", err)
    messages = append(messages, "Error adding user")
    ctx.Redirect(http.StatusFound, "/home")
  }
  ctx.Redirect(http.StatusFound, "/home")
}

// POST /user/delete/{id}
func deleteUser(ctx *gin.Context) {
  id := ctx.PostForm("uid")
  idint, err := strconv.Atoi(id)
  if err != nil {
    log.Fatal(err)
  }
  _, err = dbDeleteUser(idint)
  if err != nil {
    log.Printf("Error: %v", err)
    messages = append(messages, "Error deleting user")
    ctx.Redirect(http.StatusFound, "/home")
  }
  ctx.Redirect(http.StatusFound, "/home")
}
