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
replace = require("gulp-replace-task")

allConfigs =
  localhost:
    index: [
      match: /<%- baseUrl %>/g
      replacement: "'http://localhost:3000/api'"
    ]
  production:
    index: [
      match: /<%- baseUrl %>/g
      replacement: "'http://data.genfengxue.com/api'"
    ]
    output: 'dist'

currentConfig = allConfigs.localhost

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
    .pipe replace(patterns: currentConfig.index)
    .pipe gulp.dest(paths.tmp)

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

###
#
# gulp build 部署的时候需要的task
#
###
gulp.task 'config:production', ->
  currentConfigs = allConfigs.production

gulp.task 'usemin', ->
  gulp.src paths.index
  .pipe usemin()
  .pipe gulp.dest(paths.tmp)

# 编译 angular html 模板
gulp.task 'templates:make', ->
  gulp.src paths.html
  .pipe angularTemplatecache(
    module: 'clarkApp'
    root: 'app/'
  )
  .pipe gulp.dest(paths.tmp)

# 模板文件 concat 到 app 文件中
gulp.task 'templates:concat', ->
  gulp.src [
    paths.tmp + "app.js"
    paths.tmp + "templates.js"
  ]
  .pipe concat('app.js')
  .pipe gulp.dest(paths.tmp)

# 备份 dist 目录到 dist_back
gulp.task 'backup', ->
  output = currentConfig.output ? 'dist'
  backup = output + '_backup'
  del backup, force: true, ->
    gulp.src [output + '/**/*.*']
      .pipe gulp.dest(backup)

# build 生成的代码拷贝到 dist 目录下
gulp.task 'output', ->
  output = currentConfig.output ? 'dist'
  del output, force: true, ->
    gulp.src [paths.tmp + '**/*.*']
      .pipe gulp.dest(output)


###
#
# 本地开放的时候run：gulp
#
###
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


###
#
# 在线部署的时候run：gulp build
# 生成的文件会在 dist 目录下; 代码在 gulp.task 'output' 的实现
# 原来的 dist 会备份到 dist_back 目录下; 代码在 gulp.task 'backup' 实现
#
###
gulp.task 'build', ->
  runSequence(
    'backup'
    'clean'
    'config:production'
    'index'
    'bower'
    'coffee'
    'inject:js'
    'less'
    'inject:css'
    'usemin'
    'templates:make'
    'templates:concat'
    'output'
  )
