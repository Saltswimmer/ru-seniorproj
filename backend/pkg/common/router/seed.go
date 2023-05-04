
package router


import (
	"fmt"
	"bytes"
	"encoding/json"
	"io"
	"net/http"
	"net/http/httptest"

	"github.com/Saltswimmer/ru-seniorproj/pkg/common/util"
	"github.com/labstack/echo/v4"

	_ "github.com/lib/pq"

)


func makeRequestMod(method, url string, body interface{}, accessToken string) (*http.Request, *httptest.ResponseRecorder) {
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
func DoSignupMod(u signupReq) (ar util.AuthResponse) {
	req, rec := makeRequestMod(http.MethodPost, "/signup", u, "")
	c := testEcho.NewContext(req, rec)
	err := testHandler.SignUp(c)
	if err != nil{
		fmt.Println(err)
	}

	b, err := io.ReadAll(rec.Body)
	if err == nil{
		err = json.Unmarshal(b, &ar)
		if err != nil{
			fmt.Println(err)
		}
	}
	return
}


func SeedDatabase(e *echo.Echo) error {
	fmt.Println("Seeding Database")
	//start by making some users


	sr := signupReq{FirstName: "John", MiddleName: "The", LastName: "Shipman", UserName: "shipdude", Email: "vesselfan13@example.com", Password: "pass"}
	john := DoSignupMod(sr)

	sr = signupReq{FirstName: "Jim", MiddleName: "Bob", LastName: "Cooter", UserName: "jimbob", Email: "jimbob@foo.bar", Password: "pass"}
	jim := DoSignupMod(sr)

	sr = signupReq{FirstName: "Jacquelin", MiddleName: "Witha", LastName: "Longlastname", UserName: "firstmate420", Email: "jaclongname@aol.com", Password: "pass"}
	jac := DoSignupMod(sr)

	//make two servers, john owns one and jim owns the second

	vr := newVesselReq{Name: "Jim's Cruiser"}
	req, rec := makeRequestMod(http.MethodPost, "/vessel/new", vr, jim.AccessToken)
	testEcho.ServeHTTP(rec, req)

	var jimShip Vessel
	b, err := io.ReadAll(rec.Body)
	if err != nil{
		return nil
	}
	err = json.Unmarshal(b, &jimShip)
	if err != nil{
		return nil
	}

	vr = newVesselReq{Name: "John's Dinghy"}
	req, rec = makeRequestMod(http.MethodPost, "/vessel/new", vr, john.AccessToken)
	testEcho.ServeHTTP(rec, req)

	var johnShip Vessel
	b, err = io.ReadAll(rec.Body)
	if err != nil{
		return nil
	}
	err = json.Unmarshal(b, &johnShip)
	if err != nil{
		return nil
	}

	//now jacquelin can join both, while john will just join jim's

	vr2 := joinVesselReq{Id: jimShip.Id}
	req, rec = makeRequestMod(http.MethodPost, "/vessel/join", vr2, jac.AccessToken)
	testEcho.ServeHTTP(rec, req)

	vr2 = joinVesselReq{Id: jimShip.Id}
	req, rec = makeRequestMod(http.MethodPost, "/vessel/join", vr2, john.AccessToken)
	testEcho.ServeHTTP(rec, req)

	vr2 = joinVesselReq{Id: johnShip.Id}
	req, rec = makeRequestMod(http.MethodPost, "/vessel/join", vr2, jac.AccessToken)
	testEcho.ServeHTTP(rec, req)

	//john, jim, and jacquelin will talk a bit in jim's server
	//while poor john will be alone in his :(

	newMessage := NewMessage{Body: "Hi folks!"}
	path := fmt.Sprintf("/vessel/send/%s", jimShip.Id)
	req, rec = makeRequestMod(http.MethodPost, path, newMessage, john.AccessToken)
	testEcho.ServeHTTP(rec, req)
	//fmt.Println(john.AccessToken)
	//fmt.Println(req)

	newMessage = NewMessage{Body: "What's up John"}
	path = fmt.Sprintf("/vessel/send/%s", jimShip.Id)
	req, rec = makeRequestMod(http.MethodPost, path, newMessage, jac.AccessToken)
	testEcho.ServeHTTP(rec, req)

	newMessage = NewMessage{Body: "Sup johnny!"}
	path = fmt.Sprintf("/vessel/send/%s", jimShip.Id)
	req, rec = makeRequestMod(http.MethodPost, path, newMessage, jim.AccessToken)
	testEcho.ServeHTTP(rec, req)

	newMessage = NewMessage{Body: "I'm having a great time with this chat app!"}
	path = fmt.Sprintf("/vessel/send/%s", jimShip.Id)
	req, rec = makeRequestMod(http.MethodPost, path, newMessage, john.AccessToken)
	testEcho.ServeHTTP(rec, req)

	newMessage = NewMessage{Body: "Hello?"}
	path = fmt.Sprintf("/vessel/send/%s", johnShip.Id)
	req, rec = makeRequestMod(http.MethodPost, path, newMessage, john.AccessToken)
	testEcho.ServeHTTP(rec, req)

	newMessage = NewMessage{Body: "Anybody online?"}
	path = fmt.Sprintf("/vessel/send/%s", johnShip.Id)
	req, rec = makeRequestMod(http.MethodPost, path, newMessage, john.AccessToken)
	testEcho.ServeHTTP(rec, req)

	return nil
}
