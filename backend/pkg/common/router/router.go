package router

import (
	"database/sql"
	"fmt"

	_ "github.com/lib/pq"
)

// class UserHandler {
// 	private Database db;

// 	public UserHandler(Database db) {
// 		this.db = db;
// 	}
// 	public void saveUser(User user) {
// 		db.insert(...user...)
// 	}
// }

type Handler struct {
	db *sql.DB
}

const (
	host     = "localhost"
	port     = 5435
	user     = "test"
	password = "test"
	dbname   = "test"
)

func LoadHandler() (*Handler, error) {
	psqlInfo := fmt.Sprintf("host=%s port=%d user=%s "+
		"password=%s dbname=%s sslmode=disable",
		host, port, user, password, dbname)

	db, err := sql.Open("postgres", psqlInfo)
	if err != nil {
		panic(err)
	}
	return &Handler{db: db}, nil
}
