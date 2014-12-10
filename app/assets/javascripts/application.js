// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require foundation

$(function() {
  $(document).foundation({
      reveal: {
//          animation: 'fade',
//          animation_speed: 5000,
          close_on_background_click: true
      },
      orbit: {
          timer_speed: 2000,
          pause_on_hover: true // Pauses on the current slide while hovering
      }
  });
});

//= require turbolinks