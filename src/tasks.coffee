fs = require('fs')
path = require('path')

module.exports = (grunt) ->

  grunt.registerMultiTask 'createStubModule', 'Add a stub module to the node_modules directory that points to a generated target', ->
    grunt.log.subhead('Creating stub module...')

    options = @options()
    sourceJSON = require(path.join(process.cwd(), options.target))
    stubPath = "./node_modules/#{sourceJSON.name}"

    if fs.existsSync(stubPath)
      grunt.log.ok("module directory already exists at #{stubPath}")
      return

    fs.mkdirSync(stubPath)
    grunt.log.ok("module directory created at #{stubPath}")

    mainPath = path.relative(stubPath, options.target)
    grunt.log.writeln("stub module's 'main' path targets #{mainPath}")

    packageJSON =
      name: sourceJSON.name
      version: sourceJSON.version
      'private': true
      main: mainPath
      description: "Stub #{sourceJSON.name} package"

    fs.writeFileSync("#{stubPath}/package.json", JSON.stringify(packageJSON, null, 2))
