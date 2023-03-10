package main

import (
	"database/sql"
	"fmt"
	"github.com/golang-jwt/jwt"
	"github.com/labstack/echo/v4"
	_ "github.com/lib/pq"
	"net/http"
	"time"
	"encoding/json"
)

var sampleSecretKey = []byte("secret")

const (
	host     = "host.docker.internal"
	port     = 5435
	user     = "test"
	password = "test"
	dbname   = "test"
)

type AddUserReq struct {
	First_name  string `json:"first_name"`
	Middle_name string `json:"middle_name"`
	Last_name   string `json:"last_name"`
	Username    string `json:"username"`
	Email       string `json:"email"`}

func main() {
	psqlInfo := fmt.Sprintf("host=%s port=%d user=%s "+
		"password=%s dbname=%s sslmode=disable",
		host, port, user, password, dbname)

	db, err := sql.Open("postgres", psqlInfo)
	if err != nil {
		panic(err)
	}
	defer db.Close()

	err = db.Ping()
	if err != nil {
		panic(err)
	}

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
	e.POST("/addUser", func(c echo.Context) error {
		token, err := addUser(c, db)
		if err == nil {
			return c.String(http.StatusOK, token)
		} else {
			fmt.Println(err)
			return c.String(http.StatusForbidden, "Error in request")
		}
	})
	e.Logger.Fatal(e.Start(":1323"))
}

func addUser(c echo.Context, db *sql.DB) (string, error) {
	var req AddUserReq
	err := json.NewDecoder(c.Request().Body).Decode(&req); if err != nil {
		return "", err
	}

	sql := `INSERT INTO users (first_name, middle_name, last_name, username, email, date_created) VALUES ($1, $2, $3, $4, $5, $6)`
	date := time.Now().Format("2006-01-02")
	fmt.Println(req.First_name, req.Middle_name, req.Last_name, req.Username, req.Email, date)
	_, err = db.Exec(sql, req.First_name, req.Middle_name, req.Last_name, req.Username, req.Email, date)
	if err != nil {
		return "", err
	}

	token := jwt.New(jwt.SigningMethodHS256)
	claims := token.Claims.(jwt.MapClaims)
	//expire in ten minutes
	claims["exp"] = time.Now().Add(10 * time.Minute).Unix()
	claims["authorized"] = true
	claims["user"] = req.Username

	tokenString, err := token.SignedString(sampleSecretKey)
	if err != nil {
		return "", err
	}

	return tokenString, nil
}
