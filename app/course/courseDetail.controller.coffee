'use strict'

angular.module('clarkApp').controller 'CourseDetailCtrl', (
  $scope
  $state
  Restangular
) ->

#  $scope.courseNo = $scope.params.courseNo

  Restangular
  .all('lessons')
  .getList(
    courseNo: $state.params.courseNo
  )
  .then (lessons) ->
    $scope.lessons = lessons
