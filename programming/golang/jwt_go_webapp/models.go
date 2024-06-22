package main


type appConfig struct {
  Name          string  `json:"name"`
  BindHost      string  `json:"bindhost"`
  BindPort      int     `json:"bindport"`
  TLSCert       string  `json:"tlscert"`
  TLSKey        string  `json:"tlskey"`
  DBVendor      string  `json:"dbvendor"`
  DBConn        string  `json:"dbconn"`
  SessionToken  string  `json:"sessiontoken"`
  GinMode       string  `json:"mode"`
  LogFile       string  `json:"logfile"`
}

type User struct {
  ID       string `json:"id"`
  Username string `json:"username"`
  Password string `json:"password"`
}
