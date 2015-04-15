gulp = require("gulp")
less = require("gulp-less")
inject = require("gulp-inject")
coffee = require("gulp-coffee")
gutil = require("gulp-util")
order = require("gulp-order")
concat = require("gulp-concat")
connect = require('gulp-connect')
bowerFiles = require("main-bower-files")
runSequence = require("run-sequence")
del = require("del")
historyApiFallback = require('connect-history-api-fallback')
angularTemplatecache = require("gulp-angular-templatecache")
usemin = require("gulp-usemin")

configs =
  match: "baseUrl"
  replacement: "'http://data.genfengxue.com/api'"

paths =
  coffee: ["app/**/*.coffee"]
  less: ["app/**/*.less", "!bower_components/**/*.less"]
  js: [".tmp/**/*.js", ".tmp/**/**/*.js"]
  css: [".tmp/**/*.css"]
  html: ["app/**/*.html"]
  bowerComponents: './bower_components'
  index: '.tmp/index.html'
  tmp: '.tmp/'

gulp.task "clean", ->
  del.sync paths.tmp

gulp.task "index", (done)->
  gulp.src('app/index.html')
    .pipe(gulp.dest(paths.tmp))

gulp.task "coffee", ->
  gulp.src(paths.coffee)
    .pipe(coffee().on('error', gutil.log))
    .pipe(gulp.dest(paths.tmp))
    .pipe(connect.reload())

gulp.task 'less', ->
  gulp.src(paths.less)
    .pipe(less().on('error', gutil.log))
    .pipe(gulp.dest(paths.tmp))
    .pipe(connect.reload())

gulp.task "inject:css", ->
  cssSources = gulp.src(paths.css, read: false).pipe order()
  gulp.src(paths.index)
    .pipe(inject(cssSources, relative: true))
    .pipe gulp.dest(paths.tmp)

gulp.task "inject:js", ->
  jsSources = gulp.src(paths.js, read: false).pipe order()
  gulp.src(paths.index)
    .pipe(inject(jsSources, relative: true))
    .pipe gulp.dest(paths.tmp)

gulp.task "bower", ->
  jsSources =
    gulp.src(bowerFiles(filter: /.js$/),
      base: paths.bowerComponents
      read: false
    )
  cssSources =
    gulp.src(bowerFiles(filter: /.css$/),
      base: paths.bowerComponents
      read: false
    )
  gulp.src(paths.index)
    .pipe(inject(jsSources,
      relative: true
      starttag: "<!-- bower:js -->"
      endtag: "<!-- endbower -->"
      transform: (filePath) ->
        "<script src=\"" + filePath + "\"></script>"
    ))
    .pipe(inject(cssSources,
      relative: true
      starttag: "<!-- bower:css -->"
      endtag: "<!-- endbower -->"
      transform: (filePath) ->
        "<link rel=\"stylesheet\" href=\"" + filePath + "\">"
    ))
    .pipe gulp.dest(paths.tmp)

# FIXME refresh the page
gulp.task 'watch', ->
  gulp.watch(paths.coffee, ['coffee'])
  gulp.watch(paths.less, ['less'])

gulp.task 'server', ->
  connect.server
    root: [paths.tmp, '.']
    port: 9002
    livereload: true
    middleware: ()->
       [ historyApiFallback ]

gulp.task 'usemin', ->
  gulp.src paths.index
  .pipe usemin()
  .pipe gulp.dest(paths.tmp)

gulp.task 'templates:make', ->
  gulp.src paths.html
  .pipe angularTemplatecache(
    module: 'clarkApp'
    root: 'app/'
  )
  .pipe gulp.dest(paths.tmp)

gulp.task 'templates:concat', ->
  gulp.src [
      paths.tmp + "app.js"
      paths.tmp + "templates.js"
  ]
  .pipe concat('app.js')
  .pipe gulp.dest(paths.tmp)


gulp.task 'default', ->
  runSequence(
    'clean'
    'index'
    'bower'
    'coffee'
    'inject:js'
    'less'
    'inject:css'
    'server'
    'watch'
  )

gulp.task 'build', ->
  runSequence(
    'clean'
    'index'
    'bower'
    'coffee'
    'inject:js'
    'less'
    'inject:css'
    'usemin'
    'templates:make'
    'templates:concat'
  )
