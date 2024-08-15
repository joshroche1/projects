package main

import (
  "log"
  "net/http"
  "strconv"
  "github.com/gin-gonic/gin"
)

// User //

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
func postUser(ctx *gin.Context) {
  var newUser User
  newUsername := ctx.PostForm("username")
  newEmail := ctx.PostForm("email")
  newPassword := ctx.PostForm("password")
  newPassHash, err := hashPassword(newPassword)
  if err != nil {
    log.Printf("Error: %v", err)
    ctx.IndentedJSON(http.StatusNotFound, gin.H{"message": "Error hashing password"})
  }
  newUser.Username = newUsername
  newUser.Email = newEmail
  newUser.Password = string(newPassHash)
  entity, err := dbAddUser(newUser)
  if err != nil {
  log.Printf("Error: %v", err)
    ctx.IndentedJSON(http.StatusNotFound, gin.H{"message": "Error adding user"})
  }
  ctx.IndentedJSON(http.StatusCreated, entity)
}

// POST /user/delete/{id}
func deleteUser(ctx *gin.Context) {
  id := ctx.Param("id")
  idint, err := strconv.Atoi(id)
  if err != nil {
    log.Fatal(err)
  }
  result, err := dbDeleteUser(idint)
  if err != nil {
    ctx.IndentedJSON(http.StatusNotFound, gin.H{"message": "Error deleting user"})
  }
  ctx.IndentedJSON(http.StatusOK, result)
}

// POST /user/checkpw
func postUserCheckPW(ctx *gin.Context) {
  formUsername := ctx.PostForm("username")
  formPassword := ctx.PostForm("password")
  entity, err := dbGetUserByUsername(formUsername)
  if err != nil {
    log.Printf("Error: %v", err)
    ctx.IndentedJSON(http.StatusNotFound, gin.H{"message": "Error getting user"})
    return
  }
  _, err = compareHashedPasswords(formPassword, []byte(entity.Password))
  if err != nil {
    log.Printf("Error: %v", err)
    ctx.IndentedJSON(http.StatusNotFound, gin.H{"message": "Error comparing passwords"})
    return
  }
  ctx.IndentedJSON(http.StatusOK, entity)
}