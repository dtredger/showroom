
// For the price-range slider
$( document ).ready(function() {
	alert('hello');
	$("#custom-slider-range").slider({
	  range: true,
	  min: 0,
	  max: 1000,
	  values: [ 0, 1000 ],
	  slide: function( event, ui ) {
	  	// Add a + sign if the amount is 1000, which is the maximum value
	  	if(ui.values[1] == 1000) {
	  		//$( "#amount" ).val( "$" + ui.values[ 0 ] + " - $" + ui.values[ 1 ] + "+" );
	  		// Set the hidden values on the Rails form
	  	} else {
	  		//$( "#amount" ).val( "$" + ui.values[ 0 ] + " - $" + ui.values[ 1 ] );
	  		// Set the hidden values on the Rails form
	  	}
	  }
	});
});