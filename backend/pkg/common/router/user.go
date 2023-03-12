package router

import (
	// "github.com/google/uuid"
	"github.com/golang-jwt/jwt/v4"
	"github.com/google/uuid"
	"github.com/labstack/echo/v4"
	"net/http"
	"time"
)

var sampleSecretKey = []byte("secret")

type signupReq struct {
	First_name  string `json:"first_name"`
	Middle_name string `json:"middle_name"`
	Last_name   string `json:"last_name"`
	Username    string `json:"username"`
	Email       string `json:"email"`
}

func (h *Handler) SignUp(c echo.Context) error {

	var req signupReq
	err := c.Bind(&req)
	if err != nil {
		return err
	}

	//define the sql statement to use for this endpoint
	sql := `INSERT INTO users (first_name, middle_name, last_name, username, email, date_created) VALUES ($1, $2, $3, $4, $5, $6, $7)`
	date := time.Now().Format("2006-01-02")
	//fmt.Println(req.First_name, req.Middle_name, req.Last_name, req.Username, req.Email, date)
	id := uuid.New()
	_, err = h.db.Exec(sql, req.First_name, req.Middle_name, req.Last_name, req.Username, req.Email, date, id.String())
	if err != nil {
	}

	token := jwt.New(jwt.SigningMethodHS256)
	claims := token.Claims.(jwt.MapClaims)
	//expire in ten minutes
	claims["exp"] = time.Now().Add(10 * time.Minute).Unix()
	claims["authorized"] = true
	claims["user"] = req.Username

	tokenString, err := token.SignedString(sampleSecretKey)
	if err != nil {
		return err
	}

	return c.String(http.StatusOK, tokenString)
}
