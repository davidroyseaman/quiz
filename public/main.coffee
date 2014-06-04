define [
  '$'
  'view'
  'application'
  'pagesystem'
  'templates/layout'
  'controllers/quiz'
  'views/titlepage'
  'views/newgame'
  'views/questioneditor'
  
], ($, View, Application, PageSystem, layoutT, {QuizController}, {TitlepageView}, {NewGameView}, {QuestionEditorView}) ->
  
  class QuizApp extends Application
    title: "Quiz"
    template: layoutT
    init: ->
      @pages = new PageSystem {
        '': TitlepageView
        'new': NewGameView
        'question-editor': QuestionEditorView
        #'lobby/:id': LobbyView
        #'game/:id': GameView
      }
      window.qc = qc = QuizController.instance()
      qc.Promise('loaded').then () ->
        console.log 'loaded?', arguments


    load: ->
    render: ->
      # I'm going to do slightly ghetto 'page' stuff here to let you switch
      # between views.  eg. you have to load the 'new game' view from the 
      # title page, hiding the title page in the process.
      # @titlepage ?= new TitlepageView
      # @append '.js-content', @titlepage

      # @titlepage.on 'newgame', =>
      #   @newgame ?= new NewGameView
      #   @titlepage.detach()
      #   @append '.js-content', @newgame
      #   @newgame.once 'cancel', =>
      #     @newgame.detach()
      #     @append '.js-content', @titlepage

      @append '.js-content', @pages



    appeared: ->


  (new QuizApp).start()


