package main

import (
  "database/sql"
  "context"
  "fmt"
//  "log"
  "os"
  "github.com/jackc/pgx/v5"
)

var db *sql.DB

func main() {
	// urlExample := "postgres://username:password@localhost:5432/database_name"
  conn, err := pgx.Connect(context.Background(), "postgres://golang:golang@10.0.0.2:5432/golang")
	if err != nil {
		fmt.Fprintf(os.Stderr, "Unable to connect to database: %v\n", err)
		os.Exit(1)
	}
	defer conn.Close(context.Background())
  var id int
	var name string
	var category string
  var price float32
	err = conn.QueryRow(context.Background(), "SELECT id,name,category,price FROM items where id=$1", 1).Scan(&id, &name, &category, &price)
	if err != nil {
		fmt.Fprintf(os.Stderr, "QueryRow failed: %v\n", err)
		os.Exit(1)
	}
	fmt.Println(id, name, category, price)
}
