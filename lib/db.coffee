redis = require 'redis'
time = require 'time'
EventEmitter = require('events').EventEmitter

db =
  port: process.env.REDIS_PORT or 6379
  host: process.env.REDIS_DOMAIN or '127.0.0.1'

if process.env.REDIS_AUTH?
  db.auth = process.env.REDIS_AUTH

DB = ->
  @client = redis.createClient db.port, db.host

  if db.auth?
    @client.auth db.auth, (err) ->
      throw err if err?

  @client.on 'connect', =>
    @emit 'connected'
    @client.select 9, (err, res) =>
      @emit 'info', 'Database selected: ', res
    @client.on 'error', (err) =>
      @emit 'error', new Error err
  return this

DB.prototype = EventEmitter.prototype

DB.prototype.servers = (opts, cb) ->
  now = new time.Date()
  now.setTimezone 'UTC'

  args = [opts.game, now.getTime(), opts.since]
  @client.zrevrangebyscore args, cb

module.exports = new DB()
