'use strict'

angular.module('clarkApp').controller 'SentenceDetailCtrl', (
  $scope
  $state
  Restangular
) ->

  $scope.$watch 'sentences', (value)->
    return if !value
    $scope.sentence = _.find $scope.sentences, (sentence)->
      sentence.sentenceNo == +$state.params.sentenceNo

    console.log $scope.sentence