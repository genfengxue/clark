'use strict'

angular.module('clarkApp').controller 'SentenceDetailCtrl', (
  $scope
  $state
  Restangular
) ->

  angular.extend $scope,

    saveKeyPointKey: (keyPoint)->
      Restangular.one('sentences', $scope.sentence._id)
      .one('update_key', keyPoint._id)
      .patch({key: keyPoint.key})
      .then ->
        console.log 'succeed!'
        keyPoint.$editingKey = false;

      .catch (error) ->
        console.log 'error'

    editKeyPointKey: (keyPoint)->
      keyPoint.$orignKey = keyPoint.key
      keyPoint.$editingKey = true

    cancelKeyPointKey: (keyPoint)->
      keyPoint.key = keyPoint.$orignKey
      keyPoint.$editingKey = false;


    saveKp: (kp)->
      Restangular.one('key_points', kp.kp._id)
      .patch(kp.kp)
      .then ->
        console.log 'succeed!'
        kp.$editing = false;

      .catch (error) ->
        console.log 'error'

    editKp: (kp)->
      kp.$orignText = kp.kp.text
      kp.$editing = true

    cancelKp: (kp)->
      kp.kp.text = kp.$orignText
      kp.$editing = false;

  $scope.$watch 'sentences', (value)->
    return if !value
    $scope.sentence = _.find $scope.sentences, (sentence)->
      sentence.sentenceNo == +$state.params.sentenceNo


