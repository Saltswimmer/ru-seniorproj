package main

import (
	"net/http"

	
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

type CustomContext struct {
	echo.Context
	Id int `json:"id"`
    Name string `json:"name"`
    Price int `json:"price"`
    Description string `json:"description"`
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
			cc := &CustomContext{c, 1, "Eric", 50, "Hello"}
			return next(cc)
		}
	})

	e.GET("/", func(c echo.Context) error {
		cc := c.(*CustomContext)
		cc.Foo()
		cc.Bar()
		return cc.String(http.StatusOK, cc.Name)
	})


	e.Logger.Fatal(e.Start(":1323"))
}
