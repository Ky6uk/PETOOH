package petooh

import (
	"bytes"
	"errors"
	"io"
	"strings"
	"testing"
)

const (
	valDefault = `KoKoKoKoKoKoKoKoKoKo Kud-Kudah
	KoKoKoKoKoKoKoKo kudah kO kud-Kudah Kukarek kudah
	KoKoKo Kud-Kudah
	kOkOkOkO kudah kO kud-Kudah Ko Kukarek kudah
	KoKoKoKo Kud-Kudah KoKoKoKo kudah kO kud-Kudah kO Kukarek
	kOkOkOkOkO Kukarek Kukarek kOkOkOkOkOkOkO
	Kukarek`
	wrongSyntax   = `Kudak`
	wrongPointer  = `kudah`
	wrongPointerL = `KoKudkudahkud`
	wrongLevel    = `kudkud`
	valLvl        = `KudahKokudahKoKudKudah
	KoKoKoKoKoKoKoKoKoKoKoKoKoKoKoKoKoKoKoKo
	KoKoKoKoKoKoKoKoKoKoKoKoKoKoKoKoKoKoKoKo
	KoKoKoKoKoKoKoKoKoKoKoKoKoKoKoKoKoKoKoKo
	KoKoKoKoKukarekkudahkOkud`
)

type errorReader struct {
}

func (er errorReader) Read(p []byte) (n int, err error) {
	return 0, errors.New("test")
}

func processTestData(r io.Reader) (string, error) {
	w := bytes.NewBuffer([]byte{})
	err := Process(r, w)
	return w.String(), err
}

func TestProcess(t *testing.T) {
	for _, td := range []struct {
		r   io.Reader
		exp string
	}{
		{strings.NewReader(valDefault), "PETOOH"}, //default example
		{strings.NewReader(valLvl), "A"},          //simple example with A
	} {
		res, err := processTestData(td.r)
		if res != td.exp {
			t.Errorf("method returns false result %s, but %s expected", res, td.exp)
		}
		if err != nil {
			t.Errorf("failed on valDefault code processing: %s", err)
		}
	}
}

func TestProcessEmpty(t *testing.T) {
	for _, r := range []io.Reader{
		errorReader{},
		strings.NewReader(wrongSyntax),   //wrong sintax example
		strings.NewReader(wrongPointer),  //negative pointer
		strings.NewReader(wrongPointerL), //negative pointer on second level
		strings.NewReader(wrongLevel),    //negative level
	} {
		_, err := processTestData(r)
		if err == nil {
			t.Error("should be error but no error was returned")
		}
	}
}
