package net.jar.quarkus.webapp;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
public class System {
  
  @Id
  @GeneratedValue
  private Integer id;
  @Column
  private String hostname;
  @Column
  private String ipaddress;

  public System() {}

  public System(Integer id, String hostname, String ipaddress) {
    this.id = id;
    this.hostname = hostname;
    this.ipaddress = ipaddress;
  }

  public Integer getId() {
    return this.id;
  }
  public void setId(Integer id) {
    this.id = id;
  }

  public String getHostname() {
    return this.hostname;
  }
  public void setHostname(String hostname) {
    this.hostname = hostname;
  }

  public String getIpaddress() {
    return this.ipaddress;
  }
  public void setIpaddress(String ipaddress) {
    this.ipaddress = ipaddress;
  }
}
