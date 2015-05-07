'use strict'

angular.module('clarkApp').controller 'SentenceDetailCtrl', (
  $scope
  $state
  $modal
  Restangular
) ->

  angular.extend $scope,

    saveSentence: (sentence)->
      Restangular.one('sentences', $scope.sentence._id)
      .patch(_.pick(sentence, ['english', 'chinese']))
      .then ->
        console.log 'succeed!'
        sentence.$editing = false;
      .catch (error) ->
        console.log error

    editSentence: (sentence)->
      sentence.$orign = _.pick sentence, ['english', 'chinese']
      sentence.$editing = true

    cancelSentence: (sentence)->
      sentence =  _.merge sentence, sentence.$orign
      sentence.$editing = false;

    saveKeyPointKey: (keyPoint)->
      Restangular.one('sentences', $scope.sentence._id)
      .one('update_key', keyPoint._id)
      .patch({key: keyPoint.key})
      .then ->
        console.log 'succeed!'
        keyPoint.$editingKey = false;
      .catch (error) ->
        console.log error

    editKeyPointKey: (keyPoint)->
      keyPoint.$orignKey = keyPoint.key
      keyPoint.$editingKey = true

    cancelKeyPointKey: (keyPoint)->
      keyPoint.key = keyPoint.$orignKey
      keyPoint.$editingKey = false;

    deleteKeyPoint: (keyPoint)->
      Restangular.one('sentences', $scope.sentence._id)
      .one('delete_key', keyPoint._id)
      .patch()
      .then (sentence)->
        $scope.sentence.keyPoints = sentence.keyPoints
      .catch (err) ->
        console.log err

    saveKp: (kp)->
      Restangular.one('key_points', kp.kp._id)
      .patch(kp.kp)
      .then ->
        console.log 'succeed!'
        kp.$editing = false;
      .catch (error) ->
        console.log error

    editKp: (kp)->
      kp.$orignText = kp.kp.text
      kp.$editing = true

    cancelKp: (kp)->
      kp.kp.text = kp.$orignText
      kp.$editing = false;


    addNewKeyPoint: ->
      $modal.open
        templateUrl: 'app/keyPoint/newKeyPoint.html'
        controller: 'NewKeyPointCtrl'
        windowClass: 'new-key-point-modal'
        backdrop: 'static'
        resolve:
          sentence: -> $scope.sentence
      .result.then ->
        console.log 'succeed!'

  $scope.$watch 'sentences', (value)->
    return if !value
    $scope.sentence = _.find $scope.sentences, (sentence)->
      sentence.sentenceNo == +$state.params.sentenceNo


