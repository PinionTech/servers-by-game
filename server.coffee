restify = require 'restify'
time = require 'time'
moment = require 'moment-timezone'

db = require './lib/db.coffee'

server = restify.createServer
  name: 'server-by-gametype'
  version: '0.0.0'

server.use restify.queryParser()

server.get '/servers', (req, res, next) ->
  qs = req.query
  since = qs.since or moment().tz('UTC').subtract('week', 1).format('X')
  db.servers {game: qs.game, since: since}, (err, servers) ->
    res.send 500 if err?
    res.send servers
    next()

server.listen 3000
