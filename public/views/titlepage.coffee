define [
  '$'
  'view'
  'views/gamelist'
  'templates/titlepage'
], ($, View, {GamelistView}, titlepageT) ->
  class TitlepageView extends View
    template: titlepageT
    events: {}

    init: ->

    render: ->
      console.log 'wat'
      @gamelistview = new GamelistView
      @append '.js-game-list', @gamelistview
      
    appeared: ->

  {TitlepageView}
