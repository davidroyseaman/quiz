define [
  'controller'
  '$'
], (Controller, $) ->

  class QuizController extends Controller
    channels: 
      quiz:
        newgame: (data) ->          
          console.log 'NEW GAME!', data

        games: (data) ->
          @trigger 'games', data

    init: ->
      # @waitOn new Promise (resolve, reject) ->
      #   window.setTimeout resolve, 3000

    createNewGame: (gameObj) ->
      @send 'quiz', 'newgame', gameObj

    getGames: ->
      @send 'quiz', 'getgamelist'
      new Promise (resolve, reject) =>
        @once 'games', (games) ->        
          resolve games

  return {QuizController}
