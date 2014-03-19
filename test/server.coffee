assert = require 'assert'
restify = require 'restify'
proxyquire = require 'proxyquire'

db = {wat:'hai'}

db.servers = (opts, cb) ->
  servers = [
    { ip: '127.0.0.1', port: 27015 }
  ]
  setTimeout ->
    cb null, servers

server = proxyquire '../server.coffee',
  './lib/db.coffee': db

client = restify.createJsonClient
  url: 'http://localhost:3000'
  version: '~0.0'

describe 'servers', ->
  it 'should return some pts servers', (done) ->
    client.get '/servers?gameType=pts', (err, req, res, obj) ->
      done assert.equal obj[0].port, 27015
