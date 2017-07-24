// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require parsley
//= require parsley.i18n.es
//= require jquery_ujs
//= require bootstrap
//= require select2
//= require jquery-ui/widgets/sortable
//= require sidebar

var API_URL = '/api/v1/';
window.APP_MEDIAQUERY = {
    'desktopLG':             1200,
    'desktop':                992,
    'tablet':                 768,
    'mobile':                 480
  };

$(document).ready(function(){
  $('[data-tool="select2"]').select2({
    theme: 'bootstrap'
  });
});
