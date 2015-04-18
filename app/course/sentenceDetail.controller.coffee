'use strict'

angular.module('clarkApp').controller 'SentenceDetailCtrl', (
  $scope
  $state
  Restangular
) ->

  angular.extend $scope,

    saveKeyPoint: (keyPoint)->
      Restangular.one('key_points', keyPoint.kp._id)
      .patch(keyPoint.kp)
      .then ->
        console.log 'succeed!'
        keyPoint.$editing = false;

      .catch (error) ->
        console.log 'error'

    editKeyPoint: (keyPoint)->
      keyPoint.$orignText = keyPoint.kp.text
      keyPoint.$editing = true

    cancelKeyPoint: (keyPoint)->
      keyPoint.kp.text = keyPoint.$orignText
      keyPoint.$editing = false;

  $scope.$watch 'sentences', (value)->
    return if !value
    $scope.sentence = _.find $scope.sentences, (sentence)->
      sentence.sentenceNo == +$state.params.sentenceNo


