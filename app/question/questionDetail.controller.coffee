'use strict'

angular.module('clarkApp').controller 'QuestionDetailCtrl', (
  $scope
  $state
  Restangular
) ->
  $scope.reply = ->
    Restangular
    .one("student_questions", $state.params.questionId)
    .customPOST({msgText: $scope.replyMsg}, "msg")
    .then (question) ->
      $scope.question = question

  Restangular
  .one('student_questions', $state.params.questionId)
  .get()
  .then (question) ->
    $scope.question = question