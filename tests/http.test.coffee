test = require 'tape'
type = require 'tcomb'

request = require 'request'
{readFileSync} = require 'fs'
serverFactory = require '../src'


test "Server module has listen and close methods", (assert) ->
  server = serverFactory()

  [
    'listen'
    'close'
    'getPort'
    'getHostName'
  ].map (method) ->
    assert.true(
      type.Function server[method]
      "#{method} method appears to be implemented"
    )

  assert.end()

test "Server module should return the active port and host name", (assert) ->
  {listen, getPort, getHostName, close} = serverFactory()

  listen 3000

  assert.true(
    type.Number getPort()
    "A number is returned, hopefully it's the active port"
  )

  assert.true(
    getPort() is 3000
    "Server is listening on predefined port"
  )

  assert.true(
    type.String getHostName()
    "A string is returned indicating host name"
  )

  close()

  assert.end()

test "Server module should select a port when none is provided", (assert) ->
  {listen, close, getPort} = serverFactory()

  listen()

  assert.true(
    type.Number getPort()
    "A port number is returned"
  )

  close()
  assert.end()

test "Server module is responding when active", (assert) ->
  {listen, close, getPort, getHostName} = serverFactory()
  listen()
  port = getPort()
  hostName = getHostName()

  request "http://#{hostName}:#{port}", (err, response, body) ->
    assert.error(
      err
      "Server is reachable"
    )

    close()
    assert.end()

test "Server module responds with requested file contents", (assert) ->
  {listen, close, getPort, getHostName} = serverFactory()
  listen()
  port = getPort()
  hostName = getHostName()

  request "http://#{hostName}:#{port}/http.test.coffee", (err, response, body) ->

    expected = (readFileSync "#{__dirname}/http.test.coffee").toString()

    assert.equal(
      body, expected
      "The static file server is retrieving the requested file contents"
    )

    close()
    assert.end()
