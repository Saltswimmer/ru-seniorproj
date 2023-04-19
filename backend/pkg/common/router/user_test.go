package router

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/Saltswimmer/ru-seniorproj/pkg/common/util"
	"github.com/golang-jwt/jwt/v4"
	"github.com/labstack/echo/v4"
	"github.com/stretchr/testify/assert"
)

func makeRequest(method, url string, body interface{}, accessToken string) (*http.Request, *httptest.ResponseRecorder) {
	requestBody, _ := json.Marshal(body)

	req := httptest.NewRequest(method, url, bytes.NewBuffer(requestBody))
	req.Header.Set(echo.HeaderContentType, echo.MIMEApplicationJSON)

	if accessToken != "" {
		fmt.Println("*** ADDING AUTH HEADER " + accessToken)
		req.Header.Add("Authorization", "Bearer "+accessToken)
	}
	rec := httptest.NewRecorder()
	//fmt.Println(rec)
	return req, rec
}

// Complete the signup process, return the AuthResponse
func DoSignup(u signupReq, t *testing.T) (ar util.AuthResponse) {
	req, rec := makeRequest(http.MethodPost, "/signup", u, "")
	c := testEcho.NewContext(req, rec)
	if assert.NoError(t, testHandler.SignUp(c)) {
		assert.Equal(t, http.StatusOK, rec.Code)
	}
	b, err := io.ReadAll(rec.Body)
	assert.NoError(t, err)
	assert.NoError(t, json.Unmarshal(b, &ar))
	return
}

func ParseUserIdFromToken(tokenString string, t *testing.T) (userId string) {
	fmt.Println(tokenString)
	token, err := jwt.ParseWithClaims(
		tokenString,
		&util.UserTokenClaims{},
		func(token *jwt.Token) (interface{}, error) {
			return util.SampleSecretKey, nil
		})

	assert.NoError(t, err)
	if claims, ok := token.Claims.(*util.UserTokenClaims); ok && token.Valid {
		userId = claims.MapClaims["user"].(string)
		assert.NotNil(t, userId)
	} else {
		assert.FailNow(t, "Unable to parse user id from token")
	}
	return
}

func TestSignup(t *testing.T) {
	u := signupReq{FirstName: "Jim", MiddleName: "Bob", LastName: "Cooter", UserName: "jimbob", Email: "jimbob@foo.bar", Password: "pass"}
	ar := DoSignup(u, t)
	userId := ParseUserIdFromToken(ar.AccessToken, t)

	// Call get user, passing up the user id
	req, rec := makeRequest(http.MethodGet, "/users/:id", nil, "")
	c := testEcho.NewContext(req, rec)
	c.SetParamNames("id")
	c.SetParamValues(userId)

	if assert.NoError(t, testHandler.GetUser(c)) {
		assert.Equal(t, http.StatusOK, rec.Code)
	}

	b, err := io.ReadAll(rec.Body)
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

func TestGetUserByToken(t *testing.T) {
	// This endpoint is restricted
	// ensure that we add the auth header appropriately
	u := signupReq{FirstName: "Jim", MiddleName: "Bob", LastName: "Cooter", UserName: "jimbob", Email: "jimbob2@foo.bar", Password: "pass"}
	ar := DoSignup(u, t)

	// Call get user, passing up the access token as the AUTH header
	req, rec := makeRequest(http.MethodGet, "/user/", nil, ar.AccessToken)
	testEcho.ServeHTTP(rec, req)

	assert.Equal(t, http.StatusOK, rec.Code)

	b, err := io.ReadAll(rec.Body)
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
