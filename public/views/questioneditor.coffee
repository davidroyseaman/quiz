define [
  '$'
  'view'
  'templates/questioneditor'
  'templates/question'
  'models/questions'
], ($, View, questionEditorT, questionT, {Question, Questions}) ->
  
  class QuestionView extends View
    template: questionT
    tagName: 'li'
    events:
      'change input': 'save'
      'change textarea': 'save'
      'click .js-new-answer': 'newAnswer'

    init: ->
      @model.set 'answers', [] unless @model.has 'answers'
      @model.set 'text', '' unless @model.has 'text'

    save: ->
      @model.set 'text', @$el.find('.js-text').val()
      @model.set 'answers', @$el.find('.js-answer').toArray().map((el) -> el.value).filter (v) -> v.length > 0
      if @model.get('text').length > 0
        @model.save().then => @reRender()
      else
        @model.destroy().then => @detach()
    

    newAnswer: ->
      @model.get('answers').push('')
      @reRender()

    loaded: ->
      @locals.model = @model


  class QuestionEditorView extends View
    template: questionEditorT
    events:
      'click .js-new-question': 'add'

    init: -> 
      @collection = new Questions
      @waitOn @collection.fetch()

    load: ->
      window.Q = @collection

    render: ->
      @collection.each (model) =>
        model._view = new QuestionView {model}
        @append '.js-questionlist', model._view

    appeared: ->
      @collection.on 'add', => @reRender()
      @collection.on 'remove', => @reRender()

    add: ->
      @collection.create()

  {QuestionEditorView}
