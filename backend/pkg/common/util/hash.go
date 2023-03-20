package util

import (
	"golang.org/x/crypto/bcrypt"
)

// Hash password using bcrypt algorithm
// Borrowed from https://gowebexamples.com/password-hashing/
func Hash(password string) (string, error) {
	bytes, err := bcrypt.GenerateFromPassword([]byte(password),12)
	return string(bytes), err
}
func CheckHash(password, hash string) bool {
	err := bcrypt.CompareHashAndPassword([]byte(hash), []byte(password))
	return err == nil
}