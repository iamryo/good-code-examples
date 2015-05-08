module.exports = function(grunt) {
  grunt.initConfig({
    svgstore: {
      options: {
        prefix : 'icon_',
        svg: {
          xmlns: 'http://www.w3.org/2000/svg',
          style: 'display: none;'
        },
        formatting: {
          indent_size: 2,
        },
      },
      default: {
        files: {
          'app/assets/images/svgs/_icon_definitions.html.erb': ['app/assets/images/svgs/*.svg'],
        },
      },
    },
  });

  grunt.loadNpmTasks('grunt-svgstore');
  grunt.registerTask('default', ['svgstore']);
}
