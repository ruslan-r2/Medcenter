$(document).ready(function (){

	$('input[type=button]').click(function(){
		var id = $(this).attr('id');
		var pattern = /TextInsert_[0-9]{1,2}/;

		if ( id.search(pattern,id) == 0 ){
			var pattern1 = /[0-9]{1,2}/;
			var result = id.match(pattern1,id);
			var num = result[0];
			var _text = $('#TextSelect_'+num).val();
			$('#OutPut_'+num).val($('#OutPut_'+num).val()+_text);
			//console.log( result[0] );
		}

		var pattern2 = /addKey_[0-9]{1,2}/;
		if ( id.search(pattern2,id) == 0 ){
			var pattern1 = /[0-9]{1,2}/;
			var result = id.match(pattern1,id);
			var num = result[0];
			var phrase = $('#phraseKey_'+num).val();
			var userid = $('#userid').val();
			var phKey = $('#phKey_'+num).val();
			//console.log( result[0] );
			//console.log( phrase );
			//console.log( phKey );

			$.ajax(updateURL("ajax.cfc?method=addPhrase&returnFormat=JSON"), {
				cache: false,
			        data: {phrase:phrase,userid:userid,phKey:phKey,num:num},
			        dataType: "json",
			        error: errorHandler,
			        success: success
			});

		}

		var pattern3 = /deleteKey_[0-9]{1,2}/;
		if ( id.search(pattern3,id) == 0 ){
			var pattern1 = /[0-9]{1,2}/;
			var result = id.match(pattern1,id);
			var num = result[0];
			//var phrase = $('#phraseKey_'+num).val();
			var phrase = $('#TextSelect_'+num+' option:selected').val()
			var userid = $('#userid').val();
			var phKey = $('#phKey_'+num).val();
			//console.log( result[0] );
			//console.log( phrase );
			//console.log( phKey );

			$.ajax(updateURL("ajax.cfc?method=deletePhrase&returnFormat=JSON"), {
				cache: false,
			        //data: 'phrase='+phrase+'&userid='+userid+'&phKey='+phKey+'&num='+num,
				data: {phrase: phrase, userid: userid, phKey: phKey, num: num},
			        dataType: "json",
			        error: errorHandler,
			        success: success1
			});

		}

		//console.log( id );
		//console.log( id.search(pattern,id) );
	});

	$('#popup_close').click(function(){
		$('#popup, #overlay').fadeOut(300);
	});
});

    function success(returnData, statusText, xhr , num ) {
	console.log( returnData );
	$('#overlay').css({opacity:0.5});
	positionCenter( $('#popup') );

	if( returnData.RETVAL == 1 ){
	        // типа всё нормально
		$('#popup_mes').html("");
		$('#popup_mes').html( returnData.RETDESC );
		$('#popup, #overlay').fadeIn(300);

		$("#TextSelect_"+returnData.num).append("<option title='"+ returnData.phrase +"' value='"+ returnData.phrase +"'>"+ returnData.phrase +"</option>");

	}else{
		$("#popup_mes").html("");
		if ( returnData.STRUCT.RBAC != 'undefined'){
			$("#popup_mes").html( returnData.STRUCT.RBAC);
		}
		if ( returnData.STRUCT.phValue != 'undefined'){
			$("#popup_mes").html( returnData.STRUCT.phValue);
		}
		$('#popup, #overlay').fadeIn(300);
	}
    }

    function errorHandler() {
	$('#overlay').css({opacity:0.5});
	positionCenter( $('#pooup') );

	$("#popup_mes").html("");
	$("#popup_mes").html(returnData.RETVAL + returnData.RETDESC);
	$('#popup, #overlay').fadeIn(300);
    }

    function success1(returnData, statusText, xhr , num ) {
	console.log( returnData );
	$('#overlay').css({opacity:0.5});
	positionCenter( $('#popup') );

	if( returnData.RETVAL == 1 ){
	        // типа всё нормально
		$('#popup_mes').html("");
		$('#popup_mes').html( returnData.RETDESC );
		$('#popup, #overlay').fadeIn(300);

		$('#TextSelect_'+returnData.num+' option:selected').remove();

	}else{

		$("#popup_mes").html("");
		if ( returnData.STRUCT.RBAC != 'undefined'){
			$("#popup_mes").html( returnData.STRUCT.RBAC);
		}
		if ( returnData.STRUCT.phValue != 'undefined'){
			$("#popup_mes").html( returnData.STRUCT.phValue);
		}
		$('#popup, #overlay').fadeIn(300);
	}
    }

    function positionCenter(elem){
	elem.css({
		marginTop: '-' + elem.height() / 2 + 'px',
		marginLeft: '-' + elem.width() / 2 + 'px'
		});
    }