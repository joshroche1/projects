# Go PostgreSQL 

- Go Language [<https://go.dev/>]
- Extensions:
  - pgx - PostgreSQL Driver [<https://github.com/jackc/pgx>]

## How to use multiple go files in a project

Create directory for module: 
```
mkdir -p /home/user/example ; cd /home/user/example
```

Initialize the module: 
```
go mod init home/user/example
```

Create the main.go file: 
```
/home/user/example/main.go
```

Build and install: 
```
go install home/user/example
```
> If you installed Go with a package manager, this should work fine. If not, change the GOROOT directory with go env -w GOROOT=/path/to/dir so that the package will be installed in the correct area. GOROOT usually is set to /usr/lib/go-1.19 if installed via APT on debian/12. Installation instructions have you manually put it in /usr/local/go. You may end up with an error trying to install the package saying that /usr/local/go/src/PATH/TO/DIR doesn't exist.

Check the package operation: 
```
./main
```

Make a subfolder for the subpackage: 
```
mkdir -p /home/user/example/db ; cd /home/user/example/db
```

Create the subpackage: 
```
/home/user/example/db/db.go
```

Install the subpackage: 
```
go install home/user/example/db
```

Pull the needed dependencies: 
```
go mod tidy
```

Install the main package: 
```
go install home/user/example
```

Run the program: 
```
./main
```
