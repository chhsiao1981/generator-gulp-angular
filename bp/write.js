(function(){
  var utils, files;
  utils = require('./utils');
  files = require('./files.json');
  /* Process files */
  module.exports = function(){
    var _, process, copy, this$ = this;
    _ = this._;
    process = function(content){
      return _.template(content.toString().replace(/\n<%/g, '<%'), this$);
    };
    copy = function(src, dest, processing){
      var error;
      dest = utils.replacePrefix(dest, this$.props.paths);
      console.log('to copy: src:', src, 'dest:', dest, 'processing:', processing);
      try {
        if (processing) {
          console.log('to do fs.copy with process: src:', src, 'dest:', dest, 'process:', process);
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
    _.forEach(this.staticFiles, function(dest, src){
      return copy(src, dest);
    });
    _.forEach(this.technologiesLogoCopies, function(src){
      return copy(src, src);
    });
    _.forEach(this.partialCopies, function(dest, src){
      return copy(src, dest);
    });
    _.forEach(this.styleCopies, function(dest, src){
      return copy(src, dest, true);
    });
    _.forEach(this.srcTemplates, function(dest, src){
      return copy(src, dest, true);
    });
    return _.forEach(this.lintConfCopies, function(src){
      return copy(src, src);
    });
  };
}).call(this);
