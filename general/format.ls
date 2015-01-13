path = require 'path'
fs = require 'fs'

format = ->
  _ = @_
  paths = @props.paths

  resolve-paths = (template) ~>
    (files-object, file) ~>
      src = file
      dest = @dirname + '/' + @basename + '-' + file

      if template
        basename = path.basename file
        src = file.replace basename, '_' + basename

      if src.match /\.js$/
        preprocessor-file = @source-root! + '/' + src.replace /\.js$/, '.' + @props.js-preprocessor.src-extension

        if fs.exists-sync preprocessor-file
          src = src.replace /\.js$/, '.' + @props.js-preprocessor.src-extension
          dest = dest.replace /\.js$/, '.' + @props.js-preprocessor.extension

      console.log 'src:', src, 'dest:', paths.src + '/' + dest

      src-dir = paths.src + if @class-name in <[ controller section module ]> then '' else '/components'
      console.log 'src-dir:', src-dir

      files-object[src] = src-dir + '/' + dest

      files-object

  @src-files = @src-files.reduce (resolve-paths true .bind @), {}
  
module.exports = format
