package net.jar.webapp.Controller;


import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.PreparedStatement;
import java.sql.DriverManager;
import java.util.Properties;
import java.sql.SQLException;

import javax.faces.application.FacesMessage;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.SessionScoped;
import javax.faces.context.FacesContext;

import net.jar.webapp.Controller.SessionUtils;
import net.jar.webapp.Configuration;


public class Datasource {
  
  private String dbVendor;
  private String dbName;
  private String dbHost;
  private String dbPort;
  private String dbUsername;
  private String dbPassword;
  
  private String dbDriver;
  private String dbUrl;
  private Connection conn = null;
  private ResultSet rs = null;
  
  
  public DBUtil() {
    initDbParams();
  }

  private void systemMessage(String msg) {
    FacesContext.getCurrentInstance().addMessage("showmessages", new FacesMessage(
        FacesMessage.SEVERITY_WARN, msg, "..."));
  }
  private void initDbParams() {
    try {
      Configuration config = new Configuration();
      dbVendor = config.getDbVendor();
      dbName = config.getDbName();
      dbHost = config.getDbHost();
      dbPort = config.getDbPort();
      dbUsername = config.getDbUsername();
      dbPassword = config.getDbPassword();
      switch (dbVendor) {
        case "sqlite3": dbDriver = "org.sqlite.JDBC"; dbUrl = "jdbc:sqlite:" + dbName + ".db"; break; 
        case "postgresql": dbDriver = "org.postgresql.Driver"; dbUrl = "jdbc:postgresql://" + dbHost + ":" + dbPort + "/" + dbName; break;
        // case "mysql": dbDriver = ""; dbUrl = "" + dbHost + ":" + dbPort + "/" + dbname; break;
        // case "mariadb": dbDriver = ""; dbUrl = "" + dbHost + ":" + dbPort + "/" + dbname; break;
        default: dbDriver = "org.sqlite.JDBC"; dbUrl = "jdbc:sqlite:webapp.db"; break;
      }
    } catch (Exception ex) {
      systemMessage(ex.getMessage());
    }
  }
  private Connection connect() {
    try {
      Class.forName(dbDriver);
      conn = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);
    } catch (Exception ex) {
      systemMessage(ex.getMessage());
    }
    return conn;
  }
  public ResultSet selectOne(String sqlstmt) {
    try {
      conn = this.connect();
      PreparedStatement pstmt = conn.prepareStatement(sqlstmt, ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
      rs = pstmt.executeQuery();
    } catch (Exception ex) {
      systemMessage(ex.getMessage());
    }
    return rs;
  }

}
