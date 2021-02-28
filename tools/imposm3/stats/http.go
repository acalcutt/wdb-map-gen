package stats

import (
	"net/http"
	_ "net/http/pprof"

	"github.com/omniscale/imposm3/log"
)

func StartHTTPPProf(bind string) {
	go func() {
		log.Println(http.ListenAndServe(bind, nil))
	}()
}
