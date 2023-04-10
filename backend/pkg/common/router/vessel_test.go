package router

import (
	"encoding/json"
	"io"
	"net/http"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestCreateVessel(t *testing.T) {
	//
	sr := signupReq{FirstName: "Jim", MiddleName: "Bob", LastName: "Cooter", UserName: "jimbob", Email: "jimbob@foo.bar", Password: "pass"}
	ar := DoSignup(sr, t)
	userId := ParseUserIdFromToken(ar.AccessToken, t)
	vr := newVesselReq{Name: "Example", Administrator: userId}
	req, rec := makeRequest(http.MethodPost, "/restricted/vessels", vr, ar.AccessToken)
	testEcho.ServeHTTP(rec, req)
	assert.Equal(t, http.StatusOK, rec.Code)

	b, err := io.ReadAll(rec.Body)
	assert.NoError(t, err)
	var vessel Vessel
	assert.NoError(t, json.Unmarshal(b, &vessel))

	assert.Equal(t, vr.Name, vessel.Name)

	// b, err := io.ReadAll(rec.Body)
	// assert.NoError(t, err)
	// assert.NoError(t, json.Unmarshal(b, &ar))

}
