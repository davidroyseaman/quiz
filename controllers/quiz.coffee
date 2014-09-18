uuid = require 'node-uuid'
redis = require 'redis'

class Game
  constructor: (@id) ->
    @players = {}
    @redis = redis.createClient()
    @redis.select 0 #should wait for this :P

  loadQuestions: ->
    # ids = client.smembersFuture(req.path).wait()
    # values = client.mgetFuture(ids.map((id)->"#{req.path}#{encodeURIComponent id}")).wait().map (str) -> JSON.parse str
    @redis.smembers '/quiz/questions/', (err, ids) =>
      console.log arguments
      @redis.mget ids.map((id)->"/quiz/questions/#{encodeURIComponent id}"), (err, str) => 
        console.log str


class GameList
  constructor: ->
    @games = {}

  new: ->
    newgameID = uuid.v4()
    @games[newgameID] = new Game newgameID
    return @games[newgameID]



exports.load = (Controller, {Reply}) ->
  client = redis.createClient()

  x =  new Game
  setTimeout -> 
    x.loadQuestions()
  , 1000

  class QuizController extends Controller
    init: ->
      @gamelist = new GameList
      @subscribers = {}


    events: 
      'ws/quiz/subscribe': @middleware([Reply]) (message) ->       
        @subscribers[message.connectionID] = message.reply

      'ws/quiz/newgame': @middleware([Reply]) (message) ->       
        @gamelist.new()
        
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
