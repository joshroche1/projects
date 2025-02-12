package main

import (
  "flag"
  "fmt"
  "os"
  "strconv"
  "strings"

  yaml "gopkg.in/yaml.v3"
)

type AppConfig struct {
  ConfigPath string
  BindHost string
  BindPort int
  BindHostPort string
  TLSEnabled bool
  TLSCert string
  TLSKey string
  DBVendor string
  DBConn string
  JWTSigningKey []byte
  LogLevel string
  LogFile string
}

func parseConfig() (AppConfig, error) {
  var configpath string
  var bindhost string
  var bindport int
  var bindhostport string
  var tlscert string
  var tlskey string
  var dbvendor string
  var dbconn string
  var jwtsiginingkey string
  var loglevel string
  var logfile string
  var tls_server bool = false

  flag.StringVar(&configpath,"config.path","","Path to configuration file")
  flag.StringVar(&bindhost,"bind.host","127.0.0.1","Host address to bind to")
  flag.IntVar(&bindport,"bind.port",8080,"TCP Port to listen on")
  flag.BoolVar(&tls_server,"tls.enabled",false,"Enable TLS")
  flag.StringVar(&tlscert,"tls.cert","","TLS Certificate for HTTPS")
  flag.StringVar(&tlskey,"tls.key","","TLS Key for HTTPS")
  flag.StringVar(&dbvendor,"db.vendor","sqlite3","Database Vendor, eg. SQLite3")
  flag.StringVar(&dbconn,"db.connect","./db.sqlite","Database connection, File or HOST:PORT")
  flag.StringVar(&jwtsiginingkey,"jwt.signingkey","SeCrEt-T0K3N","String used as JWT Signing Key")
  flag.StringVar(&loglevel,"log.level","info","Log Level: info, debug")
  flag.StringVar(&logfile,"log.file","webapp.log","Log File Path")

  flag.Parse()
  
  _, isset := os.LookupEnv("APP_BINDHOST")
  if isset {
    bindhost, _ = os.LookupEnv("APP_BINDHOST")
  }
  _, isset = os.LookupEnv("APP_BINDPOST")
  if isset {
    tmpint, _ := os.LookupEnv("APP_BINDPORT")
    tmpport, err := strconv.Atoi(tmpint)
    if err != nil {
      tmpport = 8080
    }
    bindport = tmpport
  }
  _, isset = os.LookupEnv("APP_TLS_ENABLED")
  if isset {
    tmpbool, _ := os.LookupEnv("APP_TLS_ENABLED")
    if tmpbool == "true" {
      tls_server = true
    } else {
      tls_server = false
    }
  }
  _, isset = os.LookupEnv("APP_TLS_CERTFILE")
  if isset {
    tlscert, _ = os.LookupEnv("APP_TLS_CERTFILE")
  }
  _, isset = os.LookupEnv("APP_TLS_KEYFILE")
  if isset {
    tlskey, _ = os.LookupEnv("APP_TLS_KEYFILE")
  }
  _, isset = os.LookupEnv("APP_DB_VENDOR")
  if isset {
    dbvendor, _ = os.LookupEnv("APP_DB_VENDOR")
  }
  _, isset = os.LookupEnv("APP_DB_CONN")
  if isset {
    dbconn, _ = os.LookupEnv("APP_DB_CONN")
  }
  _, isset = os.LookupEnv("APP_JWT_SIGNING_KEY")
  if isset {
    jwtsiginingkey, _ = os.LookupEnv("APP_JWT_SIGNING_KEY")
  }
  _, isset = os.LookupEnv("APP_LOG_LEVEL")
  if isset {
    loglevel, _ = os.LookupEnv("APP_LOG_LEVEL")
  }
  _, isset = os.LookupEnv("APP_LOGFILE")
  if isset {
    logfile, _ = os.LookupEnv("APP_LOGFILE")
  }

  if (configpath != "") {
    configfile, err := os.ReadFile(configpath)
    if err != nil {
      fmt.Printf("ERROR: %v", err)
    }
    var configdata map[string]interface{}
    err = yaml.Unmarshal(configfile, &configdata)
    if err != nil {
      fmt.Printf("ERROR: %v", err)
    }
    bindhost = configdata["APP_BINDHOST"].(string)
    bindport = configdata["APP_BINDPORT"].(int)
    tls_server = configdata["APP_TLS_ENABLED"].(bool)
    tlscert = configdata["APP_TLS_CERTFILE"].(string)
    tlskey = configdata["APP_TLS_KEYFILE"].(string)
    dbvendor = configdata["APP_DB_VENDOR"].(string)
    dbconn = configdata["APP_DB_CONN"].(string)
    jwtsiginingkey = configdata["APP_JWT_SIGNING_KEY"].(string)
    loglevel = configdata["APP_LOG_LEVEL"].(string)
    logfile = configdata["APP_LOGFILE"].(string)
  }
  
  bindportstr := strconv.Itoa(bindport)
  bhparr := []string{bindhost, bindportstr}
  bindhostport = strings.Join(bhparr, ":")
  if (tlscert != "") && (tlskey != "") {
    tls_server = true
  }
  runConfig.BindHost = bindhost
  runConfig.BindPort = bindport
  runConfig.BindHostPort = bindhostport
  runConfig.TLSEnabled = tls_server
  runConfig.TLSCert = tlscert
  runConfig.TLSKey = tlskey
  runConfig.DBVendor = dbvendor
  runConfig.DBConn = dbconn
  runConfig.LogLevel = loglevel
  runConfig.LogFile = logfile
  runConfig.JWTSigningKey = []byte(jwtsiginingkey)

  return runConfig, nil
}