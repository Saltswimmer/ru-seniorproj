package router

import (
	"bytes"
	"encoding/json"
	"io"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/golang-jwt/jwt/v4"
	"github.com/labstack/echo/v4"
	"github.com/stretchr/testify/assert"
)

var testEcho *echo.Echo

func init() {
	testEcho = echo.New()
}

func makeRequest(method, url string, body interface{}) (*http.Request, *httptest.ResponseRecorder) {
	requestBody, _ := json.Marshal(body)
	req := httptest.NewRequest(method, url, bytes.NewBuffer(requestBody))
	req.Header.Set(echo.HeaderContentType, echo.MIMEApplicationJSON)
	rec := httptest.NewRecorder()

	return req, rec
}

func TestSignup(t *testing.T) {

	u := signupReq{first_name: "Jim", middle_name: "Bob", last_name: "Cooter", username: "jimbob", email: "jimbob@foo.bar"}
	req, rec := makeRequest(http.MethodPost, "/signup", u)
	c := testEcho.NewContext(req, rec)
	if assert.NoError(t, SignUp(c)) {
		assert.Equal(t, http.StatusOK, rec.Code)
	}
	b, err := io.ReadAll(rec.Body)
	assert.NoError(t, err)

	tknStr := string(b)
	//tkn := &jwt.MapClaims{}
	tkn, err := jwt.Parse(tknStr, func(token *jwt.Token) (interface{}, error) {
		return sampleSecretKey, nil
	})
	//claims, _ := tkn.Claims.(jwt.MapClaims)
	assert.NoError(t, err)
	assert.NotNil(t, tkn)
	//assert.Equal(t, claims["user"], "jimbob")
}
