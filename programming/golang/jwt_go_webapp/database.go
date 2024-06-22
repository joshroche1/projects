package main

import (
  "database/sql"
  "fmt"
  "log"
  "strconv"

  _ "github.com/mattn/go-sqlite3"
)

func dbConn() *sql.DB {
  db, err := sql.Open(runConfig.DBVendor, runConfig.DBConn)
  if err != nil {
    log.Fatal(err)
  }
  return db
}

func dbInit() {
  db := dbConn()
  sqlStmt := `
  drop table if exists users;
  create table users (id integer not null primary key, username text, password text);
  insert into users values (1, 'admin', '$2a$10$Krux7MEZWVvhI/8lZHAXeOsMdd9e/ndhOECU6CqCc/7V.6VMp5lam');
  `
  _, err := db.Exec(sqlStmt)
  if err != nil {
    log.Fatal(err)
  }
}

// Users

func dbGetUsers() ([]User, error) {
  db := dbConn()
  userlist := []User{}
  rows, err := db.Query("select id,username,password from users")
  if err != nil { 
    return nil, fmt.Errorf("Error: %v", err)
  }
  for rows.Next() {
    var newUser User
    var id int
    var username string
    var password string
    err = rows.Scan(&id, &username, &password)
    if err != nil {
      return nil, fmt.Errorf("Error: %v", err)
    }
    newUser.ID = strconv.Itoa(id)
    newUser.Username = username
    newUser.Password = password
    userlist = append(userlist, newUser)
  }
  return userlist, nil
}

func dbGetUserByID(id int) (User, error) {
  db := dbConn()
  var entity User
  row := db.QueryRow("select id,username,password from users where id = ?", id)
  if err := row.Scan(&entity.ID, &entity.Username, &entity.Password); err != nil {
    if err == sql.ErrNoRows {
      return entity, fmt.Errorf("User not found: %d", id)
    }
    return entity, fmt.Errorf("Error: %v", err)
  }
  return entity, nil
}

func dbGetUserByUsername(name string) (User, error) {
  db := dbConn()
  var entity User
  row := db.QueryRow("select id,username,password from users where username = ?", name)
  if err := row.Scan(&entity.ID, &entity.Username, &entity.Password); err != nil {
    if err == sql.ErrNoRows {
      return entity, fmt.Errorf("User not found: %v", name)
    }
    return entity, fmt.Errorf("Error: %v", err)
  }
  return entity, nil
}

func dbAddUser(newUser User) (User, error) {
  db := dbConn()
  _, err := db.Exec("insert into users (username, password) values (?, ?)", newUser.Username, newUser.Password)
  if err != nil { 
    return newUser, fmt.Errorf("Error adding user: %v", err)
  }
  return newUser, nil
}

func dbDeleteUser(id int) (int, error) {
  db := dbConn()
  _, err := db.Exec("delete from users where id = ?", id)
  if err != nil {
    return 0, fmt.Errorf("Error deleting user [%d]: %v", id, err)
  }
  return id, nil
}