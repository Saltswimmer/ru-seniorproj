package router

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/golang-jwt/jwt/v4"
	"github.com/labstack/echo/v4"
	"github.com/stretchr/testify/assert"
)

var testEcho *echo.Echo
var testHandler *Handler

func init() {
	testEcho = echo.New()
	testHandler, _ = LoadHandler()
}

func makeRequest(method, url string, body interface{}) (*http.Request, *httptest.ResponseRecorder) {
	requestBody, _ := json.Marshal(body)
	req := httptest.NewRequest(method, url, bytes.NewBuffer(requestBody))
	req.Header.Set(echo.HeaderContentType, echo.MIMEApplicationJSON)
	rec := httptest.NewRecorder()

	return req, rec
}

func TestSignup(t *testing.T) {

	u := signupReq{FirstName: "Jim", MiddleName: "Bob", LastName: "Cooter", UserName: "jimbob", Email: "jimbob@foo.bar"}
	req, rec := makeRequest(http.MethodPost, "/signup", u)
	c := testEcho.NewContext(req, rec)
	if assert.NoError(t, testHandler.SignUp(c)) {
		assert.Equal(t, http.StatusOK, rec.Code)
	}
	b, err := io.ReadAll(rec.Body)
	assert.NoError(t, err)

	var ar authResponse
	assert.NoError(t, json.Unmarshal(b, &ar))

	tokenString := ar.AccessToken
	fmt.Println(tokenString)
	token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
		return sampleSecretKey, nil
	})
	assert.NoError(t, err)

	var userId string
	claims, ok := token.Claims.(jwt.MapClaims)
	if ok && token.Valid {
		userId = claims["user"].(string)
	}
	assert.NotNil(t, userId)

	// Call get user, passing up the user id
	req, rec = makeRequest(http.MethodGet, "/users/:id", nil)
	c = testEcho.NewContext(req, rec)
	c.SetParamNames("id")
	c.SetParamValues(userId)

	if assert.NoError(t, testHandler.GetUser(c)) {
		assert.Equal(t, http.StatusOK, rec.Code)
	}

	b, err = io.ReadAll(rec.Body)
	assert.NoError(t, err)
	var user User
	assert.NoError(t, json.Unmarshal(b, &user))

	assert.Equal(t, u.FirstName, user.FirstName)
	assert.Equal(t, u.MiddleName, user.MiddleName)
	assert.Equal(t, u.LastName, user.LastName)
	assert.Equal(t, u.UserName, user.UserName)
	assert.Equal(t, u.Email, user.Email)
	fmt.Println(user)
}
