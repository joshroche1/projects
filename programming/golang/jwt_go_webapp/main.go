package main

import (
  "flag"
  "log"
  "os"
  "strconv"
  "strings"

  "github.com/gin-gonic/gin"
  "github.com/gin-contrib/sessions"
  "github.com/gin-contrib/sessions/cookie"
  yaml "gopkg.in/yaml.v3"
)

var runConfig appConfig
var messages []string

func main() {
  runConfig.Name = "GoWebApp"
  var configpath string
  var bindhost string
  var bindport int
  var bindhostport string
  var tlscert string
  var tlskey string
  var dbvendor string
  var dbconn string
  var sessiontok string
  var ginmode string
  var logfile string
  
  flag.StringVar(&configpath, "config.path", "", "Path to Config File")
  flag.StringVar(&bindhost, "bind.host", "127.0.0.1", "Host address")
  flag.IntVar(&bindport, "bind.port", 8000, "Host port")
  flag.StringVar(&tlscert, "tls.cert", "", "TLS Certificate")
  flag.StringVar(&tlskey, "tls.key", "", "TLS Key")
  flag.StringVar(&dbvendor, "db.vendor", "sqlite3", "Database Vendor")
  flag.StringVar(&dbconn, "db.conn", "./db.sqlite", "Database connection string")
  flag.StringVar(&sessiontok, "session.token", "S3Cr3tK3Y", "Session token")
  flag.StringVar(&ginmode, "mode", "debug", "GIN Mode")
  flag.StringVar(&logfile, "log.file", "gowebapp.log", "Log File path")
  
  flag.Parse()
  
  var tls_server bool = false

  if (configpath != "") {
    configfile, err := os.ReadFile(configpath)
    if err != nil {
      log.Fatal(err)
    }
    var configdata map[string]interface{}
    err = yaml.Unmarshal(configfile, &configdata)
    if err != nil {
      log.Fatal(err)
    }
    bindhost = configdata["BINDHOST"].(string)
    bindport = configdata["BINDPORT"].(int)
    tlscert = configdata["TLS_CERTFILE"].(string)
    tlskey = configdata["TLS_KEYFILE"].(string)
    dbvendor = configdata["DB_VENDOR"].(string)
    dbconn = configdata["DB_CONN"].(string)
    sessiontok = configdata["SESSION_TOKEN"].(string)
    ginmode = configdata["MODE"].(string)
    logfile = configdata["LOGFILE"].(string)
  }
  bindportstr := strconv.Itoa(bindport)
  bhparr := []string{bindhost, bindportstr}
  bindhostport = strings.Join(bhparr, ":")
  if (tlscert != "") && (tlskey != "") {
    tls_server = true
  }
  runConfig.BindHost = bindhost
  runConfig.BindPort = bindport
  runConfig.TLSCert = tlscert
  runConfig.TLSKey = tlskey
  runConfig.DBVendor = dbvendor
  runConfig.DBConn = dbconn
  runConfig.SessionToken = sessiontok
  
  log.Printf("Config Path : %v\n", configpath)
  log.Printf("Bind Address: %v\n", bindhost)
  log.Printf("Bind Port   : %v\n", bindport)
  if (tls_server) {
    log.Printf("TLS Cert    : %v\n", tlscert)
    log.Printf("TLS Key     : %v\n", tlskey)
  }
  log.Printf("DB Vendor   : %v\n", dbvendor)
  log.Printf("DB Connect  : %v\n", dbconn)
  log.Printf("Mode        : %v\n", ginmode)
  log.Printf("Log File    : %v\n", logfile)
  
  router := gin.Default()
  
  sessionStore := cookie.NewStore([]byte(sessiontok))
  router.Use(sessions.Sessions("ActiveSession", sessionStore))
  router.HTMLRender = createRenderer()
  
  router.GET("/", getIndexPage)
  router.GET("/login", getLoginPage)
  router.POST("/login", postLogin)
  router.GET("/logout", getLogout)
  router.GET("/home", getHomePage)
  router.POST("/user", createUser)
  router.POST("/user/delete", deleteUser)

  router.Run(bindhostport)
}