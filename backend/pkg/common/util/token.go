package util

import (
	"errors"
	"time"
	"fmt"
	"github.com/golang-jwt/jwt/v4"
	"github.com/labstack/echo/v4"
)

// Change me to a better key!!!
var SampleSecretKey = []byte("secret")

type AuthResponse struct {
	AccessToken string `json:"access_token"`
	TokenType   string `json:"token_type"`
}

type UserTokenClaims struct {
	Email string `json:"email"`
	jwt.MapClaims
}

func GenerateUserToken(id string, email string) (AuthResponse, error) {

	claims := UserTokenClaims{
		email,
		jwt.MapClaims{
			"exp":        time.Now().Add(24 * time.Hour).Unix(),
			"authorized": true,
			"user":       id}}
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)

	tokenString, err := token.SignedString(SampleSecretKey)
	if err != nil {
		return AuthResponse{}, err
	}

	return AuthResponse{AccessToken: tokenString, TokenType: "Bearer"}, nil
}

func CheckToken(token_string string) (*UserTokenClaims, error) {
	token, _ := jwt.ParseWithClaims(
		token_string,
		&UserTokenClaims{},
		func(token *jwt.Token) (interface{}, error) {
			return SampleSecretKey, nil
		})

	if claims, ok := token.Claims.(*UserTokenClaims); ok && token.Valid {
		return claims, nil
	} else {
		fmt.Println("Error in token parsing")
		return nil, errors.New("Invalid token") // Maybe give more descriptive errors
	}
}

func GetClaimsFromRequest(c echo.Context) *UserTokenClaims {
	token := c.Get("user").(*jwt.Token)
	claims := token.Claims.(*UserTokenClaims)
	return claims
}
