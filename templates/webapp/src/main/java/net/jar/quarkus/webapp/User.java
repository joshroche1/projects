package net.jar.quarkus.webapp;


import javax.persistence.Cacheable;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.NamedQuery;
import javax.persistence.QueryHint;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

@Entity
@Table(name = "users")
@NamedQuery(name = "Users.findAll", query = "SELECT u FROM User u ORDER BY u.name", hints = @QueryHint(name = "org.hibernate.cacheable", value = "true"))
@NamedQuery(name = "Users.findByName", query = "SELECT u FROM User u WHERE u.name = :name", hints = @QueryHint(name = "org.hibernate.cacheable", value = "true"))
@Cacheable
public class User {

  @Id
  @SequenceGenerator(name = "usersSequence", sequenceName = "users_id_seq", allocationSize = 1, initialValue = 10)
  @GeneratedValue(generator = "usersSequence")
  private Integer id;

  @Column(length = 64, unique = true)
  private String name;

  @Column(length = 64, unique = true)
  private String email;

  @Column(length = 512)
  private String password;


  public User() {}
  
  public User(String name, String password) {
    this.name = name;
    this.password = password;
  }
  
  public User(String name, String email, String password) {
    this.name = name;
    this.email = email;
    this.password = password;
  }
  
 
  public Integer getId() { return this.id; }

  public void setId(Integer id) { this.id = id; }


  public String getName() { return this.name; }

  public void setName(String name) { this.name = name; }
  

  public String getEmail() { return this.email; }

  public void setEmail(String email) { this.email = email; }


  public String getPassword() { return this.password; }

  public void setPassword(String password) { this.password = password; }

}