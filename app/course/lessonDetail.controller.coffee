'use strict'

angular.module('clarkApp').controller 'LessonDetailCtrl', (
  $scope
  $state
  Restangular
) ->
  Restangular
  .all('sentences')
  .getList(
    courseNo: $state.params.courseNo
    lessonNo: $state.params.lessonNo
  )
  .then (sentences) ->
    $scope.sentences = sentences