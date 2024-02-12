local mysql = require "resty.mysql"

local EmployeePlugin = {
  PRIORITY = 990,
  VERSION = "1.0.0",
}

function EmployeePlugin:access(config)
  local ngx = ngx
  local kong = kong

  kong.log.err("Inside Access method")

  local db, err = mysql:new()
  if not db then
    kong.log.err(err.message)
    return kong.response.exit(500, { message = "Internal Server Error" })
  end

  db:set_timeout(config.timeout)

  local ok, err, errno, sqlstate = db:connect({
    database = config.database,
    host = config.host,
    password = config.password,
    user = config.username,
  })

  if not ok then
    kong.log.err("Failed to connect to database: ", err)
    return kong.response.exit(500, { message = "Internal Server Error" })
  end

  kong.service.request.enable_buffering()

  kong.log.err("Connection created")

  local res, err, errno, sqlstate = db:query(config.query)
  if not res then
    kong.log.err('Got some issues: ', err)
    return kong.response.exit(500, { message = err.message })
  end

  kong.log.err("Query executed")

  kong.response.exit(200, res)
  -- Close the connection
  local ok, err = db:close()
  if not ok then
    kong.log.err("failed to close: ", err)
    return kong.response.exit(500, { message = "Internal Server Error" })
  end

  -- Set keepalive
  local ok, err = db:set_keepalive(config.keepalive_timeout, config.keepalive_size)
  if not ok then
    kong.log.err("failed to set keepalive: ", err)
    return
  end


end

return EmployeePlugin
