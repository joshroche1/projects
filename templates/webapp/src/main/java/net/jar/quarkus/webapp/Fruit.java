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
@Table(name = "known_fruits")
@NamedQuery(name = "Fruits.findAll", query = "SELECT f FROM Fruit f ORDER BY f.name", hints = @QueryHint(name = "org.hibernate.cacheable", value = "true"))
@Cacheable
public class Fruit {

  @Id
  @SequenceGenerator(name = "fruitsSequence", sequenceName = "known_fruits_id_seq", allocationSize = 1, initialValue = 10)
  @GeneratedValue(generator = "fruitsSequence")
  private Integer id;

  @Column(length = 64, unique = true)
  private String name;
  
  @Column(length = 64, unique = false)
  private String category;

  @Column(length = 512, unique = false)
  private String notes;

  public Fruit() {}

  public Fruit(String name, String category, String notes) {
    this.name = name;
    this.category = category;
    this.notes = notes;
  }

  public Integer getId() { return id; }

  public void setId(Integer id) { this.id = id; }


  public String getName() { return name; }

  public void setName(String name) { this.name = name; }
  

  public String getCategory() { return category; }

  public void setCategory(String category) { this.category = category; }
  

  public String getNotes() { return notes; }

  public void setNotes(String notes) { this.notes = notes; }

}
