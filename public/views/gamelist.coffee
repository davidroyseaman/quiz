define [
  '$'
  'view'
  'templates/gamelist'
  'controllers/quiz'
], ($, View, gamelistT, {QuizController}) ->
  class GamelistView extends View
    template: gamelistT
    # events:
    #   'click .js-done': (e) ->
    #     @trigger 'newgame'

    init: -> 
      @controller = QuizController.instance()
      @waitOn @controller.Promise 'loaded'

    load: ->
      console.log 'load'
      promise = @controller.getGames()
      @waitOn promise
      promise.then ({games}) =>        
        console.log games
        @locals.games = games

    appeared: ->

  {GamelistView}
