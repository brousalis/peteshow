/* globals module */
module.exports = function(grunt) {

  // Project configuration
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),

    connect: {
      server: {
        options: {
          keepalive: true,
          port: 3000
        }
      }
    },

    meta: {
      depFiles : [
        'vendor/faker.js',
        'vendor/jquery.formatdatetime.js',
        'vendor/jquery.cookie.js'
      ],

      srcFiles : [
        'src/peteshow.js',
        'src/peteshow-helpers.js',
        'src/peteshow-storage.js',
        'src/peteshow-core.js'
      ]
    },

    concat: {
      options: {
        separator: '\n'
      },
      dist: {
        src: [
          '<%= meta.depFiles %>',
          '<%= meta.srcFiles %>'
        ],
        dest: 'dist/<%= pkg.name %>.js'
      }
    },

    cssmin: {
      min_peteshow_css: {
        src: 'src/css/peteshow.css', dest: 'dist/peteshow.css',
      }
    },

    clean: {
      dist: ['dist/*'],
      rails: ['lib/assets/javascripts/*', 'lib/assets/stylesheets/*']
    },

    copy: {
      dist: {
        files: [
          { cwd: 'dist', src: 'peteshow.js', dest: 'lib/assets/javascripts', expand: true, flatten: true, filter: 'isFile' },
          { cwd: 'dist', src: 'peteshow.min.js', dest: 'lib/assets/javascripts', expand: true, flatten: true, filter: 'isFile' },
          { cwd: 'dist', src: 'peteshow.css', dest: 'lib/assets/stylesheets', expand: true, flatten: true, filter: 'isFile' }
        ]
      }
    },

    uglify: {
      options: {
        banner: '/**\n' +
                ' * ' + 'Peteshow - <%= pkg.homepage %>\n' +
                ' * ' + '<%= pkg.author.name %> @brousalis\n' +
                ' * ' + 'v<%= pkg.version %>\n' +
                ' **/\n'
      },

      my_target: {
        files: {
          'dist/peteshow.min.js': ['dist/peteshow.js']
        }
      }
    },

    qunit: {
      all: ['tests/index.html']
    }
  });

  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-connect');
  grunt.loadNpmTasks('grunt-contrib-cssmin');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-contrib-qunit');

  grunt.registerTask('default', ['qunit', 'concat', 'uglify', 'cssmin', 'copy']);
  grunt.registerTask('test', 'qunit');
};
