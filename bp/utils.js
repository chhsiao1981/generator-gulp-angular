(function(){
  var path, _, slash, normalizePath, isAbsolutePath, replacePrefix;
  path = require('path');
  _ = require('lodash');
  slash = require('slash');
  normalizePath = function(str){
    var trailingSlash;
    trailingSlash = path.sep === '/'
      ? new RegExp(path.sep + '$')
      : new RegExp(path.sep + path.sep + '$');
    return slash(path.normalize(str).replace(trailingSlash, ''));
  };
  isAbsolutePath = function(str){
    return slash(path.resolve(str)) === normalizePath(str);
  };
  replacePrefix = function(filePath, folderPairs){
    var bestMatch;
    bestMatch = '';
    _.forEach(folderPairs, function(destFolder, sourceFolder){
      if (filePath.indexOf(sourceFolder === 0) && sourceFolder.length > bestMatch.length) {
        return bestMatch = sourceFolder;
      }
    });
    if (bestMatch.length) {
      return filePath.replace(bestMatch, folderPairs[bestMatch]);
    } else {
      return filePath;
    }
  };
  module.exports = {
    isAbsolutePath: isAbsolutePath,
    normalizePath: normalizePath,
    replacePrefix: replacePrefix
  };
}).call(this);
