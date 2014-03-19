restify = require 'restify'
db = require './lib/db.coffee'

server = restify.createServer
  name: 'server-by-gametype'
  version: '0.0.0'

server.get '/servers', (req, res, next) ->
  db.servers {game: req.query.gameType, since: 0}, (err, servers) ->
    res.send 500 if err?
    res.send servers
    next()

server.listen 3000
