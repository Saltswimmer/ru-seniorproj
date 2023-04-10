package router

import (
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
