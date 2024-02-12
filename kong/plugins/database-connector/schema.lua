-- schema.lua

local typedefs = require "kong.db.schema.typedefs"

local schema = {
  name = "db_plugin",
  fields = {
    { consumer = typedefs.no_consumer },
    { protocols = typedefs.protocols_http },
    { config = {
        type = "record",
        fields = {
          { database_type = { type = "string", required = true, one_of = {"Postgres", "MySql", "OracleDB"} } },
          { database = { type = "string", required = true } },
          { host = { type = "string", required = true } },
          { password = { type = "string", required = true } },
          { query = { type = "string", required = true } },
          { username = { type = "string", required = true } },
          { timeout = { type = "number", default = 10000 } },
          { keepalive_timeout = { type = "number", default = 60000 } },
          { keepalive_size = { type = "number", default = 10 } },
        },
      },
    },
  },
}

return schema
