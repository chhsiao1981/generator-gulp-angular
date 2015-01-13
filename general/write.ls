utils = require '../bp/utils'

write = ->
  _ = @_

  process = (content) ~>
    console.log 'content:', content.to-string!, 'section:', @section, 'class:', @class
    content-to-string = content.to-string!.replace /\n<%/g, '<%'

    result = _.template content-to-string, @
    console.log 'result:', result
    result

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
