# HARBOUR
A group chat application.
Rowan Senior Project Spring 2023
See docs/project_specification.md for more information

Members: Ethan Ciavolella, Shane Cleary, Joseph Tommasi, Eric Heitmann

## Get Started

1. Install pre-commit `pip install pre-commit`
2. run `pre-commit install`
3. Install golang
4. Install docker
5. Install docker-compose `pip install docker-compose`

## Running the docker containers locally from Makefile

Note: Makefile lives in the backend folder
Note: if you are on linux all docker commands may need to run with sudo before

make d.up - will start the postgres and pgadmin instances locally

postgres - binds to localhost 5432
pgadmin - binds to localhost 8080

## Stopping the docker containers locally:

Note: doing so will delete all the data

make d.down - will start

## Running Database migrations

make db.update - will automatically perform DB migrations using Atlas

## Seeing the data in the database

1. Browse to localhost:8080
2. Enter admin@admin.com (or whatever is in the docker-compose.yml file)
3. Enter example for the password (or whatever is in the docker-compose.yml file)
4. Add a new server
    i. Give a name
    ii. On connection tab enter:
        a. host: harbour_db
        b. user: test
        c. password: test
        d. database: test

5. Navigate to Database -> Public -> Schemas -> Tables -> users (if it does not exist, run the database test script which creates the table)
6. Left click on the table, and select View rows
