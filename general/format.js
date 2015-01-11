(function(){
  var path, fs, format;
  path = require('path');
  fs = require('fs');
  format = function(){
    var _, paths, resolvePaths;
    _ = this._;
    paths = this.props.paths;
    resolvePaths = function(template){
      return function(filesObject, file){
        var src, dest, basename, preprocessorFile;
        src = file;
        dest = file;
        if (template) {
          basename = path.basename(file);
          src = file.replace(basename, '_' + basename);
        }
        if (src.match(/\.js$/)) {
          preprocessorFile = this.sourceRoot() + '/' + src.replace(/\.js$/, '.' + this.props.jsPreprocessor.srcExtension);
          if (fs.existsSync(preprocessorFile)) {
            src = src.replace(/\.js$/, '.' + this.props.jsPreprocessor.srcExtension);
            dest = dest.replace(/\.js$/, '.' + this.props.jsPreprocessor.extension);
          }
        }
        filesObject[src] = paths.src + '/' + dest;
        return filesObject;
      };
    };
    return this.srcFiles = this.srcFiles.reduce(resolvePaths(true).bind(this), {});
  };
  module.exports = format;
}).call(this);
