package main

import (
	"database/sql"
	"fmt"
	"github.com/golang-jwt/jwt"
	"github.com/labstack/echo/v4"
	_ "github.com/lib/pq"
	"net/http"
	"time"
)

var sampleSecretKey = []byte("secret")

const (
	host     = "host.docker.internal"
	port     = 5435
	user     = "test"
	password = "test"
	dbname   = "test"
)

type addUserReq struct {
	first_name  string `json:"first_name"`
	middle_name string `json:"middle_name"`
	last_name   string `json:"last_name"`
	username    string `json:"username"`
	email       string `json:"email"`
}

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
	e.GET("/", func(c echo.Context) error {
		return c.String(http.StatusOK, "Hello, World!")
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
	var req addUserReq
	err := c.Bind(&req)
	if err != nil {
		return "", err
	}

	sql := `INSERT INTO users (first_name, middle_name, last_name, username, email, date_created) VALUES ($1, $2, $3, $4, $5, $6)`
	date := time.Now().Format("2023-03-09")
	_, err = db.Exec(sql, req.first_name, req.middle_name, req.last_name, req.username, req.email, date)
	if err != nil {
		return "", err
	}

	token := jwt.New(jwt.SigningMethodHS256)
	claims := token.Claims.(jwt.MapClaims)
	//expire in ten minutes
	claims["exp"] = time.Now().Add(10 * time.Minute).Unix()
	claims["authorized"] = true
	claims["user"] = req.username

	tokenString, err := token.SignedString(sampleSecretKey)
	if err != nil {
		return "", err
	}

	return tokenString, nil
}
