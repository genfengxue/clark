gulp = require("gulp")
less = require("gulp-less")
inject = require("gulp-inject")
coffee = require("gulp-coffee")
gutil = require("gulp-util")
order = require("gulp-order")
connect = require('gulp-connect')
bowerFiles = require("main-bower-files")
runSequence = require("run-sequence")
del = require("del")

paths =
  coffee: ["app/**/*.coffee"]
  less: ["app/**/*.less", "!app/bower_components/**/*.less"]
  scripts: [".tmp/**/*.js"]
  styles: [".tmp/**/*.css"]
  bowerComponents: 'app/bower_components'
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
  cssSources = gulp.src(paths.styles, read: false).pipe order()
  gulp.src(paths.index)
    .pipe(inject(cssSources, relative: true))
    .pipe gulp.dest(paths.tmp)

gulp.task "inject:js", ->
  jsSources = gulp.src(paths.scripts, read: false).pipe order()
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
    root: ['.tmp', '.']
    port: 9002
    livereload: true

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
