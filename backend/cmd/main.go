package main

import (
	"net/http"

	
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

type CustomContext struct {
	echo.Context
	UserId int `json:"id"`
    First_Name string `json:"first_name"`
	Last_Name string `json:"last_name"`
	User_Name string `json:"user_name"`
}

func (c *CustomContext) Foo() {
	println("foo")
}

func (c *CustomContext) Bar() {
	println("bar")
}


func main() {
	e := echo.New()
	e.Use(middleware.Logger())
	e.Use(middleware.Recover())
	e.Use(middleware.CORS())

	e.Use(func(next echo.HandlerFunc) echo.HandlerFunc {
		return func(c echo.Context) error {
			cc := &CustomContext{c, 1, "Eric", "Heitmann", "H3its"}
			return next(cc)
		}
	})

	e.GET("/", func(c echo.Context) error {
		cc := c.(*CustomContext)
		cc.Foo()
		cc.Bar()
		return cc.JSON(http.StatusOK, cc)
	})


	e.Logger.Fatal(e.Start(":1323"))
}
