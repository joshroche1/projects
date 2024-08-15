package net.jar.webapp;


import javax.enterprise.context.ApplicationScoped;
import javax.faces.application.FacesMessage;
import javax.faces.bean.ManagedBean;
import javax.faces.context.FacesContext;

import org.eclipse.microprofile.config.inject.ConfigProperty;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;


@ApplicationScoped
@ManagedBean(name = "beanConfig", eager = true)
public class Configuration {
  
  private static String dbVendor;
  private static String dbName;
  private static String dbHost;
  private static String dbPort;
  private static String dbUsername;
  private static String dbPassword;
  private static String jdbcDriver;
  private static String dbURL;
  
  public Configuration() {
    init();
  }
  
  private void init() {
    try {
      Properties props = new Properties();
      InputStream input = new FileInputStream("application.properties");
      props.load(input);
      dbVendor = props.getProperty("databaseVendor");
      dbName = props.getProperty("databaseName");
      dbHost = props.getProperty("databaseHost");
      dbPort = props.getProperty("databasePort");
      dbUsername = props.getProperty("databaseUsername");
      dbPassword = props.getProperty("databasePassword");
      jdbcDriver = props.getProperty("jdbcDriver");
      dbURL = props.getProperty("databaseURL");
    } catch (Exception ex) {
      FacesContext.getCurrentInstance().addMessage(null, new FacesMessage(
        FacesMessage.SEVERITY_WARN, ex.getMessage(), "..."));
    }
  }
  
  
  public static String getDbVendor() { return dbVendor; }
  public static String getDbName() { return dbName; }
  public static String getDbHost() { return dbHost; }
  public static String getDbPort() { return dbPort; }
  public static String getDbUsername() { return dbUsername; }
  public static String getDbPassword() { return dbPassword; }
  public static String getJdbcDriver() { return jdbcDriver; }
  public static String getDbURL() { return dbURL; }
  
}