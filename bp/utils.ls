path = require 'path'
_ = require 'lodash'
slash = require 'slash'

# Turn str into simplest form, remove trailing slash
# example: 
# './path/to//some/folder/' (unix) will be normalized to 'path/to/some/folder' 
# 'path\\to\\some\\folder\\' (windows) will be normalized to 'path/to/some/folder'
# @param  {String} str, can be unix style path ('/') or windows style path ('\\')
# @return {String} normalized unix style path

normalize-path = (str) ->
  trailing-slash = if path.sep == '/' then new RegExp path.sep + '$' else new RegExp path.sep + path.sep + '$'
  slash (path.normalize str .replace trailing-slash, '')

# Check if string is absolute path
# @param  {String} str, can be unix style path ('/') or windows style path ('\\')
# @return {Boolean} true if string is absolute path

is-absolute-path = (str) ->
  (slash path.resolve str) == (normalize-path str)

# Replace sourceFolder with destFolder in filePath
# if filePath has any sourceFolder as prefix
# choose longest match if there are multiple prefixes that match
# @param  {String} filePath    File path to be altered
# @param  {Object} folderPairs Hash of pairs of sourceFolder:destFolder
#                              Similar to what stored in this.props.paths
# @return {String}             new file path

replace-prefix = (file-path, folder-pairs) ->
  best-match = ''
  _.for-each folder-pairs, (dest-folder, source-folder) ->
    if file-path.index-of source-folder == 0 and source-folder.length > best-match.length
      best-match := source-folder

  if best-match.length then file-path.replace best-match, folder-pairs[best-match] else file-path

module.exports = do
  is-absolute-path: is-absolute-path
  normalize-path: normalize-path
  replace-prefix: replace-prefix
