package main

import (
  "context"
  "fmt"
//  "log"
  "os"
  
  "projects/github/projects/golang/pgsql/db/db"
)


func main() {
  fmt.Println("\nAll Items:\n")
  items, _ := db.getItems()
  fmt.Println(items)
//  fmt.Println("\nGet Item 1:\n")
//  itm, _ := getItem(1)
//  fmt.Println(itm)
//  fmt.Println("\nAdd Item:\n")
//  item1, err1 := addItem(Item{
//    Name: "NEW ITEM",
//    Category: "Unknown",
//    Price: 99.99,
//    Description: "THE NEWEST",
//  })
//  if err1 != nil {
//    log.Fatal(err1)
//  }
//  fmt.Println("Added item: %v", item1)
//  fmt.Println("\nAll Items:\n")
//  items1, _ := getItems()
//  fmt.Println(items1)
//  fmt.Println("\nDelete new Item:\n")
//  item2, _ := getItemByName("NEW ITEM")
//  result, _ := deleteItem(item2.ID)
//  fmt.Println(result)
//  fmt.Println("\nAll Items:\n")
//  items2, _ := getItems()
//  fmt.Println(items2)
}
