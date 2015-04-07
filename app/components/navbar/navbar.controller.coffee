'use strict'

angular.module('clarkApp').controller 'NavbarCtrl', ($scope, $location, Auth) ->
  $scope.menu = [
    {
      title: 'Home'
      state: 'main'
    },
    {
      title: 'Questions'
      state: 'questions'
    }
  ]
  $scope.isCollapsed = true
  $scope.isLoggedIn = Auth.isLoggedIn
  $scope.isAdmin = Auth.isAdmin
  $scope.getCurrentUser = Auth.getCurrentUser
  
  $scope.logout = ->
    Auth.logout()
    $location.path '/login'
