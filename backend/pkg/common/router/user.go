package router

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"net/http"
	"time"

	"github.com/golang-jwt/jwt/v4"

	"github.com/google/uuid"
	"github.com/labstack/echo/v4"
)

var sampleSecretKey = []byte("secret")

type signupReq struct {
	FirstName  string `json:"first_name"`
	MiddleName string `json:"middle_name"`
	LastName   string `json:"last_name"`
	UserName   string `json:"username"`
	Email      string `json:"email"`
}

type authResponse struct {
	AccessToken string `json:"access_token"`
	TokenType   string `json:"token_type"`
}

type User struct {
	FirstName  string `json:"first_name"`
	MiddleName string `json:"middle_name"`
	LastName   string `json:"last_name"`
	UserName   string `json:"username"`
	Email      string `json:"email"`
	UserId     string `json:"user_id"`
}

func (h *Handler) SignUp(c echo.Context) error {

	var req signupReq
	err := c.Bind(&req)
	if err != nil {
		return err
	}

	//define the sql statement to use for this endpoint
	sql := `INSERT INTO users (first_name, middle_name, last_name, username, email, date_created, user_id) VALUES ($1, $2, $3, $4, $5, $6, $7)`
	date := time.Now()
	//fmt.Println(req.First_name, req.Middle_name, req.Last_name, req.Username, req.Email, date)
	id := uuid.New()
	_, err = h.db.Exec(sql, req.FirstName, req.MiddleName, req.LastName, req.UserName, req.Email, date, id.String())
	if err != nil {
		return err
	}

	token := jwt.New(jwt.SigningMethodHS256)
	claims := token.Claims.(jwt.MapClaims)
	//expire in ten minutes
	claims["exp"] = time.Now().Add(10 * time.Minute).Unix()
	claims["authorized"] = true
	claims["user"] = id.String()

	tokenString, err := token.SignedString(sampleSecretKey)
	if err != nil {
		return err
	}

	res := authResponse{AccessToken: tokenString, TokenType: "Bearer"}
	return c.JSON(http.StatusOK, res)
}

func (h *Handler) GetUser(c echo.Context) error {

	id := c.Param("id")
	fmt.Printf("LOOKING UP USER FOR ID %s\n", id)

	//define the sql statement to use for this endpoint
	q := `SELECT first_name, middle_name, last_name, username, email, user_id FROM users WHERE user_id = $1`
	row := h.db.QueryRow(q, id)

	var u User
	err := row.Scan(&u.FirstName, &u.MiddleName, &u.LastName, &u.UserName, &u.Email, &u.UserId)
	if err == nil {
		if err == sql.ErrNoRows {
			return c.String(http.StatusNotFound, "")
		}

		s, _ := json.MarshalIndent(u, "", "\t")
		fmt.Println(string(s))
		return c.JSONPretty(http.StatusOK, u, "\t")
	}
	fmt.Println("ERROR IS NOT NIL")
	fmt.Println(err)
	return c.String(http.StatusInternalServerError, "")
}
