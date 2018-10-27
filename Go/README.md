### DESCRIPTION

PETOOH interpreter written in [Go](https://golang.org/).

### USAGE

Import package 

```
go get github.com/Ky6uk/PETOOH/Go/petooh
```

and use Process() method

```Go
package main

import (
	"github.com/Ky6uk/PETOOH/Go/petooh"
)
...
err := petooh.Process(r, w)
```

or run example/run.go with path to source file as parameter

```
go run example/run.go filepath
```