package main

type User struct {
  ID        string  `json:"id"`
  Username  string  `json:"username"`
  Email     string  `json:"email"`
  Password  string  `json:"password"`
}

type appConfig struct {
  Name          string
  ConfigPath    string
  BindHost      string
  BindPort      int
  TLSCert       string
  TLSKey        string
  DBVendor      string
  DBConn        string
  SessionToken  string
}