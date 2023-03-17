package main

import (
	"github.com/Saltswimmer/ru-seniorproj/pkg/common/router"
	"github.com/labstack/echo/v4"
)

func main() {
	e := echo.New()
	handler, err := router.LoadHandler()
	if err != nil {
		panic(err)
	}

	e.POST("/signup", handler.SignUp)
	e.GET("/users/:id", handler.GetUser)
	e.Logger.Fatal(e.Start(":1323"))
}