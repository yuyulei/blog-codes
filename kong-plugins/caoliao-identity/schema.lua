local typedefs = require "kong.db.schema.typedefs"

return {
  name = "caoliao-identity",
  fields = {
    { consumer = typedefs.no_consumer },  -- this plugin cannot be configured on a consumer (typical for auth plugins)
    { protocols = typedefs.protocols_http },
    {
      config = {
        type = "record",
        fields = {
          { request_header = typedefs.header_name {
              default = "Caoliao-Identity-Flag" 
            }, 
          },
          { controller_addr = {
              type = "string",
              required = true
            },
          },
          { timeout_millisecond = { 
              type = "number", 
              gt = 0,
              default = 500
            }, 
          },
        },
      },
    },
  },
}
