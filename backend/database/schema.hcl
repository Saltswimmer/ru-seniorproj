table "users" {
    schema = schema.public
    column "user_id" {
        null = false
        type = text
    }
    column "first_name" {
        null = false
        type = text
    }
    column "middle_name" {
        null = true
        type = text
    }
     column "last_name" {
        null = false
        type = text
    }
    column "username" {
        null = false
        type = text
    }
    column "email" {
        null = false
        type = text
		unique = true
    }
    column "pass_hash" {
        null = false
        type = text
    }
    column "date_created" {
        null = false
        type = timestamp
    }
    primary_key {
        columns = [column.user_id]
    }
}

table "vessels" {
    schema = schema.public
    column "vessel_id" {
        null = false
        type = text
    }
    column "name" {
        null = true
        type = text
    }
    column "date_created" {
        null = false
        type = timestamp
    }
    primary_key {
        columns = [column.vessel_id]
    }
}

table "users_vessels" {
    schema = schema.public
    column "user_vessel_id" {
        null = false
        type = text
    }
    column "vessel_id" {
        null = false
        type = text
    }
    column "user_id" {
        null = false
        type = text
    }
    column "is_admin" {
        null = false
        type = text
    }
	column "date_created" {
        null = false
        type = timestamp
    }
    primary_key {
        columns = [column.user_vessel_id]
    }
}

table "channels" {
    schema = schema.public
    column "channel_id" {
        null = false
        type = text
    }
    column "channel_name" {
        null = false
        type = text
    }
    column "type" {
        null = false
        type = text
    }
    column "date_created" {
        null = false
        type = timestamp
    }
    primary_key {
        columns = [column.channel_id]
    }
}

table "message" {
    schema = schema.public
    column "id" {
        null = false
        type = text
    }
    column "body" {
        null = false
        type = text
    }
    column "vessel_id" {
        null = false
        type = text
    }
    column "sender_id" {
        null = false
        type = text
    }
    column "date_created" {
        null = false
        type = timestamp
    }
    primary_key {
        columns = [column.id]
    }
}

table "following" {
    schema = schema.public
    column "relationship_id" {
        null = false
        type = text
    }
    column "follower_id" {
        null = false
        type = text
        references = "user(id)"
    }
    column "following_id" {
        null = false
        type = text
        references = "user(id)"
    }

}

schema "public" {
    comment = "A schema comment"
}
