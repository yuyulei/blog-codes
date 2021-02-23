local typedefs = require "kong.db.schema.typedefs"

return {
  name = "caoliao-terminating",
  fields = {
    { consumer = typedefs.no_consumer },  -- this plugin cannot be configured on a consumer (typical for auth plugins)
    { protocols = typedefs.protocols_http },
    { config = {
        type = "record",
        fields = {
          { request_header = typedefs.header_name {
              default = "Caoliao-Edition-Id" 
            }, 
          },
          { status_code = {
              type = "integer",
              default = 599,
              between = { 100, 599 },
            }, 
          },
          { message = { 
              type = "string",
            }, 
          },
          {
            enabled = {
              type = "boolean",
              default = false,   
            },
          }
        },
      },
    },
  },
}