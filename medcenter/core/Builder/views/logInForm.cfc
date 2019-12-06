
	private function formHandler(){

		if ( isdefined('form.logout') ){
			result = factoryService.getService('authorization').logoutUser();
			if ( result.LOGGEDIN is 0 ){
				factoryService.getService('redirector').redirect('#redir#');
			}
		}
		
		if ( isdefined('form.login') and isdefined('form.username') and isdefined('form.password') ){
			result = factoryService.getService('authorization').loginUser(#form.username#,#form.password#);
			if ( result.RETVAL is 1 ){
				factoryService.getService('redirector').redirect('#redir#');
			}else{
				// --- пробная версия
				if (StructKeyExists(result, 'RETDESC')) {
					instance.message = result['RETDESC'];
				} else {
					instance.message = '';
				}

				if (StructKeyExists(result.STRUCT, 'username')) {
					instance.username = result.STRUCT['username'];
				} else {
					instance.username = '';
				}
				if (StructKeyExists(result.STRUCT, 'password')) {
					instance.password = result.STRUCT['password'];
				} else {
					instance.password = '';
				}
			}
		}
	}

	function logInForm(mini='true', action=''){

		if (arguments.mini){
			view = '<form name="LogIn" action = "#arguments.action#" method = "post">
					<input type = "text" placeholder="логин" name = "username" value = "" size = "10" maxlength = "22">
					<input class="passwd-label" type = "password" placeholder="пароль" name = "password" value = "" size = "10" maxlength = "20">
					<input class="g-button g-button-submit" type = "submit" name = "login" value = "Войти">
				</form>';

		}else{

			// Если JavaScript выключен то попадаем в action
			// сейчас скрипты добавляются жостко в объекте CJavaScript
			// нужно его перевести в аппликатион и пусть каждый скрипт в него добавляет свои пометки
			//factoryService.getService('CJavaScript').addJScript(fileName=',/js/jquery.validate.js');
			//factoryService.getService('CJavaScript').addJScript(fileName=',/js/authorization.js');

			param name='form.username' default='';
			param name='errmsg' default='';

			view = '';
			view &='<div class="push_5 grid_6">
				<div class="signin-box">
				<h2>ООО "Жемчужина подолья"</h2>
				<form name="LogIn" id="logInForm" action="#arguments.action#" method="post">
					<div class="username-div">
						<label><strong class="username-label">Логин</strong></label>
						<input type="text" id="username" name="username" size="34" value="#form.username#" maxlength = "20" >';
			if (instance.username is not ''){
			view &= '		<label for="username" class="error" generated="0">#instance.username#</label>';
			}
			view &= '	</div>
					<div class="passwd-div">
						<label><strong class="passwd-label">Пароль</strong></label>
						<input type="password" id="password" name="password" size="34" maxlength = "20">';
			if (instance.password is not ''){
			view &= '		<label for="password" class="error" generated="1">#instance.password#</label>';
			}
			view &= '
					</div>
					<input type="hidden" name="redir" value="#redir#">
					<p><input class="g-button g-button-submit" type="submit" name="login" value="Войти"></p>
					';
			if (instance.message is not ''){
				view &= '<div id="mes" style="color:red;">#instance.message#</div>';
			}
			view &=	'</form>
				</div></div>';
		}
		return view;
	}