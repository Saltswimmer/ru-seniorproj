package router

import (
	"database/sql"
	//"encoding/json"
	"fmt"
	"net/http"
	"time"

	"github.com/google/uuid"
	"github.com/labstack/echo/v4"
	"github.com/Saltswimmer/ru-seniorproj/pkg/common/util"
)

type newVesselReq struct {
	Name          string `json:"name"`
	//Administrator string `json:"administrator"`
}

type Vessel struct {
	Name          string `json:"name"`
	//Administrator string `json:"administrator"`
	Id            string `json:"id"`
}

type getVesselReq struct {
	Id			  string `json:"id"`
}

type getVessel struct {
	Name		  string `json:"name"`
	Id			  string `json:"id"`
}

type joinVesselReq struct {
	//User_Id		  string `json:"user_id"`
	Vessel_Id		  string `json:"vessel_id"`
}

type usersInVesselReq struct {
	Vessel		string `json:"vessel"`
}

type userListMember struct {
	User_Id		string `json:"user_id"`
	Admin		string `json:"admin"`
	Username	string `json:"username"`
}

type usersInVessel struct {
	Users		[]userListMember `json:"users"`
}

type searchVesselReq struct {
	Slug		string `json:"vessel_name"`
}

type searchVesselRow struct {
	Vessel 		string `json:"vessel_name"`
	Id			string `json:"vessel_id"`
}

type searchVessel	struct {
	Vessels 	[]searchVesselRow `json:"vessels"`
}

func (h *Handler) CreateVessel(c echo.Context) error {

	var req newVesselReq
	err := c.Bind(&req)
	if err != nil {
		return err
	}

	claims := util.GetClaimsFromRequest(c)

	userId, err := uuid.Parse(claims.MapClaims["user"].(string))
	if err != nil {
		fmt.Println(err)
		return err
	}

	//define the sql statement to use for this endpoint
	sql := `INSERT INTO vessels (vessel_id, name, date_created) VALUES ($1, $2, $3)`
	date := time.Now()
	//fmt.Println(req.First_name, req.Middle_name, req.Last_name, req.Username, req.Email, hash, date)
	id := uuid.New()
	_, err = h.db.Exec(sql, id.String(), req.Name, date)
	if err != nil {
		fmt.Println(err)
		fmt.Println("error in creating vessel")
		return err
	}

	//add the user to the server's user list
	sql = `INSERT INTO users_vessels (user_vessel_id, vessel_id, user_id, is_admin, date_created) VALUES ($1, $2, $3, $4, $5)`
	//just generate a new id i guess? doesnt really matter here
	relationId := uuid.New()

	_, err = h.db.Exec(sql, relationId.String(), id.String(), userId, "true", date)
	if err != nil {
		fmt.Println(err)
		fmt.Println("error in relationship table")
		return err
	}

	//return vessel id
	v := Vessel{Name: req.Name, Id: id.String()}
	return c.JSON(http.StatusOK, v)

}

func (h *Handler) GetVessel(c echo.Context) error {
	var req getVesselReq
	err := c.Bind(&req)
	if err != nil {
		return err
	}

	//get the server name
	q := `SELECT vessel_id, name FROM vessels WHERE vessel_id = $1`
	row := h.db.QueryRow(q, req.Id)

	var vesselInfo getVessel

	err = row.Scan(&vesselInfo.Id, &vesselInfo.Name)
	//fmt.Println(err)
	switch err{
		case sql.ErrNoRows:
			fmt.Println("here")
			return c.String(http.StatusNotFound, "")
		case nil:
			return c.JSON(http.StatusOK, vesselInfo)
		default:
			return err
	}
}

func (h *Handler) JoinVessel(c echo.Context) error {
	//fmt.Println("ENTERED HERE")
	var req joinVesselReq
	err := c.Bind(&req)
	if err != nil {
		return err
	}

	claims := util.GetClaimsFromRequest(c)

	id, err := uuid.Parse(claims.MapClaims["user"].(string))
	if err != nil {
		fmt.Println(err)
		return err
	}

	//add the user to the server's user list
	sql := `INSERT INTO users_vessels (user_vessel_id, vessel_id, user_id, is_admin, date_created) VALUES ($1, $2, $3, $4, $5)`
	//just generate a new id i guess? doesnt really matter here
	relationId := uuid.New()
	date := time.Now()

	_, err = h.db.Exec(sql, relationId.String(), req.Vessel_Id, id, "false", date)
	if err != nil {
		fmt.Println(err)
		return err
	}

	//just echo back the request
	return c.JSON(http.StatusOK, req)

}

//get users in a vessel
func (h *Handler) GetUsers(c echo.Context) error {

	var req usersInVesselReq
	err := c.Bind(&req)
	if err != nil {
		return err
	}

	//vessel_id := c.Param("vessel_id")

	//fmt.Printf("LOOKING UP USERS IN VESSEL '%s'\n", vessel_id)

	var list usersInVessel

	//define the sql statement to use for this endpoint
	q := `SELECT users_vessels.user_id, is_admin, username FROM users_vessels INNER JOIN users ON users_vessels.user_id = users.user_id WHERE vessel_id = $1`
	rows, err := h.db.Query(q, req.Vessel)
	if err != nil {
		return err
	}
	defer rows.Close()
	for rows.Next(){
		var user userListMember
		err = rows.Scan(&user.User_Id, &user.Admin, &user.Username)
		if err != nil {
			fmt.Println(err)
			return err
		}
		list.Users = append(list.Users, user)

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
	//s, _ := json.MarshalIndent(list, "", "\t")
	//fmt.Println(string(s))
	//fmt.Println(list)
	return c.JSONPretty(http.StatusOK, list, "\t")


}

func (h *Handler) SearchVessels(c echo.Context) error {
	fmt.Println("SEARCHING VESSELS")

	var req searchVesselReq
	err := c.Bind(&req)
	if err != nil {
		return err
	}

	var list searchVessel
	q := `SELECT name, vessel_id FROM vessels WHERE name LIKE $1`
	slug := "%" + req.Slug + "%"
	//slug = "%beard%"
	//fmt.Println(q)
	rows, err := h.db.Query(q, slug)

	if err != nil {
		fmt.Println(err)
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

	//s, _ := json.MarshalIndent(list, "", "\t")
	//fmt.Println(string(s))

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
