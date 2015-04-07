angular.module('clarkApp')

.config ($stateProvider) ->

  $stateProvider

  .state 'question',
    url: '/questions'
    templateUrl: 'app/question/question.html'
    controller: 'QuestionCtrl'

