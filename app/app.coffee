'use strict'

angular.module('clarkApp', [
  'ipCookie'
  'ngStorage'
  'ui.router'
  'restangular'
])
.config (RestangularProvider) ->
  # add a response intereceptor
  RestangularProvider.setBaseUrl('http://localhost:9000/api')
  RestangularProvider.setRestangularFields(id: "_id")
  RestangularProvider.addResponseInterceptor (data, operation, what, url, response, deferred) ->
    if operation is "getList" and data.results
      data.results.$count = data.count
      data.results
    else
      data

.run (
  Auth
  $rootScope
  Restangular
) ->
  $rootScope.Auth = Auth



  console.log 'Hello World'
  $rootScope.name = 'Zhenkun Ou'
  Restangular.all('sentences').getList({lessonNo: 12})
  .then (result) ->
    console.log result
