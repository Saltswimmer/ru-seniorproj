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



	//seed database with some test data
	//this will run every time the backend starts, so if you start it multiple times there will be multiple entries for each time it ran
	err := SeedDatabase(testEcho)
	if err != nil{
		fmt.Println(err)
		fmt.Println("error in seeding")
	}


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

	// GET /vessels -OR- GET /user/vessels
	user.GET("/getUserVessels", handler.GetUserVessels)
	user.GET("/", handler.GetUserByToken)

	// TODO: Need to rethink this routing
	// vessel --> vessels
	user.POST("/vessels/:id/messages", handler.CreateMessage)
	user.GET("/vessels/:id/messages", handler.GetMessages)

	vessel := e.Group("/vessel")
	vessel.Use(echojwt.WithConfig(config))

	// POST /vessels
	vessel.POST("/new", handler.CreateVessel)

	// GET /vessels/:id
	vessel.GET("/", handler.GetVessel)

	// POST /vessels/:id/join
	vessel.POST("/join", handler.JoinVessel)

	// GET /vessels/:id/members
	vessel.GET("/members", handler.GetUsers)

	// GET /vessels/search?xxx=yyy
	vessel.GET("/search", handler.SearchVessels)

	return e
}
