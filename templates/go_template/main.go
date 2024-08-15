package main

import (
  "database/sql"
  "flag"
  "fmt"
  "log"
  "os"
  "strings"
  "strconv"
  
  yaml "gopkg.in/yaml.v3"
  "github.com/gin-gonic/gin"
  "github.com/gin-contrib/sessions"
  "github.com/gin-contrib/sessions/cookie"
)

var db *sql.DB
var runConfig appConfig
var messages []string

func main() {
  runConfig.Name = "SMC"
  var configpath string
  var bindhost string
  var bindport int
  var tlscert string
  var tlskey string
  var dbvendor string
  var dbconn string
  var sessiontok string
  var help string
  var bindhostport string
  var ginmode string

  flag.StringVar(&configpath,"config.path","","Path to configuration file")
  flag.StringVar(&bindhost,"bind.host","127.0.0.1","Host address to bind to")
  flag.IntVar(&bindport,"bind.port",8000,"TCP Port to listen on")
  flag.StringVar(&tlscert,"tls.cert","","TLS Certificate for HTTPS")
  flag.StringVar(&tlskey,"tls.key","","TLS Key for HTTPS")
  flag.StringVar(&dbvendor,"db.vendor","sqlite3","Database Vendor, eg. SQLite3")
  flag.StringVar(&dbconn,"db.connect","./db.sqlite","Database connection, File or HOST:PORT")
  flag.StringVar(&dbconn,"session.token","SeCrEt-T0K3N","String used as session secret token")
  flag.StringVar(&ginmode,"mode","debug","Runtime Mode: debug, release")
  flag.StringVar(&help,"help","","Show Help")

  flag.Parse()
  var tls_server bool = false

  if (configpath != "") {
    // Read/Parse config.yml
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
    bindportstr := strconv.Itoa(bindport)
    bhparr := []string{bindhost, bindportstr}
    bindhostport = strings.Join(bhparr, ":")
    tlscert = configdata["TLS_CERTFILE"].(string)
    tlskey = configdata["TLS_KEYFILE"].(string)
    dbvendor = configdata["DB_VENDOR"].(string)
    dbconn = configdata["DB_CONN"].(string)
    sessiontok = configdata["SESSION_TOKEN"].(string)
    ginmode = configdata["MODE"].(string)
  } else if (help != "") {
    var showusage = `
    Usage: ./webapp [OPTIONS]
    
    OPTIONS [FILE VARIABLE]:
      --config.path                    Path to configuration file
      --bind.host     [BIND_HOST]      Host address to bind to
      --bind.port     [BIND_PORT]      TCP Port to listen on
      --tls.cert      [TLS_CERT]       TLS Certificate for HTTPS
      --tls.key       [TLS_KEY]        TLS Key for HTTPS
      --db.vendor     [DB_VENDOR]      Database Vendor, eg. SQLite3
      --db.connect    [DB_CONN]        Database connection, File or HOST:PORT
      --session.token [SESSION_TOKEN]  String used as session secret token
      --mode          [MODE]           Runtime Mode: debug, release
      -h                               Show this help message
    `
    fmt.Println(showusage)
    os.Exit(0)
  }
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

  log.Printf("Bind Address: %v\n", bindhost)
  log.Printf("Bind Port   : %v\n", bindport)
  if (tls_server) {
    log.Printf("TLS Cert    : %v\n", tlscert)
    log.Printf("TLS Key     : %v\n", tlskey)
  }
  log.Printf("DB Vendor   : %v\n", dbvendor)
  log.Printf("DB Connect  : %v\n", dbconn)

  bindportstr := strconv.Itoa(bindport)
  bhparr := []string{bindhost, bindportstr}
  bindhostport = strings.Join(bhparr, ":")
  
  db := dbConn()
  pingErr := db.Ping()
  if pingErr != nil {
    log.Fatal(pingErr)
  }
  log.Printf("Connected to DB")
  
  dbInit()
  
  if ginmode != "debug" {
    gin.SetMode(gin.ReleaseMode)
  }
  log.Printf("Mode        : %v\n", ginmode)
  
  router := gin.Default()
  
  sessionStore := cookie.NewStore([]byte("SeCrEtKeY"))
  router.Use(sessions.Sessions("ActiveSession", sessionStore))
  router.HTMLRender = createRenderer()
  //router.LoadHTMLGlob("templates/*")
  router.Static("/static", "./static")
  
  router.GET("/", getIndex)
  router.GET("/login", getLoginPage)
  router.POST("/login", postLoginAuth)
  router.GET("/logout", getLogout)
  router.GET("/home", getHomeView)
  router.POST("/user/checkpw", postUserCheckPW) // test
  router.GET("/user", getUsers)
  router.GET("/user/:id", getUserByID)
  router.POST("/user", postUser)
  router.POST("/user/delete/:id", deleteUser)
    
  router.Run(bindhostport)
}