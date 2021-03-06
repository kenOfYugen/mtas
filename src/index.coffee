{createServer} = require 'http'
{readFile} = require 'fs'
{parse} = require 'url'


# TODO: need to enforce limitations to ../../ sequences
requestHandler = (req, res) -> switch req.url
  when '/favicon.ico'
    res.writeHead 404
    res.end()
  when '/'
    ###
    readFile "#{__dirname}/tmp/index.html", 'utf8', (err, data) ->
      throw err if err
      res.writeHead 200, 'Content-Type': 'text/html'
      res.write data
      res.end()
    ###

    res.writeHead 200, 'Content-Type': 'text/html'
    res.write 'ok'
    res.end()
  else
    readFile "#{__dirname}#{req.url}", 'utf8', (err, data) ->
      throw err if err
      res.writeHead 200, 'Content-Type': 'text/javascript'
      res.write data
      res.end()



# TODO: modify to use event listener
# TODO: add error handling mechanism
# TODO: handle case where port is already in use
# TODO: need to fix IPv6/4 quirks
serverFactory = ->
  activeServer = null
  server = createServer requestHandler

  {
    listen: (port=3000) -> activeServer = server.listen port
    close: -> server.close(); activeServer = null
    getIPVersion: -> [..., version] = activeServer?.address().family; version
    getPort: -> activeServer?.address().port
    getHostName: -> activeServer?.address().address
  }

module.exports = serverFactory
