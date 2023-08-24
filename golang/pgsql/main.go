package main

import (
  "fmt"
  "log"

   DB "gopgsql/db"
)


func main() {
  fmt.Println("TEST")
  fmt.Println("\nAll Items:\n")
  items, _ := DB.GetItems()
  fmt.Println(items)
  fmt.Println("\nGet Item 1:\n")
  itm, _ := DB.GetItem(1)
  fmt.Println(itm)
  fmt.Println("\nAdd Item:\n")
  item1, err1 := DB.AddItem(DB.Item{
    Name: "NEW ITEM",
    Category: "Unknown",
    Price: 99.99,
    Description: "THE NEWEST",
  })
  if err1 != nil {
    log.Fatal(err1)
  }
  fmt.Println("Added item: %v", item1)
  fmt.Println("\nAll Items:\n")
  items1, _ := DB.GetItems()
  fmt.Println(items1)
  fmt.Println("\nDelete new Item:\n")
  item2, _ := DB.GetItemByName("NEW ITEM")
  result, _ := DB.DeleteItem(item2.ID)
  fmt.Println(result)
  fmt.Println("\nAll Items:\n")
  items2, _ := DB.GetItems()
  fmt.Println(items2)
}
