utils = require '../bp/utils'

write = ->
  _ = @_

  process = (content) ~>
    _.template (content.to-string!.replace /\n<%/g, '<%'), @

  copy = (src, dest, processing) ~>
    dest = utils.replace-prefix dest, @props.paths
    try
      if processing
        @fs.copy (@template-path src), (@destination-path dest), {process}
      else
        @fs.copy (@template-path src), (@destination-path dest)
    catch {error}
      console.error 'Template processing error on file: src:', src, 'dest:', dest, 'process:', process
      throw error

  _.for-each @src-files, (dest, src) ->
    copy src, dest, true

module.exports = write
