$(document).ready(function() { 

$.ajaxSetup({
  beforeSend: function(request){
	request.setRequestHeader('Accept', 'application/json');
	$("#mes").html("<img src='/img/ajax-loader.gif'>");
  }
});


$("#logInForm").validate({ 

	submitHandler: function(form) {

	var data = $("#logInForm").serialize(); // добавляет к урлу поля из формы
		$.ajax(updateURL("ajax.cfc?method=login&returnFormat=JSON"), {
		cache: false,
	        data: data,
	        dataType: "json",
	        error: errorHandler,
	        success: success
		});
	},

	rules: {
		username: {required: true, isallowsimbol: true, minlength:2, maxlength:20},
		password: {required: true, minlength:8, maxlength:20}
	},

	messages: {
		username: {
			required: "Поле обязательно для заполнения.",
			isallowsimbol: "Разрешены латинские буквы(<B>A-Z</B>), цифры(<B>0-9</B>), символ подчеркивания(<B>_</B>) и точка(.).",
			minlength: "Минимальная длина 2 символа.",
			maxlength: "Максимальная длина 20 символов."
		},

		password: {
			required: "Поле обязательно для заполнения.",
			minlength: "Минимальная длина 8 символов.",
			maxlength: "Максимальная длина 20 символов."
		}
   	}
});
return false;
}); 


    function success(returnData, statusText, xhr, $form) {
	if( returnData.RETVAL == 1 ){
		//alert(returnData.REDIR);
		window.location = returnData.REDIR;
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