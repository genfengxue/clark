'use strict'

angular.module('clarkApp').controller 'CourseCtrl', (
  $scope
  $state
  Restangular
) ->
  Restangular
  .all('courses')
  .getList()
  .then (courses) ->
    $scope.courses = courses
    $scope.courseNo = $scope.params?.courseNo
