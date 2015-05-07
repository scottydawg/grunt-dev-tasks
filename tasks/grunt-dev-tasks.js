(function() {
  var fs, path;

  fs = require('fs');

  path = require('path');

  module.exports = function(grunt) {
    var getStubSourcePackage;
    getStubSourcePackage = function(options) {
      var ref, sourceJSON;
      if (options.target.substr(-12) === 'package.json') {
        sourceJSON = require(path.join(process.cwd(), options.target));
        return sourceJSON;
      } else {
        return {
          name: options.name,
          version: (ref = options.version) != null ? ref : '0.0.0',
          main: options.target
        };
      }
    };
    return grunt.registerMultiTask('createStubModule', 'Add a stub module to the node_modules directory that points to a generated target', function() {
      var mainPath, options, packageJSON, stubPath, stubSource;
      grunt.log.subhead('Creating stub module...');
      options = this.options();
      stubSource = getStubSourcePackage(options);
      if (stubSource.name == null) {
        grunt.fail.fatal("Could not write unnamed stub module for target " + options.target);
        return;
      }
      stubPath = "./node_modules/" + stubSource.name;
      if (fs.existsSync(stubPath)) {
        grunt.log.ok("module directory already exists at " + stubPath);
        return;
      }
      fs.mkdirSync(stubPath);
      grunt.log.ok("module directory created at " + stubPath);
      mainPath = path.relative(stubPath, stubSource.main);
      grunt.log.writeln("stub module's 'main' path targets " + mainPath);
      packageJSON = {
        name: stubSource.name,
        version: stubSource.version,
        'private': true,
        main: mainPath,
        description: "Stub " + stubSource.name + " package"
      };
      return fs.writeFileSync(stubPath + "/package.json", JSON.stringify(packageJSON, null, 2));
    });
  };

}).call(this);
