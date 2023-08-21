# Go Reference

- Go Language [<https://go.dev/>]
- Extensions:
  - pgx - PostgreSQL Driver [<https://github.com/jackc/pgx>]

## Prerequisites

For debian systems: 
```
sudo apt install -y golang
```

#

### Create a new Module:
```
go mod init NAMESPACE/FOLDER
```
Creates a file in the directory called go.mod

### Pull dependencies for Module:
```
go get .
```
Creates a file called go.sum 

### Run Module:
```
go run .
go run MODULE.go
```

### Build Executable Module:
```
go build MODULE.go
```
