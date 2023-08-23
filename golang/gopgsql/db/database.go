package main

import (
  "database/sql"
  "context"
  "fmt"
  "log"
  "os"
  "github.com/jackc/pgx/v5"
)

var db *sql.DB

var connStr = "postgres://golang:golang@10.0.0.2:5432/golang"

type Item struct {
  ID          int
  Name        string
  Category    string
  Price       float32
  Description string
}

func getItems() ([]Item, error) {
  var items []Item
  conn, err := pgx.Connect(context.Background(), connStr)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Unable to connect to database: %v\n", err)
	}
  defer conn.Close(context.Background())
  rows, err := conn.Query(context.Background(), "SELECT id,name,category,price FROM items")
  if err != nil {
    return nil, fmt.Errorf("Error retrieving items: %q", err)
  }
  for rows.Next() {
    var itm Item
    if err := rows.Scan(&itm.ID, &itm.Name, &itm.Category, &itm.Price); err != nil {
      fmt.Errorf("Error fetching row: %q", err)
    }
    items = append(items, itm)
  }
  return items, nil
}

func getItem(itemId int) (Item, error) {
  var itm Item
  conn, err := pgx.Connect(context.Background(), connStr)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Unable to connect to database: %v\n", err)
	}
  defer conn.Close(context.Background())
  err1 := conn.QueryRow(context.Background(), "SELECT id,name,category,price,description FROM items WHERE id = $1", itemId).Scan(&itm.ID, &itm.Name, &itm.Category, &itm.Price, &itm.Description)
  if err1 != nil {
    return itm, fmt.Errorf("Error retrieving item: %q", err1)
  }
  return itm, nil
}

func getItemByName(itemName string) (Item, error) {
  var itm Item
  conn, err := pgx.Connect(context.Background(), connStr)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Unable to connect to database: %v\n", err)
	}
  defer conn.Close(context.Background())
  err1 := conn.QueryRow(context.Background(), "SELECT id,name,category,price,description FROM items WHERE name = $1", itemName).Scan(&itm.ID, &itm.Name, &itm.Category, &itm.Price, &itm.Description)
  if err1 != nil {
    return itm, fmt.Errorf("Error retrieving item: %q", err1)
  }
  return itm, nil
}

func addItem(itm Item) (int, error) {
  conn, err := pgx.Connect(context.Background(), connStr)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Unable to connect to database: %v\n", err)
	}
  defer conn.Close(context.Background())
  _, err1 := conn.Exec(context.Background(), "INSERT INTO items (name,category,price,description) VALUES ($1,$2,$3,$4)", &itm.Name, &itm.Category, &itm.Price, &itm.Description)
  if err1 != nil {
    return 0, fmt.Errorf("Error adding item: %q", err1)
  }
  return 1, nil
}

func deleteItem(itemId int) (int, error) {
  conn, err := pgx.Connect(context.Background(), connStr)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Unable to connect to database: %v\n", err)
	}
  defer conn.Close(context.Background())
  _, err1 := conn.Exec(context.Background(), "DELETE FROM items WHERE id = $1", itemId)
  if err1 != nil {
    return 0, fmt.Errorf("Error deleting item: %q", err1)
  }
  return 1, nil
}
