$(document).ready(function() { 

$.ajaxSetup({
  beforeSend: function(request){
	request.setRequestHeader('Accept', 'application/json');
	$("#mes").show();
	$("#mes").html("<img src='/img/ajax-loader.gif'>");
	//$("#mes").hide();
  },
  complete: function() {
  	$("#mes").fadeOut(1000);
	return false;
  }
});

$("#registration").validate({ 
	debug: true,
	submitHandler: function(form) {
	// bind form using 'ajaxForm' 
	//$('#logInForm').ajaxSubmit(options);
	//var data = { method: "login", Username: "user", Password: "Qtx75uN3", returnFormat: "JSON"};
	var data = $("#registration").serialize(); // добавляет к урлу поля из формы
		$.ajax( updateURL("ajax.cfc?method=registration&returnFormat=json"), {
		cache: false,
	        data: data,
	        dataType: "json",
	        error: errorHandler,
	        success: success
		});
	},

	rules: {
		// к каждому ajax запросу нужно добавлять CFID и CFTOKE чтобы не множить новые сессии
		username: {required: true, isallowsimbol: true, minlength:2, maxlength:20, remote: updateURL("ajax.cfc?method=checkUserName&returnFormat=json")},
		password: {required: true, isValidPassword: true, minlength:8, maxlength:20},
		password1: {required: true, equalTo: '#password' },
		mail: 	{ email:true, maxlength:35, remote: updateURL("ajax.cfc?method=checkEmail&returnFormat=json") },
		tel_mob: { isTelMob:true, maxlength:10, remote: updateURL("ajax.cfc?method=checkTelMob&returnFormat=json")},
		captcha: { required: true, minlength:6,
			remote: {
			        url: updateURL("ajax.cfc?method=checkCaptcha&returnFormat=json"),
			        type: "post",
		        	data: {
			          UUID: function() {
			            return $("#UUID").val();
			          }
		        	}
			      }
		}

	},

	messages: {
		username: {
			required: "Поле обязательно для заполнения. ",
			isallowsimbol: "Разрешены латинские буквы(<B>A-Z</B>), цифры(<B>0-9</B>), символ подчеркивания(<B>_</B>) и точка(.). ",
			minlength: "Минимальная длина 2 символа. ",
			maxlength: "Максимальная длина 20 символов. ",
			remote: "Логин уже зарегистрирован другим пользователем. "
		},
		password: {
			required: "Поле обязательно для заполнения. ",
			isValidPassword: "Cлабый пароль. Пароль должен содержать одну заглавную букву, одну строчную букву и цифру. ",
			minlength: "Минимальная длина 8 символов. ",
			maxlength: "Максимальная длина 20 символов. "
		},
		password1: {
			required: "Поле обязательно для заполнения. ",
			equalTo: "Пароли не совпадают. "
		},
		mail: {
			email: "Укажите действительный E-mail адрес. ",
			maxlength: "Максимальная длина 35 символов. ",
			remote: "E-mail адрес уже зарегистрирован другим пользователем. "
		},
		tel_mob: {
			isTelMob: "Разрешены только цифры. Длина 10 цифр и начинается с цифры 9. ",
			maxlength: "Максимальная длина 35 символов. ",
			remote: "Номер телефона уже зарегистрирован другим пользователем. "
		},
		captcha: {
			required: "Поле обязательно для заполнения. ",
			minlength: "Минимальная длина 6 символов. ",
			remote: "Указанные вами символы не совпадают. "

		}
   	}
});
return false;
}); 


    function success(returnData, statusText, xhr, form) {
	if( returnData.RETVAL == 1 ){
		//window.location = returnData.REDIR;
		// пока кидаем на главную потом можно еще и параметр редир передавать иначе никак.
		//$("#mes").html(returnData.RETDESC);
		//window.location = updateURL("/?page=pasport");
		window.location = "http://localhost/?page=pasport";
	}else{
		$("#mes").html("");
		$("#mes").html(returnData.RETDESC);
		$("#mes").html(returnData.STRUCT.mail);
	}
    }

    function errorHandler() {
	$("#mes").html(returnData.RETVAL + returnData.RETDESC);
      //alert( "Есть проблемы с получением прогноза. Наверно, Васюки смыло в море." );
    }