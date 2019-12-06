$(document).ready(function (){

	$('#paid').click(function(){

		$('#popup, #overlay').fadeIn(300);
		positionCenter( $('#popup') );
	});

	$('#paid1').click(function(){

		var checkedValues = $('input:checkbox:checked').map(function() {
		    return this.value;
		}).toArray().join();

		var svStatus = 2;

		$.ajax(updateURL("ajax.cfc?method=paidServices&returnFormat=JSON"), {
			cache: false,
		        data: {svIDs:checkedValues, svStatus:svStatus},
		        dataType: "json",
		        error: errorHandler,
		        success: success
		});
		//console.log(checkedValues);
	});

	$('#paid2').click(function(){

		var checkedValues = $('input:checkbox:checked').map(function() {
		    return this.value;
		}).toArray().join();

		var svStatus = 1;

		$.ajax(updateURL("ajax.cfc?method=paidServices&returnFormat=JSON"), {
			cache: false,
		        data: {svIDs:checkedValues, svStatus:svStatus},
		        dataType: "json",
		        error: errorHandler,
		        success: success
		});
		//console.log(checkedValues);
	});

	$('#popup_close').click(function(){
		$('#popup, #overlay').fadeOut(300);
	});
});

    function success(returnData, statusText, xhr , num ) {
	//console.log( returnData );
	//$('#overlay').css({opacity:0.5});
	//positionCenter( $('#popup') );

	if( returnData.RETVAL == 1 ){
	        // типа всё нормально
		$('#popup_mes').html("");
		$('#popup_mes').html( returnData.RETDESC );
		$('#popup, #overlay').fadeOut(2000);
		rp_id = $( "input[name='rp_id_']" ).map(function() {
		    return this.value;
		}).toArray().join();

		//console.log(rp_id);

		window.location = "/?page=reception&section=reception&action=view&rpid="+ rp_id;

	}else{
		$("#popup_mes").html("");
		$("#popup_mes").html( returnData.STRUCT.svIDs );
		//$('#popup, #overlay').fadeOut(2300);
	}
    }

    function errorHandler() {
	//console.log( returnData );
	//$('#overlay').css({opacity:0.5});
	//positionCenter( $('#pooup') );

	$("#popup_mes").html("");
	$("#popup_mes").html(returnData.RETVAL + returnData.RETDESC);
	$('#popup, #overlay').fadeIn(300);
    }

    function positionCenter(elem){
	elem.css({
		marginTop: '-' + elem.height() / 2 + 'px',
		marginLeft: '-' + elem.width() / 2 + 'px'
		});
    }