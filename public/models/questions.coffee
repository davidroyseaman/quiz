define [
  '$'
  'backbone'
], ($, {Model, Collection}) ->
  
  class Question extends Model

  class Questions extends Collection
    model: Question
    url: 'http://rest.zk.io/quiz/questions/'

  {Question, Questions}
