assert = require 'assert'
proxyquire = require 'proxyquire'

redis = {}

redis.createClient = ->
  client =
    on: ->
      return
    zrevrangebyscore: (arr, cb) ->
      servers = [
        { ip: '127.0.0.1', port: 27015 }
      ]
      setTimeout ->
        cb null, servers
  return client

db = proxyquire '../lib/db.coffee',
  redis: redis

db.on 'info', (a, b) ->
  console.log a, b

describe 'api', ->
  it 'should return some pts servers', (done) ->
    db.servers {game: 'pts', since: 0}, (err, servers) ->
      assert servers.length > -1
      assert.equal servers[0].port, 27015
      done()
