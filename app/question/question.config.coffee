angular.module('clarkApp')

.config ($stateProvider) ->

  $stateProvider

  .state 'questions',
    url: '/questions'
    templateUrl: 'app/question/question.html'
    controller: 'QuestionCtrl'

  .state 'questions.detail',
    url: '/:questionId'
    templateUrl: 'app/question/questionDetail.html'
    controller: 'QuestionDetailCtrl'