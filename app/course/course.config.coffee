angular.module('clarkApp')

.config ($stateProvider) ->

  $stateProvider

  .state 'courses',
    url: '/courses'
    templateUrl: 'app/course/course.html'
    controller: 'CourseCtrl'

  .state 'courses.courseDetail',
    url: '/:courseNo'
    templateUrl: 'app/course/courseDetail.html'
    controller: 'CourseDetailCtrl'

  .state 'courses.courseDetail.lessonDetail',
    url: '/lessons/:lessonNo'
    templateUrl: 'app/course/lessonDetail.html'
    controller: 'LessonDetailCtrl'

  .state 'courses.courseDetail.lessonDetail.sentenceDetail',
    url: '/sentences/:sentenceNo'
    templateUrl: 'app/course/sentenceDetail.html'
    controller: 'SentenceDetailCtrl'