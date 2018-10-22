package petooh

import (
	"bufio"
	"fmt"
	"io"
	"log"
	"os"
	"strings"
)

const (
	koIncPtr   = "Kudah"
	koDecPtr   = "kudah"
	koInc      = "Ko"
	koDec      = "kO"
	koOut      = "Kukarek"
	koJmp      = "Kud"
	koRet      = "kud"
	validRunes = "adehkKoOru"
)

func usage() {
	fmt.Printf("Usage: %s filepath\n", os.Args[0])
	os.Exit(0)
}

// Process function parses and processes source code commands
//
// r should contains source code
// w will get result output
func Process(r io.Reader, w io.Writer) {
	var buffer string
	var exit bool
	level := 0
	pointer := 0
	operations := make([][]string, 1)
	cells := make([]int, 1)

	cr := bufio.NewReader(r)

	for {
		c, _, err := cr.ReadRune()
		if err == io.EOF {
			exit = true
		} else if err != nil {
			log.Fatal(err)
		}

		if !strings.ContainsRune(validRunes, c) && !exit {
			continue
		}

		switch buffer {
		case koInc:
			if level > 0 {
				operations[level] = append(operations[level], buffer)
			} else {
				cells[pointer]++
			}
			buffer = ""
		case koDec:
			if level > 0 {
				operations[level] = append(operations[level], buffer)
			} else {
				cells[pointer]--
			}
			buffer = ""
		case koIncPtr:
			if level > 0 {
				operations[level] = append(operations[level], buffer)
			} else {
				pointer++
				for len(cells) <= pointer {
					cells = append(cells, 0)
				}
			}
			buffer = ""
		case koDecPtr:
			if level > 0 {
				operations[level] = append(operations[level], buffer)
			} else {
				pointer--
			}
			buffer = ""
		case koJmp:
			if c != 'a' {
				level++
				for len(operations) <= level {
					operations = append(operations, []string{})
				}
				operations[level] = make([]string, 0)
				// log.Println("jmp:", buffer, level)
				buffer = ""
			}
		case koRet:
			if c != 'a' {
				for cells[pointer] > 0 {
					for _, operation := range operations[level] {
						switch operation {
						case koInc:
							cells[pointer]++
						case koDec:
							cells[pointer]--
						case koIncPtr:
							pointer++
							for len(cells) <= pointer {
								cells = append(cells, 0)
							}
						case koDecPtr:
							pointer--
						case koOut:
							w.Write([]byte(string(cells[pointer])))
						}
					}
				}
				level--
				buffer = ""
			}
		case koOut:
			if level > 0 {
				operations[level] = append(operations[level], buffer)
			} else {
				w.Write([]byte(string(cells[pointer])))
			}
			buffer = ""
		}

		if exit {
			break
		} else {
			buffer = buffer + string(c)
		}
	}

}
