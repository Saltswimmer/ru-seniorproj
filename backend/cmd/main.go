package main

import (
	"github.com/Saltswimmer/ru-seniorproj/pkg/common/router"
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

func main() {
	e := echo.New()
	e.Use(middleware.CORSWithConfig(middleware.CORSConfig{
		AllowOrigins: []string{"*"},
		AllowMethods: []string{"http.MethodGet, http.MethodHead, http.MethodPost, http.MethodPut"},
		AllowHeaders: []string{echo.HeaderOrigin, echo.HeaderContentType, echo.HeaderAccept, echo.HeaderAuthorization},
	}))
	handler, err := router.LoadHandler()
	if err != nil {
		panic(err)
	}

	e.POST("/signup", handler.SignUp)
	e.POST("/signin", handler.SignIn)
	e.GET("/users/:id", handler.GetUser)
	e.GET("/user", handler.GetUserByToken)
	e.Logger.Fatal(e.Start(":1323"))
}