(function(){
  var path, fs, format;
  path = require('path');
  fs = require('fs');
  format = function(){
    var _, paths, resolvePaths, this$ = this;
    _ = this._;
    paths = this.props.paths;
    resolvePaths = function(template){
      return function(filesObject, file){
        var src, dest, basename, preprocessorFile, srcDir, ref$;
        src = file;
        dest = this$.dirname + '/' + this$.basename + '-' + file;
        if (template) {
          basename = path.basename(file);
          src = file.replace(basename, '_' + basename);
        }
        if (src.match(/\.js$/)) {
          preprocessorFile = this$.sourceRoot() + '/' + src.replace(/\.js$/, '.' + this$.props.jsPreprocessor.srcExtension);
          if (fs.existsSync(preprocessorFile)) {
            src = src.replace(/\.js$/, '.' + this$.props.jsPreprocessor.srcExtension);
            dest = dest.replace(/\.js$/, '.' + this$.props.jsPreprocessor.extension);
          }
        }
        console.log('src:', src, 'dest:', paths.src + '/' + dest);
        srcDir = paths.src + ((ref$ = this$.className) === 'controller' || ref$ === 'section' || ref$ === 'module' ? '' : '/components');
        console.log('src-dir:', srcDir);
        filesObject[src] = srcDir + '/' + dest;
        return filesObject;
      };
    };
    return this.srcFiles = this.srcFiles.reduce(resolvePaths(true).bind(this), {});
  };
  module.exports = format;
}).call(this);
