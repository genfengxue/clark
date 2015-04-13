'use strict'

angular.module('clarkApp').controller 'SentenceDetailCtrl', (
  $scope
  $state
  Restangular
) ->

  angular.extend $scope,

    saveKeyPoint: (keyPoint)->
      console.log keyPoint


  $scope.$watch 'sentences', (value)->
    return if !value
    $scope.sentence = _.find $scope.sentences, (sentence)->
      sentence.sentenceNo == +$state.params.sentenceNo


