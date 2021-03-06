package errs

import (
	"fmt"
	"net/http"

	"github.com/labstack/echo"
	log "github.com/sirupsen/logrus"
)

// ERRORS CONST
const (
	ErrUsr = "user"
	ErrExt = "external"
	ErrInt = "internal"
)

// Send ...
func Send(status string, msg string, err error) *echo.HTTPError {
	m := msg
	var c int

	switch status {
	case "user":
		c = http.StatusBadRequest
		m += ", verify your data."
		log.Warn("An External error occured." + msg)
		break
	case "external":
		c = http.StatusInternalServerError
		m += " Something went wrong, please contact you're administrator."
		log.Warn("An External error occured." + msg)
		break
	case "internal":
		c = http.StatusNotAcceptable
		log.Warn("An Internal error occured." + msg)
		break
	}

	fmt.Println("-------------------------------------")
	fmt.Println("ERROR => ")
	log.Error(err)
	fmt.Println("-------------------------------------")
	fmt.Println("Sending Echo Error: " + m)
	fmt.Println("-------------------------------------")

	return echo.NewHTTPError(c, m)
}
