'use strict'

angular

  .module('galeApp', [])

  .run (
    $rootScope
  ) ->

    console.log 'Hello World'

    $rootScope.name = 'Zhenkun Ou'
