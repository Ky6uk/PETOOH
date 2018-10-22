package main

import (
	"flag"
	"fmt"
	"log"
	"os"

	"github.com/Ky6uk/PETOOH/Go/petooh"
)

func usage() {
	fmt.Printf("Usage: %s filepath\n", os.Args[0])
	os.Exit(0)
}

func init() {
	flag.Usage = usage
}

func main() {
	// parse parameters
	flag.Parse()
	if flag.NArg() == 0 {
		usage()
	}
	filePath := flag.Arg(0)

	// read file
	file, err := os.Open(filePath)
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	// process file
	err = petooh.Process(file, os.Stdout)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println()
}
