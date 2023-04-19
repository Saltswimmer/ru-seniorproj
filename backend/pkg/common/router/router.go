package router

import (
	"database/sql"
	"fmt"

	"github.com/Saltswimmer/ru-seniorproj/pkg/common/util"
	"github.com/golang-jwt/jwt/v4"
	echojwt "github.com/labstack/echo-jwt/v4"
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
	_ "github.com/lib/pq"
)

type Handler struct {
	db *sql.DB
}

const (
	host     = "localhost"
	port     = 5435
	user     = "test"
	password = "test"
	dbname   = "test"
)

var testEcho *echo.Echo
var testHandler *Handler

func init() {
	testHandler, _ = LoadHandler()
	testEcho = LoadRouter(testHandler)
}

func LoadHandler() (*Handler, error) {
	psqlInfo := fmt.Sprintf("host=%s port=%d user=%s "+
		"password=%s dbname=%s sslmode=disable",
		host, port, user, password, dbname)

	db, err := sql.Open("postgres", psqlInfo)
	if err != nil {
		panic(err)
	}
	return &Handler{db: db}, nil
}

func LoadRouter(handler *Handler) *echo.Echo {
	e := echo.New()
	e.Use(middleware.CORSWithConfig(middleware.CORSConfig{
		AllowOrigins: []string{"*"},
		AllowMethods: []string{"http.MethodGet, http.MethodHead, http.MethodPost, http.MethodPut"},
		AllowHeaders: []string{echo.HeaderOrigin, echo.HeaderContentType, echo.HeaderAccept, echo.HeaderAuthorization},
	}))
	e.POST("/signup", handler.SignUp)
	e.POST("/signin", handler.SignIn)
	e.GET("/users/:id", handler.GetUser)

	config := echojwt.Config{
		NewClaimsFunc: func(c echo.Context) jwt.Claims {
			return new(util.UserTokenClaims)
		},
		SigningKey: util.SampleSecretKey,
	}

  user := e.Group("/user")
	user.Use(echojwt.WithConfig(config))
  user.GET("/", handler.GetUserByToken)

  vessel := e.Group("/vessel")
  vessel.Use(echojwt.WithConfig(config))
  vessel.POST("/new", handler.CreateVessel)
	vessel.GET("/", handler.GetVessel)
	vessel.POST("/join", handler.JoinVessel)
	vessel.GET("/members", handler.GetUsers)
	vessel.GET("/search", handler.SearchVessels)

	return e
}
