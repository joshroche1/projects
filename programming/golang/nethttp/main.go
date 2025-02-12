package main

import (
  "fmt"
  "io"
  "log/slog"
  "net/http"
  "os"
)


var cookies []*http.Cookie
var signingKey []byte
var runConfig AppConfig
var logger *slog.Logger

func main() {
  // Simple HTTP Server
  fmt.Println("==================\nSimple HTTP Server\n------------------")

  var logwriter io.Writer
  runConfig, err := parseConfig()
  if err != nil {
    fmt.Printf("ERROR: %v", err)
    logwriter = os.Stdout
  } else {
    logf, _ := os.Create(runConfig.LogFile)
    logwriter = io.MultiWriter(logf, os.Stdout)
  }
  logger = slog.New(slog.NewTextHandler(
    logwriter,
    nil,
  ))

  emp1 := Employee{
    FirstName: "John",
    LastName: "Doe",
    ID: 1,
    JobTitle: "Accountant",
  }
  emp2 := Employee{
    FirstName: "Jane",
    LastName: "Doe",
    ID: 2,
    JobTitle: "System Administrator",
  }
  emp3 := Employee{
    FirstName: "Jim",
    LastName: "Bob",
    ID: 3,
    JobTitle: "Office Manager",
  }
  employees = append(employees, emp1)
  employees = append(employees, emp2)
  employees = append(employees, emp3)

  logger.Info(fmt.Sprintf("Config Path : %v\n", runConfig.ConfigPath))
  logger.Info(fmt.Sprintf("Bind Address: %v\n", runConfig.BindHost))
  logger.Info(fmt.Sprintf("Bind Port   : %v\n", runConfig.BindPort))
  if (runConfig.TLSEnabled) {
    logger.Info(fmt.Sprintf("TLS Cert    : %v\n", runConfig.TLSCert))
    logger.Info(fmt.Sprintf("TLS Key     : %v\n", runConfig.TLSKey))
  }
  logger.Info(fmt.Sprintf("DB Vendor   : %v\n", runConfig.DBVendor))
  logger.Info(fmt.Sprintf("DB Connect  : %v\n", runConfig.DBConn))
  logger.Info(fmt.Sprintf("Log Level   : %v\n", runConfig.LogLevel))
  logger.Info(fmt.Sprintf("Log File    : %v\n", runConfig.LogFile))
  
  http.HandleFunc("/hello", helloHandler)
  http.HandleFunc("/request", viewRequest)
  http.HandleFunc("/response", returnResponse)
  http.HandleFunc("/static/", staticHandler)
  http.HandleFunc("/cookie/set", setNewCookie)
  http.HandleFunc("/cookie/get", getCookie)
  http.HandleFunc("/cookie/", showCookies)
  http.HandleFunc("/jwt/set", setJWTToken)
  http.HandleFunc("/jwt/get", getJWTToken)
  http.HandleFunc("/jwt/", showJWTTokens)
  http.HandleFunc("/rest/employee/", getEmployeeQuery)
  http.HandleFunc("/rest/employee/all", getEmployees)
  http.HandleFunc("/rest/employee/add", addEmployee)
  http.HandleFunc("/rest", restHandler)
  http.HandleFunc("/config", showAppConfig)
  http.HandleFunc("/", indexHandler)

  if (runConfig.TLSEnabled) {
    logger.Info(fmt.Sprintf("[HTTPS] Server Start - https://%v/", runConfig.BindHostPort))
    err = http.ListenAndServeTLS(runConfig.BindHostPort, runConfig.TLSCert, runConfig.TLSKey, nil)
    logger.Error(fmt.Sprintf("ERROR: %v", err))
  } else {
    logger.Info(fmt.Sprintf("[HTTP] Server Start - http://%v/", runConfig.BindHostPort))
    err = http.ListenAndServe(runConfig.BindHostPort, nil)
    logger.Error(fmt.Sprintf("ERROR: %v", err))
  }
}