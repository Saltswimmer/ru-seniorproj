package router

/*
TODO

- We need to ensure that email is unique even though it's not the primary key
- Verify email
- Change email?
*/

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"net/http"
	"time"

	"github.com/google/uuid"
	"github.com/labstack/echo/v4"
	"github.com/Saltswimmer/ru-seniorproj/pkg/common/util"
)

type signupReq struct {
	FirstName  string `json:"first_name"`
	MiddleName string `json:"middle_name"`
	LastName   string `json:"last_name"`
	UserName   string `json:"username"`
	Email      string `json:"email"`
	Password   string `json:"password"`
}

type signinReq struct {
	Email	   string `json:"email"`
	Password   string `json:"password`
}

type User struct {
	FirstName  string `json:"first_name"`
	MiddleName string `json:"middle_name"`
	LastName   string `json:"last_name"`
	UserName   string `json:"username"`
	Email      string `json:"email"`
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

	res, err := util.GenerateUserToken(id.String(), req.Email)
	if err != nil {
		return err
	}

	return c.JSON(http.StatusOK, res)
}

func (h *Handler) SignIn(c echo.Context) error {

	var req signinReq
	err := c.Bind(&req)
	if err != nil {
		return err
	}

	q := `SELECT user_id, pass_hash FROM users WHERE email = $1`
	row := h.db.QueryRow(q, req.Email)

	var id string
	var hash string
	err = row.Scan(&id, &hash)
	if err == nil {
		if err == sql.ErrNoRows {
			return c.String(http.StatusNotFound, "")
		}
	}

	if (!util.CheckHash(req.Password, hash)) {
		return c.String(http.StatusUnauthorized, "")
	}

	res, err := util.GenerateUserToken(id, req.Email)
	if err != nil {
		return err
	}
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

	var token_param string
	token_param = c.Request().Header.Get("authorization")

	// Check if token is valid
	claims, err := util.CheckToken(token_param)
	if err != nil {
		fmt.Println(err)
		return err
	}
		
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

	return c.String(http.StatusInternalServerError, "")
}