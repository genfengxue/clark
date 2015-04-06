angular.module('clarkApp')

.config ($stateProvider) ->

  $stateProvider

  .state 'login',
    url: '/login'
    templateUrl: 'app/login/login.html'
    controller: 'LoginCtrl'

