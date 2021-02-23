local kong = kong
local tonumber = tonumber

local function is_empty(s)
  return s == nil or s == '' 
end

local terminating = {
  PRIORITY = 2, -- after auth and before rate-limiting
  VERSION = "0.1"
}

function terminating:init_worker()
    kong.log.debug("saying hi from the 'init_worker' handler")
  end

function terminating:access(conf)
  if conf.enabled ~= true then 
    return 
  end

  local edition = kong.request.get_header(conf.request_header)
  
  if is_empty(edition) then 
    return kong.response.exit(conf.status_code, conf.message)
  end

  local editionId = tonumber(edition)
  if not editionId then 
    return kong.response.exit(500, edition.." of header["..conf.request_header.."] maybe not expected")
  end

  if editionId <= 1 then 
    kong.log("receive a free request with edition type["..edition.."]")
    return kong.response.exit(conf.status_code, conf.message)
  end

  kong.log("receive a vip request with edition type["..edition.."]")
end 

function terminating:header_filter(conf)
end

return terminating