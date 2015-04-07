'use strict'

angular.module('clarkApp').controller 'QuestionCtrl', (
  $scope
  $state
  Restangular
) ->
  Restangular
  .all('student_questions')
  .getList()
  .then (questions) ->
    $scope.questions = questions
    if ($state.params.questionId == undefined) && $scope.questions[0]
      $state.go 'questions.detail',
        questionId: $scope.questions[0]._id
