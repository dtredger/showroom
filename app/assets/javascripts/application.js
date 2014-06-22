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
//= require jquery.ui.all
//= require turbolinks
$(function(){ $(document).foundation(); });

// For the price-range slider
$( document ).ready(function() {
	$("#custom-slider-range").slider({
	  range: true,
	  min: 0,
	  max: 1000,
	  values: [ 0, 1000 ],
	  slide: function( event, ui ) {
	  	// Add a + sign if the amount is 1000, which is the maximum value
	  	if(ui.values[1] == 1000) {
	  		$( "#amount" ).val( "$" + ui.values[ 0 ] + " - $" + ui.values[ 1 ] + "+" );
	  		// Set the hidden values on the Rails form
	  		$('#min_price').val(ui.values[0]);
	  	} else {
	  		$( "#amount" ).val( "$" + ui.values[ 0 ] + " - $" + ui.values[ 1 ] );
	  		// Set the hidden values on the Rails form
	  		$('#max_price').val(ui.values[1]);
	  	}
	  }
	});
});