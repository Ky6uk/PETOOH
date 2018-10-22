package petooh

import (
	"bytes"
	"errors"
	"strings"
	"testing"
)

const source = `KoKoKoKoKoKoKoKoKoKo Kud-Kudah
	KoKoKoKoKoKoKoKo kudah kO kud-Kudah Kukarek kudah
	KoKoKo Kud-Kudah
	kOkOkOkO kudah kO kud-Kudah Ko Kukarek kudah
	KoKoKoKo Kud-Kudah KoKoKoKo kudah kO kud-Kudah kO Kukarek
	kOkOkOkOkO Kukarek Kukarek kOkOkOkOkOkOkO
	Kukarek`
const res = "PETOOH"

type errorReader struct {
}

func (er errorReader) Read(p []byte) (n int, err error) {
	return 0, errors.New("test")
}

func TestProcess(t *testing.T) {

	r := strings.NewReader(source)

	w := bytes.NewBuffer([]byte{})

	err := Process(r, w)

	if w.String() != res {
		t.Errorf("method returns false result %s, but %s expected", w.String(), res)
	}

	if err != nil {
		t.Errorf("failed on source code processing: %s", err)
	}

}

func TestProcessEmpty(t *testing.T) {
	r := errorReader{}

	w := bytes.NewBuffer([]byte{})

	err := Process(r, w)

	if err == nil {
		t.Error("should be error but no error was returned")
	}
}
