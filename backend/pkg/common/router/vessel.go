package router

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"net/http"
	"time"

	"github.com/google/uuid"
	"github.com/labstack/echo/v4"
)

type newVesselReq struct {
	Name          string `json:"name"`
	Administrator string `json:"administrator"`
}

type Vessel struct {
	Name          string `json:"name"`
	Administrator string `json:"administrator"`
	Id            string `json:"id"`
}

func (h *Handler) CreateVessel(c echo.Context) error {

	var req newVesselReq
	err := c.Bind(&req)
	if err != nil {
		return err
	}

	//define the sql statement to use for this endpoint
	sql := `INSERT INTO vessel (id, name, date_created, admin) VALUES ($1, $2, $3, $4)`
	date := time.Now()
	//fmt.Println(req.First_name, req.Middle_name, req.Last_name, req.Username, req.Email, hash, date)
	id := uuid.New()
	_, err = h.db.Exec(sql, id.String(), req.Name, date, req.Administrator)
	if err != nil {
		fmt.Println(err)
		return err
	}

	v := Vessel{Name: req.Name, Administrator: req.Administrator, Id: id.String()}
	return c.JSON(http.StatusOK, v)
}

//get users in a vessel
func (h *Handler) GetUsers(c echo.Context) error {

	vessel_id := c.Param("vessel_id")

	fmt.Printf("LOOKING UP USERS IN VESSEL '%s'\n", vessel_id)

	//define the sql statement to use for this endpoint
	q := `SELECT user_id FROM users_vessels WHERE vessel_id = $1`
	rows := h.db.QueryRow(q, vessel_id)

	var u User
	err := rows.Scan(&u.UserName, &u.Email)
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
