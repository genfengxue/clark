'use strict'

angular.module('clarkApp').controller 'QuestionCtrl', (
  $scope
  Restangular
) ->

  Restangular
  .all('student_questions')
  .getList()
  .then (questions) ->
    $scope.questions = questions