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

table "vessel" {
    schema = schema.public
    column "id" {
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
    column "admin" {
        null = false
        type = text
    }
    primary_key {
        columns = [column.id]
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
    column "message_id" {
        null = false
        type = text
    }
    column "channel_id" {
        null = false
        type = text
    }
    column "message_body" {
        null = false
        type = text
    }
    column "date_created" {
        null = false
        type = timestamp
    }
    column "sender" {
        null = false
        type = text
    }
    primary_key {
        columns = [column.message_id]
    }
}

schema "public" {
    comment = "A schema comment"
}
