
module.exports = (grunt) ->

  grunt.initConfig

    clean:
      build: ['.tmp', 'node_modules/stub-test']

    createStubModule:
      tasksLib:
        options:
          target: 'package.json'
      tasksFile:
        options:
          target: 'tasks/grunt-dev-tasks.js'
          name: 'dev-tasks'
          version: '0.0.1'

    coffee:
      tasks:
        options:
          join: true
        files:
          'tasks/grunt-dev-tasks.js': ['src/**/*.coffee']

      test:
        options:
          bare: true
        expand: true
        src: ['spec/**/*.spec.coffee']
        dest: '.tmp'
        ext: '.spec.js'

    jasmine_node:
      projectRoot: './.tmp',
      requirejs: false,
      forceExit: true

  grunt.loadTasks('tasks')
  grunt.loadNpmTasks('grunt-contrib-clean')
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-jasmine-node')

  grunt.registerTask('test', ['jasmine_node'])
  grunt.registerTask('compile', ['coffee'])
  grunt.registerTask('build', ['clean', 'compile'])
  grunt.registerTask('default', ['build'])
