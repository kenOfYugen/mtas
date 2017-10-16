{createServer} = require 'http'

# TODO: make a default static file server
requestHandler = (req, res) ->
  res.writeHead 200, 'Content-Type': 'text/html'
  res.end 'hello'


# TODO: modify to use event listener
# TODO: add error handling mechanism
# TODO: handle case where port is already in use
serverFactory = (handler=requestHandler, port=3000) ->
  activeServer = null
  server = createServer requestHandler

  {
    listen: -> activeServer = server.listen port
    close: -> server.close(); activeServer = null
    getPort: -> activeServer?.address().port
    getHostName: -> activeServer?.address().address
  }

module.exports = serverFactory
