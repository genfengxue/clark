'use strict'

angular.module('clarkApp', [
  'ipCookie'
  'ngStorage'
  'ui.router'
  'restangular'
])

.config ($stateProvider, $urlRouterProvider, $locationProvider, $httpProvider) ->
  $urlRouterProvider.otherwise('/')
  $httpProvider.interceptors.push 'authInterceptor'
  $httpProvider.interceptors.push 'urlInterceptor'
#  $httpProvider.interceptors.push 'patchInterceptor'
#  $httpProvider.interceptors.push 'objectIdInterceptor'
#  $httpProvider.interceptors.push 'loadingInterceptor'
#  $httpProvider.interceptors.push 'errorHttpInterceptor'

.config (RestangularProvider, configs) ->
  # add a response intereceptor
  RestangularProvider.setBaseUrl(configs.baseUrl)
  RestangularProvider.setRestangularFields(id: "_id")
  RestangularProvider.addResponseInterceptor (data, operation, what, url, response, deferred) ->
    if operation is "getList" and data.results
      data.results.$count = data.count
      data.results
    else
      data


.factory 'urlInterceptor', ($rootScope, $q, $location, configs) ->
  # Add authorization token to headers
  request: (config) ->
    config.url = configs.baseUrl + config.url if /^(|\/)(api|auth)/.test config.url
    config
  post: (config) ->
    config.url = configs.baseUrl + config.url if /^(|\/)(api|auth)/.test config.url
    config


.factory 'authInterceptor', ($rootScope, ipCookie, $q) ->
  # Add authorization token to headers
  request: (config) ->
    # When not withCredentials, should not carry Authorization header either
    if config.withCredentials is false
      return config
    config.headers = config.headers or {}
    config.headers.Authorization = 'Bearer ' + ipCookie('token') if ipCookie('token')
    config

  # Intercept 401s and redirect you to login
  responseError: (response) ->
    if response.status is 401
      # remove any stale tokens
      ipCookie.remove 'token'
      $q.reject response
    else
      $q.reject response


.run (
  Auth
  $rootScope
  Restangular
) ->
  $rootScope.Auth = Auth

  Auth.refreshCurrentUser()

