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
	"github.com/Saltswimmer/ru-seniorproj/pkg/common/util"
)

var sampleSecretKey = []byte("secret")

type signupReq struct {
	FirstName  string `json:"first_name"`
	MiddleName string `json:"middle_name"`
	LastName   string `json:"last_name"`
	UserName   string `json:"username"`
	Email      string `json:"email"`
	Password   string `json:"password"`
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
}

type UserTokenClaims struct {
	email string `json:"email"`
	jwt.MapClaims
}

func (h *Handler) SignUp(c echo.Context) error {

	var req signupReq
	err := c.Bind(&req)
	if err != nil {
		return err
	}

	// Hash the password using bcrypt algorithm
	hash, err := util.Hash(req.Password)
	if err != nil {
		return err
	}

	//define the sql statement to use for this endpoint
	sql := `INSERT INTO users (first_name, middle_name, last_name, username, email, pass_hash, date_created, user_id) VALUES ($1, $2, $3, $4, $5, $6, $7, $8)`
	date := time.Now()
	//fmt.Println(req.First_name, req.Middle_name, req.Last_name, req.Username, req.Email, hash, date)
	id := uuid.New()
	_, err = h.db.Exec(sql, req.FirstName, req.MiddleName, req.LastName, req.UserName, req.Email, hash, date, id.String())
	if err != nil {
		return err
	}

	claims := UserTokenClaims{
		req.Email,
		jwt.MapClaims{
			"exp": time.Now().Add(10 * time.Minute).Unix(),
			"authorized": true,
			"user": id.String()}}
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)

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
	q := `SELECT first_name, middle_name, last_name, username, email FROM users WHERE user_id = $1`
	row := h.db.QueryRow(q, id)

	var u User
	err := row.Scan(&u.FirstName, &u.MiddleName, &u.LastName, &u.UserName, &u.Email)
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

// Query a user using an access token instead of the id
func (h *Handler) GetUserByToken(c echo.Context) error {

	var token_param authResponse
	err := c.Bind(&token_param)
	if err != nil {
		return err
	}

	token, err := jwt.ParseWithClaims(
		token_param.AccessToken,
		&UserTokenClaims{},
		func(token *jwt.Token) (interface{}, error) {
			return sampleSecretKey, nil
		})

	if claims, ok := token.Claims.(*UserTokenClaims); ok && token.Valid {
		
		id, err := uuid.Parse(claims.MapClaims["user"].(string))		
		if err != nil {
			fmt.Println(err)
			return err
		}

		//define the sql statement to use for this endpoint
		q := `SELECT first_name, middle_name, last_name, username, email FROM users WHERE user_id = $1`
		row := h.db.QueryRow(q, id)

		var u User
		err = row.Scan(&u.FirstName, &u.MiddleName, &u.LastName, &u.UserName, &u.Email)
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

	} else {
		fmt.Println(err)
	}

	return c.String(http.StatusInternalServerError, "")
}