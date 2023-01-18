package net.jar.quarkus.webapp;


import javax.persistence.Cacheable;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;

import io.quarkus.hibernate.orm.panache.PanacheEntity;

@Entity
@Cacheable
public class UserEntity extends PanacheEntity {

  @Column(length = 40, unique = true)
  public String name;

  @Column(length = 40, unique = true)
  public String email;

  @Column(length = 512)
  public String password;


  public UserEntity() {}
  
  public UserEntity(String name, String password) {
    this.name = name;
    this.password = password;
  }
  
  public UserEntity(String name, String email, String password) {
    this.name = name;
    this.email = email;
    this.password = password;
  }
  
  public static UserEntity findByName(String name) {
    return find("name", name).firstResult();
  }
  
}