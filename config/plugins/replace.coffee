module.exports = (lineman) ->

  files:
    coffee:
      app: ['generated/replaced/app.coffee', 'generated/replaced/**/*.coffee']

  config:
    loadNpmTasks: lineman.config.application.loadNpmTasks.concat("grunt-replace")

    prependTasks:
      common: ['replace:dev'].concat(lineman.config.application.prependTasks.common)
      dist: ['replace:dist'].concat(lineman.config.application.prependTasks.dist)

    # development
    replace:
      dev:
        options: patterns: [ {
          json: lineman.grunt.file.readJSON('config/environments/development.json')
        } ]
        files: [ {
          expand: true
          flatten: true
          src: [ 'app/js/**/*.*' ]
          dest: 'generated/replaced'
        } ]
    # production
      dist:
        options: patterns: [ {
          json: lineman.grunt.file.readJSON('config/environments/production.json')
        } ]
        files: [ {
          expand: true
          flatten: true
          src: [ 'app/js/**/*.*' ]
          dest: 'dist/replaced'
        } ]

