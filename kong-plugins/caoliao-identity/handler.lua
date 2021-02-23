local cjson = require "cjson"
local http = require "resty.http"
local ngx = ngx
local tostring = tostring

local kong = kong

local identity = {
  PRIORITY = 999, -- after auth and before rate-limiting
  VERSION = "0.1"
}

function identity:init_worker()
  kong.log.debug("saying hi from the 'init_worker' handler")
end

function identity:access(conf) 
  local httpc = http.new()

  -- local header_content = kong.request.get_header(conf.request_header)
  -- local path = kong.request.get_path()
  -- local url = "http://"..conf.controller_addr.."/identity?".."path="..path

  -- if header_content and #header_content > 0 then 
  --   url = url.."&"..header_content
  -- end
  -- kong.log("try to get info by url["..url.."]")

  -- local res, err = httpc:request_uri(url, {
  --   method = "GET",
  --   ssl_verify = false,
  -- })

  local new_path = "/identity"
  local new_query = "path="..kong.request.get_path()

  -- Add original request queries
  new_query = new_query.."&"..kong.request.get_raw_query()

  -- Add extend queries in header
  new_query = new_query.."&"..kong.request.get_header(conf.request_header)

  local res, err = httpc:request_uri(conf.controller_addr, {
    method = "GET",
    path = new_path..new_query,
    keepalive_timeout = 500,
    keepalive_pool = 100   
  })

  if not res then
    kong.response.set_header()

  -- if not res then
  --   kong.log.err("fail to get identity, maybe network problem, err: ", tostring(err))
  --   return 
  -- end
  -- if res.status ~= 200 then
  --   kong.log.err("fail to get identity, maybe mysql/redis problem, err: ", tostring(err))
  --   return 
  -- end

  local data = cjson.decode(res.body)

  for k, v in pairs(data) do 
    kong.service.request.set_header(k , v)
  end
end 

function identity:header_filter(conf)
end

return identity