package router

import (
	"encoding/json"
	"io"
	"net/http"
	"testing"
	"fmt"
	"github.com/stretchr/testify/assert"
	"github.com/Saltswimmer/ru-seniorproj/pkg/common/util"
)

var vessel Vessel
var firstUser util.AuthResponse


func TestCreateVessel(t *testing.T) {
	sr := signupReq{FirstName: "Jim", MiddleName: "Bob", LastName: "Cooter", UserName: "jimbob", Email: "jimbob@foo.bar", Password: "pass"}
	ar := DoSignup(sr, t)
	//userId := ParseUserIdFromToken(ar.AccessToken, t)
	vr := newVesselReq{Name: "Example"}
	req, rec := makeRequest(http.MethodPost, "/vessel/new", vr, ar.AccessToken)
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
	firstUser = ar2
	//userId := ParseUserIdFromToken(ar2.AccessToken, t)

	//fmt.Println(vessel.Id)
	vr3 := joinVesselReq{Id: vessel.Id}
	//fmt.Println(vr)
	//fmt.Println(vr3)
	req, rec := makeRequest(http.MethodPost, "/vessel/join", vr3, ar2.AccessToken)
	testEcho.ServeHTTP(rec, req)
	//fmt.Println(rec)
	assert.Equal(t, http.StatusOK, rec.Code)

	vr2 := getVesselReq{Id: vessel.Id}
	req, rec = makeRequest(http.MethodGet, "/vessel/", vr2, ar2.AccessToken)
	testEcho.ServeHTTP(rec, req)
	//fmt.Println(rec)
	assert.Equal(t, http.StatusOK, rec.Code)
	b, err := io.ReadAll(rec.Body)
	assert.NoError(t, err)
	var vesselResp getVessel
	assert.NoError(t, json.Unmarshal(b, &vesselResp))

	assert.Equal(t, vessel.Name, vesselResp.Name)

	vr4 := usersInVesselReq{Vessel:vessel.Id}
	req, rec = makeRequest(http.MethodGet, "/vessel/members", vr4, ar2.AccessToken)
	testEcho.ServeHTTP(rec, req)
	fmt.Println(rec)
	assert.Equal(t, http.StatusOK, rec.Code)

}

func TestSearch(t *testing.T) {
	//create 2 more servers
	//userId := ParseUserIdFromToken(firstUser.AccessToken, t)

	vr := newVesselReq{Name: "Blackbeard's Flagship"}
	req, rec := makeRequest(http.MethodPost, "/vessel/new", vr, firstUser.AccessToken)
	testEcho.ServeHTTP(rec, req)
	//fmt.Println(rec)
	assert.Equal(t, http.StatusOK, rec.Code)

	var firstVessel Vessel
	var secondVessel Vessel
	b, err := io.ReadAll(rec.Body)
	assert.NoError(t, err)

	assert.NoError(t, json.Unmarshal(b, &firstVessel))

	assert.Equal(t, vr.Name, firstVessel.Name)

	vr = newVesselReq{Name: "Bluebeard's Best Ship Ever"}
	req, rec = makeRequest(http.MethodPost, "/vessel/new", vr, firstUser.AccessToken)
	testEcho.ServeHTTP(rec, req)
	//fmt.Println(rec)
	assert.Equal(t, http.StatusOK, rec.Code)

	b, err = io.ReadAll(rec.Body)
	assert.NoError(t, err)

	assert.NoError(t, json.Unmarshal(b, &secondVessel))

	assert.Equal(t, vr.Name, secondVessel.Name)

	vr2 := searchVesselReq{Slug: "beard"}
	req, rec = makeRequest(http.MethodGet, "/vessel/search", vr2, firstUser.AccessToken)
	testEcho.ServeHTTP(rec, req)
	fmt.Println(rec)
	assert.Equal(t, http.StatusOK, rec.Code)

	//vr3 := getUserVesselsReq{Id: userId}
	req, rec = makeRequest(http.MethodGet, "/user/getUserVessels", nil, firstUser.AccessToken)
	testEcho.ServeHTTP(rec, req)
	fmt.Println(rec)
	assert.Equal(t, http.StatusOK, rec.Code)

}
