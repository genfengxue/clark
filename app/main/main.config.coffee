'use strict'

angular.module('clarkApp')
  .config ($stateProvider) ->
    $stateProvider
    .state('main',
      url: '/',
      templateUrl: 'app/main/main.html'
      controller: 'MainCtrl'
    )