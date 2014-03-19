assert = require 'assert'
restify = require 'restify'
moment = require 'moment-timezone'
proxyquire = require 'proxyquire'

db = {}

server = proxyquire '../server.coffee',
  './lib/db.coffee': db

client = restify.createJsonClient
  url: 'http://localhost:3000'

describe 'servers', ->
  beforeEach (done) ->
    db.servers = (opts, cb) ->
      servers = [
        { ip: '127.0.0.1', port: 27015 }
      ]
      setTimeout ->
        cb null, servers
    done()

  it 'should return some pts servers', (done) ->
    client.get '/servers?game=pts', (err, req, res, obj) ->
      done assert.equal obj[0].port, 27015
  it 'should set a week as the default date range', (done) ->
    db.servers = (opts, cb) ->
      assert.equal opts.since, moment().tz('UTC').subtract('week', 1).format('X')
      servers = [
        { ip: '127.0.0.1', port: 27015 }
      ]
      setTimeout ->
        cb null, servers
    client.get '/servers?game=pts', done
  it 'should pass the game', (done) ->
    db.servers = (opts, cb) ->
      assert.equal opts.game, 'pts'
      servers = [
        { ip: '127.0.0.1', port: 27015 }
      ]
      setTimeout ->
        cb null, servers
    client.get '/servers?game=pts', done
