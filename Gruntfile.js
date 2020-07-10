'use strict';
module.exports = function(grunt) {

  grunt.initConfig({
    imagemin: {
      dist: {
        options: {
          optimizationLevel: 5,
          progressive: true
        },
        files: [{
          expand: true,
          cwd: 'assets/images/',
          src: '{,*/}*.{png,jpg,jpeg}',
          dest: 'assets/images/'
        }]
      }
    },
    svgmin: {
      dist: {
        files: [{
          expand: true,
          cwd: 'assets/images/',
          src: '{,*/}*.svg',
          dest: 'assets/images/'
        }]
      }
    }
  });

  // Load tasks
  grunt.loadNpmTasks('grunt-contrib-imagemin');
  grunt.loadNpmTasks('grunt-svgmin');

  // Register tasks
  grunt.registerTask('default', [
    'imagemin',
    'svgmin'
  ]);
};
