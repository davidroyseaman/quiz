uuid = require 'node-uuid'

###
ZMQ layout

command & control node.
Connectors send channels they will produce and consume on.
ie websocket will say
  produce: ['client']
  consume: ['client']


ZMQ messages
{
  channel: 'quiz'
  sender: uid
  seq: sequential id?
}


###


class QuizController extends Controller
  constructor: ->
    @input = new ZMQStream 8000
    @output = new ZMQStream 8500

    @quiz = @input.filter (m) -> m.channel == 'quiz'

    @player = @quiz.filter (m) -> m.sender == playerID





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

    
    'ws/quiz/game/join': (message) ->
      connectionID = message.connectionid
      game = @GameList[message.data.gameID]

      game?.join connectionID
    
    'ws/quiz/game/leave': (message) ->
      game.leave message.id
    
    'ws/quiz/game/playerstate': (message) ->
      game.state message.id, message.data

    'ws/quiz/game/start': (message) ->
      game.start()



  return QuizController
