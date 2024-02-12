-- transform upstream response
return function(status, body, headers)
    if not body or not body.message then
        return status, body, headers
    end

    headers = {["X-Some-Header"] = "ERP Triggered"}
    local new_body = {
        error = "Invalid operation performed.",
        status = 405,
        message = body.message .. ", Achtung!",
    }

    return new_body.status, new_body, headers
end