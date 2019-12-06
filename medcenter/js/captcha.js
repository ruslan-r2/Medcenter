 $( function() {

    $("#captcha").submit(function(){
      //var data = { method: "login", Username: "user", Password: "Qtx75uN3", returnFormat: "JSON"};
	var data = $("#captcha").serialize(); // добавляет к урлу поля из формы
      $.ajax( updateURL("ajax.cfc?method=checkCaptcha&returnFormat=json"), {
	cache: false,
        data: data,
        dataType: "json",
        error: errorHandler,
        success: success
      } );
	return false; // на возвращать false чтобы не перезагружалась страница
    } );

    function success( returnData, statusText, xhr, $form ) {
      //var forecast = forecastData.LOGGEDIN + forecastData.MESSAGE;
      //alert( returnData );
	if( returnData == 1 ){
		//$("#mes").html("");
		//$("#mes").html(returnData.RETDESC);
		window.location = 'http://localhost/';
		// пока кидаем на главную потом можно еще и параметр редир передавать иначе никак.
	}else{
		$("#mes").html("");
		$("#mes").html(returnData.RETDESC);
	}
    }
    function errorHandler() {
	$("#mes").html(returnData.RETVAL + returnData.RETDESC);
      //alert( "Есть проблемы с получением прогноза. Наверно, Васюки смыло в море." );
    }


  } );