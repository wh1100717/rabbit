module.exports = (grunt) ->
    'use strict'

    grunt.initConfig {
        pkg: grunt.file.readJSON('package.json')
        banner: """
        /*
         * <%= pkg.name %>
         * Copyright <%= grunt.template.today("yyyy-mm-dd") %> <%= pkg.author %>
         */
        """
        bower_conf: {
            directory: 'bower_components'
        }
        clean: {
            dist: ['dist']
        }
        concat: {
            options: {
                banner: '<%= banner %>'
                stripBanners: false
            }
            dist: {
                src: [
                    'js/*.js'
                ]
                dest: 'dist/js/<%= pkg.name %>.js'
            }
        }
        uglify: {
            options: {
                preserveComments: 'some'
            }
            dist: {
                src: '<%= concat.dist.dest %>'
                dest: 'dist/js/<%= pkg.name %>.min.js'
            }
        }
        less: {
            compileCore: {
                options: {
                    strictMath: true,
                    sourceMap: true,
                    outputSourceFiles: true,
                    sourceMapURL: '<%= pkg.name %>.css.map'
                    sourceMapFilename: 'dist/css/<%= pkg.name %>.css.map'
                }
                files: {
                    'dist/css/<%= pkg.name %>.css': 'less/<%= pkg.name %>.less'
                }
            }
        }
        csscomb: {
            options: {
                config: 'less/.csscomb.json'
            }
            dist: {
                files: {
                    'dist/css/<%= pkg.name %>.css': 'dist/css/<%= pkg.name %>.css'
                }
            }
        }
        cssmin: {
            options: {
                keepSpecialComments: '*'
                noAdvanced: true
            }
            core: {
                files: {
                    'dist/css/<%= pkg.name %>.min.css': 'dist/css/<%= pkg.name %>.css'
                }
            }
        }
        usebanner: {
            dist: {
                options: {
                    position: 'top'
                    banner: '<%= banner %>'
                }
                files: {
                    src: [
                        'dist/css/<%= pkg.name %>.css'
                        'dist/css/<%= pkg.name %>.min.css'
                    ]
                }
            }
        }
        copy: {
            dist: {
                expand: true
                src: [
                    'fonts/**'
                    'img/**'
                ]
                dest: 'dist/'
            }
            distVendorCSS: {
                expand: true
                flatten: true
                cwd: '<%= bower_conf.directory %>'
                src: [
                  'bootstrap/dist/css/bootstrap.min.css'
                ]
                dest: 'dist/css/vendor/'
            }
        }
        connect: {
            options: {
                port: 9007
                livereload: 42201
                hostname: 'localhost'
                base: '.'
            },
            livereload: {
                options: {
                    open: true
                }
            }
        }
        watch: {
            less: {
                files: 'less/**/*.less'
                tasks: ['less', 'autoprefixer']
            }
            livereload: {
                options: {
                    livereload: '<%= connect.options.livereload %>'
                }
                files: ['{,*/}*.html', '{docs,dist}/**/css/{,*/}*.css', '{docs,dist}/**/js/{,*/}*.js']
            }
        }
    }


    require('load-grunt-tasks')(grunt, { scope: 'devDependencies' })
    require('time-grunt')(grunt)

    grunt.registerTask 'build-js', ['concat', 'uglify']
    grunt.registerTask 'build-css', ['less', 'usebanner', 'csscomb', 'cssmin']
    grunt.registerTask 'build-copy', ['copy:dist', 'copy:distVendorCSS']
    grunt.registerTask 'build', ['clean', 'build-js', 'build-css', 'build-copy']
    grunt.registerTask 'server', ['less', 'connect:livereload', 'watch']
    grunt.registerTask 'serve', ['server']
    grunt.registerTask 'default', ['server']


















