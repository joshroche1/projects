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
public class Fruit extends PanacheEntity {

  @Column(length = 64, unique = true)
  public String name;
  
  @Column(length = 64, unique = false)
  public String category;

  @Column(length = 512, unique = false)
  public String notes;

  public Fruit() {}

  public Fruit(String name, String category, String notes) {
    this.name = name;
    this.category = category;
    this.notes = notes;
  }

}
