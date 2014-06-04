define [
  '$'
  'view'
  'templates/newgame'
  'controllers/quiz'  
], ($, View, newgameT, {QuizController}) ->
  class NewGameView extends View
    template: newgameT
    events:
      'click .js-done': (e) ->
        @trigger 'newgame'
        name = @$('.js-gamename').val()
        @quizController.createNewGame {name}
        
        # GROSSS
        Backbone.history.navigate '/', true

    init: ->  
      @quizController = QuizController.instance()

    appeared: ->

  {NewGameView}
