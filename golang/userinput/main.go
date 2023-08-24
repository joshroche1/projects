package main

import (
  "fmt"
)


func main() {
  var input1,input2 int
  
  fmt.Println("Enter 2 integers: ")
  fmt.Scanf("%v,%v",&input1,&input2)
  fmt.Println("Sum: ", input1+input2)
}