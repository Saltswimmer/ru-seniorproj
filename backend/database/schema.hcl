table "users" {
    schema = schema.public
    column "user_id" {
        null = false
        type = int
    }
    column "first_name" {
        null = true
        type = varchar(100)
    }
    column "middle_name" {
        null = true
        type = varchar(100)
    }
     column "last_name" {
        null = true
        type = varchar(100)
    }
    column "username" {
        null = true
        type = varchar(100)
    }
    column "email" {
        null = true
        type = varchar(100)
    }
    column "date_created" {
        null = false
        type = date
    }
    primary_key {
        columns = [column.user_id]
    }
}

table "servers" {
    schema = schema.public
    column "server_id" {
        null = false
        type = int
    }
    column "server_name" {
        null = true
        type = varchar(100)
    }
    column "date_created" {
        null = false
        type = date
    }
    column "admin" {
        null = true
        type = varchar(100)
    }
    primary_key {
        columns = [column.server_id]
    }
}

table "channels" {
    schema = schema.public
    column "channel_id" {
        null = false
        type = int
    }
    column "channel_name" {
        null = true
        type = varchar(100)
    }
    column "type" {
        null = true
        type = varchar(100)
    }
    column "date_created" {
        null = false
        type = date
    }
    primary_key {
        columns = [column.channel_id]
    }
}

table "message" {
    schema = schema.public
    column "message_id" {
        null = false
        type = int
    }
    column "channel_id" {
        null = false
        type = varchar(100)
    }
    column "message_body" {
        null = true
        type = varchar(100)
    }
    column "date_created" {
        null = false
        type = date
    }
    column "sender" {
        null = false
        type = varchar(100)
    }
    primary_key {
        columns = [column.message_id]
    }
}

schema "public" {
    comment = "A schema comment"
}