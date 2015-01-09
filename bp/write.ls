utils = require './utils'
files = require('./files.json');

/* Process files */
module.exports = ->
  _ = @_

  process = (content) ~>
    content-to-string = content.to-string!
    _.template (content.to-string!.replace /\n<%/g, '<%'), @
  
  copy = (src, dest, processing) ~>
    dest = utils.replace-prefix dest, @props.paths
    console.log 'to copy: src:', src, 'dest:', dest, 'processing:', processing
    try
      if processing
        console.log 'to do fs.copy with process: src:', src, 'dest:', dest, 'process:', process
        @fs.copy (@template-path src), (@destination-path dest), {process}
      else
        @fs.copy (@template-path src), (@destination-path dest)
    catch {error}
      console.error 'Template processing error on file: src:', src, 'dest:', dest, 'process:', process
      throw error

  _.for-each @static-files, (dest, src) ->
    copy src, dest

  _.for-each @technologies-logo-copies, (src) ->
    copy src, src

  _.for-each @partial-copies, (dest, src) ->
    copy src, dest

  _.for-each @style-copies, (dest, src) ->
    copy src, dest, true

  _.for-each @src-templates, (dest, src) ->
    copy src, dest, true

  _.for-each @lint-conf-copies, (src) ->
    copy src, src
