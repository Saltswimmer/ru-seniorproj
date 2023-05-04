package router

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestCreateMessage(t *testing.T) {
	sr := signupReq{FirstName: "Jim", MiddleName: "Bob", LastName: "Cooter", UserName: "jimbob", Email: "jimbob@foo.bar", Password: "pass"}
	ar := DoSignup(sr, t)
	//userId := ParseUserIdFromToken(ar.AccessToken, t)
	vr := newVesselReq{Name: "Example"}
	req, rec := makeRequest(http.MethodPost, "/vessel/new", vr, ar.AccessToken)
	testEcho.ServeHTTP(rec, req)
	//fmt.Println(rec)
	assert.Equal(t, http.StatusOK, rec.Code)
	var vessel Vessel
	b, err := io.ReadAll(rec.Body)
	assert.NoError(t, err)
	assert.NoError(t, json.Unmarshal(b, &vessel))

	newMessage := NewMessage{Body: "Hello darkness my old friend"}
	path := fmt.Sprintf("/vessel/send/%s", vessel.Id)
	req, rec = makeRequest(http.MethodPost, path, newMessage, ar.AccessToken)
	testEcho.ServeHTTP(rec, req)
	assert.Equal(t, http.StatusOK, rec.Code)

	var message Message
	b, err = io.ReadAll(rec.Body)
	assert.NoError(t, err)
	assert.NoError(t, json.Unmarshal(b, &message))

	assert.Equal(t, message.Body, "Hello darkness my old friend")
	assert.Equal(t, message.VesselId, vessel.Id)

	path = fmt.Sprintf("/vessel/messages/%s", vessel.Id)
	req, rec = makeRequest(http.MethodGet, path, newMessage, ar.AccessToken)
	testEcho.ServeHTTP(rec, req)
	assert.Equal(t, http.StatusOK, rec.Code)

	var messages GetMessages
	b, err = io.ReadAll(rec.Body)
	assert.NoError(t, err)
	assert.NoError(t, json.Unmarshal(b, &messages))

	message = messages.Messages[0]
	assert.Equal(t, message.Body, "Hello darkness my old friend")
	assert.Equal(t, message.VesselId, vessel.Id)
}
