// POST /restricted/vessels/<id>/messages
// - make sure to use an ordered uuid ULIDS
// GET /restricted/vessels/<id>/message?lastMessageId=<ULID>
// - SELECT from messages where id > ? LIMIT 100]
package router

import (
	"database/sql"
	"fmt"
	"net/http"

	"github.com/Saltswimmer/ru-seniorproj/pkg/common/util"
	"github.com/google/uuid"
	"github.com/labstack/echo/v4"
	ulid "github.com/oklog/ulid/v2"
)

type NewMessage struct {
	Body string `json:"body"`
}

type Message struct {
	Id       string `json:"id"`
	Body     string `json:"body"`
  Sender   string `json:"sender"`
  Timestamp     string `json:"timestamp"`
	VesselId string `json:"vessel_id"`
}

type GetMessages struct {
	Messages []Message `json:"messages"`
}

func (h *Handler) CreateMessage(c echo.Context) error {

	var req NewMessage
	err := c.Bind(&req)
	if err != nil {
		return err
	}

	claims := util.GetClaimsFromRequest(c)
	senderId, err := uuid.Parse(claims.MapClaims["user"].(string))
	if err != nil {
		fmt.Println(err)
		return err
	}

	id := ulid.Make()
	vesselId := c.Param("id")
	//define the sql statement to use for this endpoint
	sql := `INSERT INTO message (id, vessel_id, body, sender_id, date_created) VALUES ($1, $2, $3, $4, now())`
	_, err = h.db.Exec(sql, id.String(), vesselId, req.Body, senderId)
	if err != nil {
		fmt.Println(err)
		fmt.Println("error in creating message")
		return err
	}
	message := Message{Id: id.String(), Body: req.Body, VesselId: vesselId}

	return c.JSONPretty(http.StatusOK, message, "\t")
}

func (h *Handler) GetMessages(c echo.Context) error {
	vesselId := c.Param("id")
	messageId := c.QueryParam("lastMessageId")

	fmt.Printf("*** vesselId = '%s'; messageId = '%s'\n\n", vesselId, messageId)

	//get the message
	var rows *sql.Rows
	var err error
	if messageId != "" {
		q := `SELECT m.id, m.vessel_id, m.body, s.username, m.date_created FROM message m JOIN users s ON (m.sender_id = s.user_id) WHERE m.vessel_id = $1 AND m.id > $2 ORDER BY m.id LIMIT 100`
		rows, err = h.db.Query(q, vesselId, messageId)
	} else {
		q := `SELECT m.id, m.vessel_id, m.body, s.username, m.date_created FROM message m JOIN users s ON (m.sender_id = s.user_id) WHERE m.vessel_id = $1 ORDER BY m.id DESC LIMIT 100`
		rows, err = h.db.Query(q, vesselId)
	}
	if err != nil {
		return err
	}
	defer rows.Close()

	var messages []Message
	for rows.Next() {
		fmt.Println("\n\n!!! GOT MESAGES !!!")
		var message Message
		if err := rows.Scan(&message.Id, &message.VesselId, &message.Body, &message.Sender, &message.Timestamp); err != nil {
			return err
		}
		messages = append(messages, message)
	}

	if err = rows.Err(); err != nil {
		return err
	}
	return c.JSONPretty(http.StatusOK, GetMessages{Messages: messages}, "\t")
}
