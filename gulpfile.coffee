_ = require 'underscore'
gulp = require 'gulp'
jade = require 'gulp-jade'
stylus = require 'gulp-stylus'
rename = require 'gulp-rename'
uglify = require 'gulp-uglify'
browserSync = require 'browser-sync'
plumber = require 'gulp-plumber'
coffee = require 'gulp-coffee'

expand = (ext)-> rename (path) -> _.tap path, (p) -> p.extname = ".#{ext}"

DEST = "./dist"
SRC = "./src"

# ファイルタイプごとに無視するファイルなどを設定
paths =
  js: ["#{SRC}/**/*.coffee", "!#{SRC}/**/_**/*.coffee", "!#{SRC}/**/_*.coffee"]
  css: ["#{SRC}/**/*.styl", "!#{SRC}/**/sprite*.styl", "!#{SRC}/**/_**/*.styl", "!#{SRC}/**/_*.styl"]
  html: ["#{SRC}/**/*.jade", "!#{SRC}/**/_**/*.jade", "!#{SRC}/**/_*.jade"]
  reload: ["#{DEST}/**/*", "!#{DEST}/**/*.css"]

gulp.task 'coffee', ->
  gulp.src paths.js
    .pipe coffee bare: true
    .pipe gulp.dest DEST

# FW for Stylus
nib = require 'nib'

gulp.task "stylus", ->
  gulp.src paths.css
    .pipe plumber()
    .pipe stylus use: nib(), errors: true
    .pipe expand "css"
    .pipe gulp.dest DEST
    .pipe browserSync.reload stream:true
  return

gulp.task "jade", ->
  gulp.src paths.html
    .pipe plumber()
    .pipe jade pretty: true
    .pipe expand "html"
    .pipe gulp.dest DEST

gulp.task "browser-sync", ->
  browserSync.init null,
    reloadDelay:2000,
    #startPath: 'a.html'
    server: baseDir: DEST

gulp.task 'watch', ->
    gulp.watch [paths.js[0], "#{SRC}/**/_*/*"], ['coffee']
    gulp.watch paths.css  , ['stylus']
    gulp.watch paths.html , ['jade']
    gulp.watch paths.reload, -> browserSync.reload once: true

#gulp.task "default", ['jade', 'stylus', 'browserify', 'browser-sync', 'watch'] 
gulp.task "default", ['jade', 'stylus', 'watch', 'browser-sync'] 
gulp.task "build", ['imagemin', 'stylus', 'jade']
