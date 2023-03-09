table "users" {
    schema = schema.public
    column "user_id" {
        null = false
        type = text
    }
    column "first_name" {
        null = true
        type = text
    }
    column "middle_name" {
        null = true
        type = text
    }
     column "last_name" {
        null = true
        type = text
    }
    column "username" {
        null = true
        type = text
    }
    column "email" {
        null = true
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

table "servers" {
    schema = schema.public
    column "server_id" {
        null = false
        type = text
    }
    column "server_name" {
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
        columns = [column.server_id]
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
