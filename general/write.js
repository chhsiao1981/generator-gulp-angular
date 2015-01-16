(function(){
  var utils, write;
  utils = require('../bp/utils');
  write = function(){
    var _, process, copy, this$ = this;
    _ = this._;
    process = function(content){
      var contentToString, result;
      contentToString = content.toString().replace(/\n<%/g, '<%');
      result = _.template(contentToString, this$);
      return result;
    };
    copy = function(src, dest, processing){
      var error;
      dest = utils.replacePrefix(dest, this$.props.paths);
      try {
        if (processing) {
          return this$.fs.copy(this$.templatePath(src), this$.destinationPath(dest), {
            process: process
          });
        } else {
          return this$.fs.copy(this$.templatePath(src), this$.destinationPath(dest));
        }
      } catch (e$) {
        error = e$.error;
        console.error('Template processing error on file: src:', src, 'dest:', dest, 'process:', process);
        throw error;
      }
    };
    return _.forEach(this.srcFiles, function(dest, src){
      return copy(src, dest, true);
    });
  };
  module.exports = write;
}).call(this);
