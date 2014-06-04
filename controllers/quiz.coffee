uuid = require 'node-uuid'
redis = require 'redis'

###
  Redis keys:
    games: hash of IDs to game objects

###


exports.load = (Controller, {Reply}) ->
  client = redis.createClient()

  class QuizController extends Controller
    events: 
      'ws/quiz/newgame': @middleware([Reply]) (message) ->       
        newgameID = uuid.v4()

        client.hset "games", "#{newgameID}", JSON.stringify(message.data), (err) ->
          message.reply.send 'quiz', {command: 'newgame', id:undefined, data:{gameID: newgameID}}

      'ws/quiz/getgamelist': @middleware([Reply]) (message) ->
        client.hgetall "games", (err, list) ->
          console.log err
          console.log 'gamelist', arguments

          # need to expand stored JSON
          list[key] = JSON.parse(value) for key, value of list
      
          message.reply.send 'quiz', {command: 'games', id:undefined, data:{games: list}}


    init: ->
      client.select 3, () =>
        @log 'Shit I should wait for this somehow...'

  return QuizController
