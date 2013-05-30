module.exports = function(grunt) {
    grunt.initConfig({
        pkg: grunt.file.readJSON("package.json"),
        connect: {
            test: {
                port: 3000
            }
        },
        jasmine: {
            src: ['models/**/*.coffee'],
            options: {
                specs: ['test/**/*Spec.coffee'],
                host: "http://localhost:3000",
                template: require('grunt-template-jasmine-requirejs'),
                templateOptions: {
                          requireConfig: {
                            baseUrl: '/Users/austinmullins/plc_check',
                            paths: {
                              "mongoose": "node_modules/mongoose/lib/mongoose"
                            },

                            deps: ['mongoose']
                        }
                }
            }
        },
        watch: {
            tests: {
                files: ["<%= jasmine.src %>", "<%= jasmine.options.specs %>"],
                tasks: ["jasmine"]
            }
        }
    });

    grunt.loadNpmTasks("grunt-contrib-jasmine");
    grunt.loadNpmTasks("grunt-contrib-watch");
    grunt.loadNpmTasks("grunt-contrib-connect");


    grunt.registerTask("default", ["watch"]);

};