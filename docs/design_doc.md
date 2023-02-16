Harbour Chat App Design Document
================================
#### High level Description:

#### Approaches Considered:
* REACT vs. Flutter for frontend

#### Mockups:

![image](images/m_login.png "Login screen")

![image](images/m_signup.png "Sign up screen")

![image](images/m_verify.png "Email verification screen")

![image](images/m_firsttime.png "First time user screen")

![image](images/m_main.png "Main view")

![image](images/m_browse.png "Browse view")

#### Screen Navigation:

#### Backend Information:
#### API Endpoints:
* [/api] - Returns API doucmentation
* [/api/users/login] - Attempt to login with the given credentials
  * Expected Payload:
```
{
  username: USERNAME
  password: PASSWORD
}
```
  * Response:
```
{
  response: Successful/not successful
  has_2fa_enabled: true/false - Go to 2fa screen if needed
  token: the user's login token, if successful login and no 2fa
  userID: their user id
}
```
* [/api/users/twofactor] - Verify 2 factor authentication code
  * Expected Payload:
```
{
  username: USERNAME
  2fa_code: 2fa code
}
```
  * Response: 
```
{
  response: Successful/not successful
  token: the user's login token, if successful
}
```
* [/api/users/registration] - Register a new user
  * Expected Payload:
```
{
  username: USERNAME
  password: PASSWORD
  email: EMAIL
}
```
  * Response:
```
{
  response: successful/not successful
  token: the user's tokem, if successful
}
```
* [/api/users/logout] - Logout the user
  * Expected Payload:
```
{
  token: the user's token
}
```
* [/api/users/editprofile] - Edit a user's profile
  * Expected Payload:
```
{
  token: token
  list of user profile information: a bunch of rows consisting of what's changing
}
```
* [/api/users/userprofile] - Get a user's public user information
  * Expected Payload:
```
{
  userID: userID
}
```
  * Response:
```
{
  list of public user information, such as profile picture, name, etc
}
```
* [/api/users/userinfo] - Get a user's private information
  * Expected Payload:
```
{
  token: token
}
```
  * Response:
```
{
  list of private information, such as settings information, server list, DMs, etc
}
```
* [/api/users/search] - Get a list of users based off of a set of criteria
  * Expected Payload:
```
{
  name: user's name to search
  other search criteria like interests or shared servers, etc
}
```
  * Response:
```
{
  list: list of users
}
```

* [/api/users/match] - Get a recommended list of friends
  * Expected payload:
```
{
  token: token
}
```
  * Response:
```
{
   list: list of users
}
```

#### Functionality provided by each screen:

#### User Authentication / Data Security Considerations:

#### Tech stack:
* __Frontend__
  * Flutter
    *
* __Backend__
  * Docker
    * 
  * Postgres
    * 
  * GraphQL
    * 
  * Hosting
    * 
* __Development Tools__
  * Github
    * 

#### Goals and who they've been assigned to:
* __Ethan Ciavolella <ciavol43@students.rowan.edu>__
  * 
* __Shane Cleary <cleary92@students.rowan.edu>__
  * 
* __Eric Heitmann <heitma24@students.rowan.edu>__
  * 
* __Evan Kaminsky <kamins39@students.rowan.edu>__
  * 
* __Joseph Tommasi <tommas95@students.rowan.edu>__
  * 
