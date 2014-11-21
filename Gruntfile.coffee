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
                    '<%= bower_conf.directory %>/jquery-ui/ui/jquery.ui.core.js'
                    '<%= bower_conf.directory %>/jquery-ui/ui/jquery.ui.widget.js'
                    '<%= bower_conf.directory %>/jquery-ui/ui/jquery.ui.mouse.js'
                    '<%= bower_conf.directory %>/jquery-ui/ui/jquery.ui.position.js'
                    '<%= bower_conf.directory %>/jquery-ui/ui/jquery.ui.button.js'
                    '<%= bower_conf.directory %>/jquery-ui/ui/jquery.ui.slider.js'
                    '<%= bower_conf.directory %>/jquery-ui/ui/jquery.ui.effect.js'
                    '<%= bower_conf.directory %>/jquery-ui-touch-punch/jquery.ui.touch-punch.js'
                    '<%= bower_conf.directory %>/bootstrap-switch/dist/js/bootstrap-switch.js'
                    '<%= bower_conf.directory %>/bootstrap-tagsinput/dist/bootstrap-tagsinput.js'
                    '<%= bower_conf.directory %>/holderjs/holder.js'
                    '<%= bower_conf.directory %>/typeahead.js/dist/typeahead.bundle.js'
                    '<%= bower_conf.directory %>/videojs/dist/video-js/video.js'
                    '<%= bower_conf.directory %>/select2/select2.js'
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
            distVenodrJS: {
                expand: true
                flatten: true
                cwd: './bower_components'
                src: [
                    'jquery/dist/jquery.min.js'
                    'jquery/dist/jquery.min.map'
                    'bootstrap/dist/js/bootstrap.min.js'
                ]
                dest: 'dist/js/vendor/'
            }
            distVendorCSS: {
                expand: true
                flatten: true
                cwd: './bower_components'
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
                tasks: ['less']
            }
            livereload: {
                options: {
                    livereload: '<%= connect.options.livereload %>'
                }
                files: ['{,*/}*.html', '{assets,dist}/**/css/{,*/}*.css', '{assets,dist}/**/js/{,*/}*.js']
            }
        }
    }


    require('load-grunt-tasks')(grunt, { scope: 'devDependencies' })
    require('time-grunt')(grunt)

    grunt.registerTask 'build-js', ['concat', 'uglify']
    grunt.registerTask 'build-css', ['less', 'usebanner', 'csscomb', 'cssmin']
    grunt.registerTask 'build-copy', ['copy:dist', 'copy:distVenodrJS', 'copy:distVendorCSS']
    grunt.registerTask 'build', ['clean', 'build-js', 'build-css', 'build-copy']
    grunt.registerTask 'server', ['less', 'connect:livereload', 'watch']
    grunt.registerTask 'serve', ['server']
    grunt.registerTask 'default', ['server']


















