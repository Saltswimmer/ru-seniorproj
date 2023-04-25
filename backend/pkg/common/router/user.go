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

	"github.com/Saltswimmer/ru-seniorproj/pkg/common/util"
	"github.com/google/uuid"
	"github.com/labstack/echo/v4"
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
	Email    string `json:"email"`
	Password string `json:"password"`
}

type User struct {
	FirstName  string `json:"first_name"`
	MiddleName string `json:"middle_name"`
	LastName   string `json:"last_name"`
	UserName   string `json:"username"`
	Email      string `json:"email"`
}

/* not needed anymore
type getUserVesselsReq struct {
	Id		  string `json:"user_id"`
}
*/

//using searchVesselRow and searchVessel structs from vessel.go for response, since they are the same response structure

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
			//fmt.Println("1")
			return c.String(http.StatusNotFound, "")
		}
	}

	if !util.CheckHash(req.Password, hash) {
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
	fmt.Printf("LOOKING UP USER FOR ID '%s'\n", id)

	//define the sql statement to use for this endpoint
	q := `SELECT first_name, middle_name, last_name, username, email FROM users WHERE user_id = $1`
	row := h.db.QueryRow(q, id)

	var u User
	err := row.Scan(&u.FirstName, &u.MiddleName, &u.LastName, &u.UserName, &u.Email)
	if err == nil {
		if err == sql.ErrNoRows {
			//fmt.Println("2")
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
	fmt.Println("*** GET USER BY TOKEN...")
	claims := util.GetClaimsFromRequest(c)

	id, err := uuid.Parse(claims.MapClaims["user"].(string))
	if err != nil {
		fmt.Println(err)
		return err
	}

	fmt.Printf("*** UESR ID IS '%s'", id.String())

	//define the sql statement to use for this endpoint
	q := `SELECT first_name, middle_name, last_name, username, email FROM users WHERE user_id = $1`
	row := h.db.QueryRow(q, id)

	var u User
	err = row.Scan(&u.FirstName, &u.MiddleName, &u.LastName, &u.UserName, &u.Email)
	if err == nil {
		if err == sql.ErrNoRows {
			//fmt.Println("3")
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

//TODO: make unit tests for this, update vessel.go func
func (h *Handler) GetUserVessels (c echo.Context) error {
	fmt.Println("GETTING A USERS VESSEL LIST")

	claims := util.GetClaimsFromRequest(c)

	id, err := uuid.Parse(claims.MapClaims["user"].(string))
	if err != nil {
		fmt.Println(err)
		return err
	}

	var list searchVessel

	//define the sql statement to use for this endpoint
	q := `SELECT name, users_vessels.vessel_id FROM users_vessels INNER JOIN vessels ON users_vessels.vessel_id = vessels.vessel_id WHERE user_id = $1`
	rows, err := h.db.Query(q, id)
	if err != nil {
		return err
	}

	defer rows.Close()
	//fmt.Println(rows.Columns())
	for rows.Next(){
		var vessel searchVesselRow
		err = rows.Scan(&vessel.Vessel, &vessel.Id)
		//fmt.Println("Vessel ")
		if err != nil {
			fmt.Println(err)
			return err
		}
		//fmt.Println("Got here")
		list.Vessels = append(list.Vessels, vessel)

	}

	err = rows.Err()
	if err != nil {
		if err == sql.ErrNoRows {
			return c.String(http.StatusNotFound, "")
		} else {
			fmt.Println("ERROR IS NOT NIL")
			fmt.Println(err)
			return c.String(http.StatusInternalServerError, "")
		}
	}

	//fmt.Println(list)
	return c.JSONPretty(http.StatusOK, list, "\t")



}