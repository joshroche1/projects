package main

import (
  "io"
  "fmt"
  "net/http"
)


// /
func indexHandler(w http.ResponseWriter, req *http.Request) {
  logger.Info("/")
  msg := fmt.Sprintf("==================\nSimple HTTP Server\n------------------\nRoutes:\n- http://%v/\n- http://%v/hello\n- http://%v/request\n- http://%v/response\n- http://%v/cookie\n- http://%v/cookie/set\n- http://%v/cookie/get\n- http://%v/jwt\n- http://%v/jwt/set\n- http://%v/jwt/get\n- http://%v/rest/employee\n- http://%v/rest\n- http://%v/config\n", runConfig.BindHostPort, runConfig.BindHostPort, runConfig.BindHostPort, runConfig.BindHostPort, runConfig.BindHostPort, runConfig.BindHostPort, runConfig.BindHostPort, runConfig.BindHostPort, runConfig.BindHostPort, runConfig.BindHostPort, runConfig.BindHostPort, runConfig.BindHostPort, runConfig.BindHostPort)
  io.WriteString(w, msg)
}

// /hello
func helloHandler(w http.ResponseWriter, req *http.Request) {
  logger.Info("/hello")
  io.WriteString(w, "HELLO!\n")
}

// /request
func viewRequest(w http.ResponseWriter, req *http.Request) {
  logger.Info("/request")
  msg := fmt.Sprintf("[REQUEST]\nMethod: %v\nURL: %v\nProto: %v\nProtoMajor: %v\nProtoMinor: %v\nHeader: %v\nBody: %v\nContentLength: %v\nTransferEncoding: %v\nClose: %v\nHost: %v\nForm: %v\nPostForm: %v\nMultipartForm: %v\nTrailer: %v\nRequestURI: %v\nTLS: %v\n", req.Method, req.URL, req.Proto, req.ProtoMajor, req.ProtoMinor, req.Header, req.Body, req.ContentLength, req.TransferEncoding, req.Close, req.Host, req.Form, req.PostForm, req.MultipartForm, req.Trailer, req.RequestURI, req.TLS)
  io.WriteString(w, msg)
}

// /response
func returnResponse(w http.ResponseWriter, req *http.Request) {
  logger.Info("/response")
  msg := fmt.Sprint("[RESPONSE]\nMessage.\n")
  w.Header().Set("Trailer", "End1")
  w.Header().Set("Content-Type", "text/plain; charset=utf-8")
  w.WriteHeader(http.StatusOK)
  io.WriteString(w, msg)
}

// /static
func staticHandler(w http.ResponseWriter, req *http.Request) {
  filename := fmt.Sprintf(".%v", req.URL)
  logger.Info(fmt.Sprintf("%v", filename))
  http.ServeFile(w, req, filename)
}

// /cookie
func setNewCookie(w http.ResponseWriter, req *http.Request) {
  logger.Info("/cookie/set")
  cookie := http.Cookie{
    Name: "NewCookie",
    Value: "Help",
    Path: "/newcookie",
    MaxAge: 3600,
    HttpOnly: true,
    Secure: true,
    SameSite: http.SameSiteLaxMode,
  }
  cookies = append(cookies, &cookie)
  http.SetCookie(w, &cookie)
  io.WriteString(w, fmt.Sprintf("%v", cookie))
}
func getCookie(w http.ResponseWriter, req *http.Request) {
  logger.Info("/cookie/get")
  cookie, err := req.Cookie("NewCookie")
  if err != nil {
    logger.Error(fmt.Sprintf("ERROR: %v", req))
  }
  io.WriteString(w, fmt.Sprintf("COOKIE:\n%v\n", cookie))
}
func showCookies(w http.ResponseWriter, req *http.Request) {
  logger.Info("/cookie/")
  io.WriteString(w, fmt.Sprintf("COOKIES:\n%v\n", cookies))
}

// /jwt/
func setJWTToken(w http.ResponseWriter, req *http.Request) {
  logger.Info("/jwt/set")
  token, err := createJWT()
  if err != nil {
    logger.Error(fmt.Sprintf("ERROR: %v", err))
    io.WriteString(w, fmt.Sprintf("ERROR: %v", err))
    return
  }
  cookie := http.Cookie{
    Name: "jwt",
    Value: token,
    Path: "/jwt/set",
    MaxAge: 3600,
    HttpOnly: true,
    Secure: true,
    SameSite: http.SameSiteLaxMode,
  }
  cookies = append(cookies, &cookie)
  http.SetCookie(w, &cookie)
  io.WriteString(w, fmt.Sprintf("%v", cookie))
}
func getJWTToken(w http.ResponseWriter, req *http.Request) {
  logger.Info("/jwt/get")
  headers := req.Header
  headerValue := headers.Get("Authorization")
  tokenMap, err := parseJWT(headerValue)
  if err != nil {
    logger.Error(fmt.Sprintf("ERROR: %v", err))
    return
  }
  io.WriteString(w, fmt.Sprintf("JWT:\n%v", tokenMap))
}
func showJWTTokens(w http.ResponseWriter, req *http.Request) {
  logger.Info("/jwt/")
  io.WriteString(w, fmt.Sprintf("JWT Token Set:\n%v\n", tokenset))
}

// /config
func showAppConfig(w http.ResponseWriter, req *http.Request) {
  logger.Info("/config")
  msg := fmt.Sprintf("==========\nApp Config:\n----------\n- ConfigPath    : %v\n- BindHost      : %v\n- BindPort      : %v\n- BindHostPort  : %v\n- TLSEnabled    : %v\n- TLSCert       : %v\n- TLSKey        : %v\n- DBVendor      : %v\n- DBConn        : %v\n- JWTSigningKey : %v\n- LogLevel      : %v\n- LogFile       : %v\n", runConfig.ConfigPath, runConfig.BindHost, runConfig.BindPort, runConfig.BindHostPort, runConfig.TLSEnabled, runConfig.TLSCert, runConfig.TLSKey, runConfig.DBVendor, runConfig.DBConn, runConfig.JWTSigningKey, runConfig.LogLevel, runConfig.LogFile)
  io.WriteString(w, fmt.Sprintf("%v", msg))
}