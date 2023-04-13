package router

import (
	"encoding/json"
	"io"
	"net/http"
	"testing"
	//"fmt"
	"github.com/stretchr/testify/assert"
)

var vessel Vessel

func TestCreateVessel(t *testing.T) {
	sr := signupReq{FirstName: "Jim", MiddleName: "Bob", LastName: "Cooter", UserName: "jimbob", Email: "jimbob@foo.bar", Password: "pass"}
	ar := DoSignup(sr, t)
	userId := ParseUserIdFromToken(ar.AccessToken, t)
	vr := newVesselReq{Name: "Example", Administrator: userId}
	req, rec := makeRequest(http.MethodPost, "/restricted/vessels", vr, ar.AccessToken)
	testEcho.ServeHTTP(rec, req)
	//fmt.Println(rec)
	assert.Equal(t, http.StatusOK, rec.Code)

	b, err := io.ReadAll(rec.Body)
	assert.NoError(t, err)

	assert.NoError(t, json.Unmarshal(b, &vessel))

	assert.Equal(t, vr.Name, vessel.Name)

	// b, err := io.ReadAll(rec.Body)
	// assert.NoError(t, err)
	// assert.NoError(t, json.Unmarshal(b, &ar))
}

func TestVesselFeaturesUgly(t *testing.T) {
	sr := signupReq{FirstName: "John", MiddleName: "The", LastName: "Shipman", UserName: "shipdude", Email: "vesselfan13@example.com", Password: "pass"}
	ar2 := DoSignup(sr, t)
	userId := ParseUserIdFromToken(ar2.AccessToken, t)

	//fmt.Println(vessel.Id)
	vr3 := joinVesselReq{User_Id: userId, Vessel: vessel.Id}
	//fmt.Println(vr)
	//fmt.Println(vr3)
	req, rec := makeRequest(http.MethodPost, "/restricted/joinVessel", vr3, ar2.AccessToken)
	testEcho.ServeHTTP(rec, req)
	//fmt.Println(rec)
	assert.Equal(t, http.StatusOK, rec.Code)

	vr2 := getVesselReq{Id: vessel.Id}
	req, rec = makeRequest(http.MethodGet, "/restricted/getVessel", vr2, ar2.AccessToken)
	testEcho.ServeHTTP(rec, req)
	//fmt.Println(rec)
	assert.Equal(t, http.StatusOK, rec.Code)
	b, err := io.ReadAll(rec.Body)
	assert.NoError(t, err)
	var vesselResp getVessel
	assert.NoError(t, json.Unmarshal(b, &vesselResp))

	assert.Equal(t, vessel.Name, vesselResp.Name)

	vr4 := usersInVesselReq{Vessel:vessel.Id}
	req, rec = makeRequest(http.MethodGet, "/restricted/getUsers", vr4, ar2.AccessToken)
	testEcho.ServeHTTP(rec, req)
	assert.Equal(t, http.StatusOK, rec.Code)

}
