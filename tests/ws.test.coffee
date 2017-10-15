test = require 'tape'
server = require '../src'

test "Server module has listen and close methods", (assert) ->
  methods = ['listen', 'close']

  methods.map (method) ->
    assert.true typeof server[method]? is 'function', "#{method} implemented"
  assert.end()

test "Server module should return the active port", (assert) ->
  port = server.listen?()
  assert.true typeof port is 'number', "The active port is returned"
  assert.end()
