package router

import (
	// "github.com/google/uuid"
	"net/http"
	"time"

	"github.com/golang-jwt/jwt/v4"
	"github.com/labstack/echo/v4"
)

var sampleSecretKey = []byte("secret")

type signupReq struct {
	first_name  string `json:"first_name"`
	middle_name string `json:"middle_name"`
	last_name   string `json:"last_name"`
	username    string `json:"username"`
	email       string `json:"email"`
}

func SignUp(c echo.Context) error {

	var req signupReq
	err := c.Bind(&req)
	if err != nil {
		return err
	}

	// sql := `INSERT INTO users (first_name, middle_name, last_name, username, email, date_created) VALUES ($1, $2, $3, $4, $5, $6)`
	// date := time.Now().Format("2023-03-09")
	// _, err = db.Exec(sql, req.first_name, req.middle_name, req.last_name, req.username, req.email, date)
	// if err != nil {
	// 	return "", err
	// }

	token := jwt.New(jwt.SigningMethodHS256)
	claims := token.Claims.(jwt.MapClaims)
	//expire in ten minutes
	claims["exp"] = time.Now().Add(10 * time.Minute).Unix()
	claims["authorized"] = true
	claims["user"] = req.username

	tokenString, err := token.SignedString(sampleSecretKey)
	if err != nil {
		return err
	}

	return c.String(http.StatusOK, tokenString)
}
