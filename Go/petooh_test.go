package petooh

import (
	"bytes"
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

func TestProcess(t *testing.T) {

	r := strings.NewReader(source)

	// w := strings.Builder{}
	w := bytes.NewBuffer([]byte{})

	Process(r, w)

	if w.String() != res {
		t.Errorf("method returns false result %s, but %s expected", w.String(), res)
	}

}
