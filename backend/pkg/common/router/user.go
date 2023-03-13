package router

import (
	// "github.com/google/uuid"
	"database/sql"
	"net/http"
	"time"

	"github.com/google/uuid"
	"github.com/labstack/echo/v4"
)

// var sampleSecretKey = []byte("secret")

type signupReq struct {
	First_name  string `json:"first_name"`
	Middle_name string `json:"middle_name"`
	Last_name   string `json:"last_name"`
	Username    string `json:"username"`
	Email       string `json:"email"`
}

type User struct {
	First_name  string `json:"first_name"`
	Middle_name string `json:"middle_name"`
	Last_name   string `json:"last_name"`
	Username    string `json:"username"`
	Email       string `json:"email"`
	User_Id     string `json:"user_id"`
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
	_, err = h.db.Exec(sql, req.First_name, req.Middle_name, req.Last_name, req.Username, req.Email, date, id.String())
	if err != nil {
		panic(err)
	}

	// token := jwt.New(jwt.SigningMethodHS256)
	// claims := token.Claims.(jwt.MapClaims)
	// //expire in ten minutes
	// claims["exp"] = time.Now().Add(10 * time.Minute).Unix()
	// claims["authorized"] = true
	// claims["user"] = req.Username

	// tokenString, err := token.SignedString(sampleSecretKey)
	// if err != nil {
	// 	return err
	// }

	return c.String(http.StatusOK, id.String())
}

func (h *Handler) GetUser(c echo.Context) error {

	id := c.Param("id")

	//define the sql statement to use for this endpoint
	q := `SELECT first_name, middle_name, last_name, username, email, user_id FROM users WHERE user_id = ?`
	row := h.db.QueryRow(q, id)

	var u User
	if err := row.Scan(&u.First_name, &u.Middle_name, &u.Last_name, &u.Username, &u.Email, &u.User_Id); err != nil {
		if err == sql.ErrNoRows {
			return c.String(http.StatusNotFound, "")
		}
		return c.JSONPretty(http.StatusOK, u, "\t")
	}
	return c.String(http.StatusInternalServerError, "")
}
