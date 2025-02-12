package main

import (
  "encoding/json"
  "io"
  "fmt"
  "net/http"
  "net/url"
  "strconv"
)

type Employee struct {
  FirstName string `json:"firstname"`
  LastName string `json:"lastname"`
  ID int `json:"id"`
  JobTitle string `json:"jobtitle"`
}

var employees []Employee

func restHandler(w http.ResponseWriter, req *http.Request) {
  logger.Info("/rest")
  username, password, _ := req.BasicAuth()
  msg := fmt.Sprintf("============\nREST Handler\n------------\n- URL           : %v\n- Method        : %v\n- Header        : %v\n- Body          : %v\n- Form          : %v\n- PostForm      : %v\n- MultipartForm : %v\n- RemoteAddr    : %v\n- RequestURI    : %v\n- BasicAuth     : %v\n- Context       : %v\n- Cookies       : %v\n- UserAgent     : %v\n", req.URL, req.Method, req.Header, req.Body, req.Form, req.PostForm, req.MultipartForm, req.RemoteAddr, req.RequestURI, fmt.Sprintf("%v %v", username, password), req.Context(), req.Cookies(), req.UserAgent())
  io.WriteString(w, msg)
}

func getEmployees(w http.ResponseWriter, req *http.Request) {
  logger.Info("/rest/employee")
  empsjson, err := json.Marshal(employees)
  if err != nil {
    logger.Error(fmt.Sprintf("ERROR: %v", err))
    return
  }
  w.Write(empsjson)
//  io.WriteString(w, fmt.Sprintf("%v", empsjson))
}

func getEmployeeQuery(w http.ResponseWriter, req *http.Request) {
  logger.Info("/rest/employee/?")
  requrl, err := url.Parse(req.RequestURI)
  if err != nil {
    logger.Error(fmt.Sprintf("ERROR: %v", err))
    return
  }
  reqquery := requrl.Query()
  empid := reqquery.Get("id")
  empfirst := reqquery.Get("firstname")
  emplast := reqquery.Get("lastname")
  empjob := reqquery.Get("jobtitle")
  var employeelist []Employee
  if empid != "" {
    eid, err := strconv.Atoi(empid)
    if err != nil {
      logger.Error(fmt.Sprintf("ERROR: %v", err))
    } else {
      for _, empl := range employees {
        if empl.ID == eid {
          employeelist = append(employeelist, empl)
        }
      }
    }
  }
  if empfirst != "" {
    for _, empl := range employees {
      if empl.FirstName == empfirst {
        employeelist = append(employeelist, empl)
      }
    }
  }
  if emplast != "" {
    for _, empl := range employees {
      if empl.LastName == emplast {
        employeelist = append(employeelist, empl)
      }
    }
  }
  if empjob != "" {
    for _, empl := range employees {
      if empl.JobTitle == empjob {
        employeelist = append(employeelist, empl)
      }
    }
  }
  empsjson, err := json.Marshal(employeelist)
  if err != nil {
    logger.Error(fmt.Sprintf("ERROR: %v", err))
    return
  }
  w.Write(empsjson)
//  io.WriteString(w, fmt.Sprintf("%v", empsjson))
}

func addEmployee(w http.ResponseWriter, req *http.Request) {
  if req.Method != "POST" {
    logger.Error(fmt.Sprintf("Request method not POST: %v", req))
    io.WriteString(w, fmt.Sprintf("Request method must be POST: %v", req))
    return
  } else if req.Body == nil {
    logger.Error(fmt.Sprintf("Request Body empty: %v", req))
    io.WriteString(w, fmt.Sprintf("Request must have Body: %v", req))
    return
  }
  logger.Info("/rest/employee/add")
  var empl Employee
  err := json.NewDecoder(req.Body).Decode(&empl)
  if err != nil {
    logger.Error(fmt.Sprintf("ERROR: %v", err))
    io.WriteString(w, fmt.Sprintf("ERROR: %v", req))
    return
  }
  employees = append(employees, empl)
  empljson, err := json.Marshal(empl)
  if err != nil {
    logger.Error(fmt.Sprintf("ERROR: %v", err))
    io.WriteString(w, fmt.Sprintf("ERROR: %v", req))
    return
  }
  w.Write(empljson)
}