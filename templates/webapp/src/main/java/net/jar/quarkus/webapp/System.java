package net.jar.quarkus.webapp;

import javax.persistence.Cacheable;
import javax.persistence.Column;
import javax.persistence.Entity;

import io.quarkus.hibernate.orm.panache.PanacheEntity;

@Entity
@Cacheable
public class System extends PanacheEntity {

  /* REQUIRED */
  @Column(length = 64, unique = true)
  public String hostname;
  
  @Column(length = 64, unique = false)
  public String ipaddress;
  
  /* OPTIONAL */
  @Column(length = 64)
  public String category;
  
  @Column(length = 64)
  public String groups;

  @Column(length = 512)
  public String notes;
  
  /* SPECIFICATIONS */

  /* CPU */
  @Column(length = 32)
  public String cputype; /* Intel, AMD, ARM, RISC */

  @Column(length = 32)
  public String cpuarch; /* x86, amd64, arm64, armhf */

  @Column()
  public Integer cpucores; /* number of cores */

  @Column(length = 32)
  public String cpuspeed; /* ex: 3.8 GHz */

  /* MEMORY */
  @Column(length = 8)
  public String memorysize; /* ex: 8 GB */

  @Column(length = 32)
  public String memorytype; /* DDR3, DDR4, ect */

  @Column(length = 32)
  public String memoryspeed; /* ex: 2400 MHz */

  @Column()
  public Integer memorynum; /* number of DIMMs */

  /* DISK */
  @Column(length = 64)
  public String disksizetotal; /* ex: 512 GB */

  @Column()
  public Integer disknum; /* number of disks */


  public System() {}

  public System(String hostname, String ipaddress) {
    this.hostname = hostname;
    this.ipaddress = ipaddress;
  }
  
  public System(String hostname, 
                String ipaddress,
                String category,
                String groups,
                String notes,
                String cputype,
                String cpuarch,
                Integer cpucores,
                String cpuspeed,
                String memorysize,
                String memorytype,
                String memoryspeed,
                Integer memorynum,
                String disksizetotal,
                Integer disknum
               ) {
    this.hostname = hostname;
    this.ipaddress = ipaddress;
    this.category = category;
    this.groups = groups;
    this.notes = notes;
    this.cputype = cputype;
    this.cpuarch = cpuarch;
    this.cpucores = cpucores;
    this.cpuspeed = cpuspeed;
    this.memorysize = memorysize;
    this.memorytype = memorytype;
    this.memoryspeed = memoryspeed;
    this.memorynum = memorynum;
    this.disksizetotal = disksizetotal;
    this.disknum = disknum;
  }
  
  public static System findByHostname(String hostname) {
    return find("hostname", hostname).firstResult();
  }

}
