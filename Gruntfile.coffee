'use strict'

module.exports = (grunt) ->
    require('load-grunt-tasks')(grunt)
    require('time-grunt')(grunt)

    pkg = grunt.file.readJSON 'package.json'

    grunt.initConfig {
        clean: {
            dist: {
                files: 'dist/'
            }
        }
        less: {
            dist: {
                files: {
                    'dist/style.css': ['less/main.less']
                }
                options: {
                    sourceMap: true
                    sourceMapFilename: 'dist/style.css.map'
                }
            }
        }
        # cssmin: {
        #     dist: {
        #         files: {
        #             'dist/style.css': []
        #         }
        #     }
        # }
    }
    grunt.registerTask 'build', ['clean','less']
    grunt.registerTask 'default', ['build']