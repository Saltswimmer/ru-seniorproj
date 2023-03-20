package main

import (
	"github.com/Saltswimmer/ru-seniorproj/pkg/common/router"
)

func main() {
	handler, err := router.LoadHandler()
	if err != nil {
		panic(err)
	}

	e := router.LoadRouter(handler)
	e.Logger.Fatal(e.Start(":1323"))
}
