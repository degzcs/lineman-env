module.exports = (lineman) ->

#new file path
  files:
    coffee:
      app: ['generated/replaced/app.coffee', 'generated/replaced/**/*.coffee'] # order coffee compilation
      dist:
        generated: 'dist/js/app.coffee.js' # file that will  convert to js
        app: ['dist/replaced/app.coffee', 'dist/replaced/**/*.coffee'] # files to convert

    dist: js:
      concatenated:'dist/js/app.concated.js' #file to uglifly

# Cofiguration tasks
  config:
    coffee:
      compile:
        files: "<%= files.coffee.dist.generated %>": "<%= files.coffee.dist.app %>" # add compile coffee configuration

    concat_sourcemap:
      dist_js:
        src: [
          '<%= files.js.vendor %>'
          '<%= files.coffee.dist.generated %>'
          '<%= files.js.app %>'
          '<%= files.ngtemplates.dest %>'
        ]
        dest: "<%= files.dist.js.concatenated %>"

    ngAnnotate:
      js:
        src: "<%= files.dist.js.concatenated %>",
        dest: "<%= files.dist.js.concatenated %>"

    uglify:
      js:
        files: "<%= files.js.minified %>": "<%=  files.dist.js.concatenated %>" # add uglify js configuration

    loadNpmTasks: lineman.config.application.loadNpmTasks.concat("grunt-replace")

    prependTasks:
      common: ['replace:dev'].concat(lineman.config.application.prependTasks.common)
      dist: ['replace:dist', 'coffee:compile', 'concat_sourcemap:dist_js'].concat(lineman.config.application.prependTasks.dist)

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
