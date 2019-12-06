/* 
	Виджет авторизации --
*/

component attributeName='auth' output='false'{
	// псевдо конструктор
	// обернуть в лок
	factoryService = request.factoryService;
	// обернуть в лок
	instance.user = session.sessionStorage.getObject('user'); // сесионный Объект
	
	instance.mini = '';		// страница для которой строить вьювер
	instance.view = '';

	instance.username = '';
	instance.password = '';
	instance.message = '';


	function Init(mini='true') {
		// форм фактор	
		instance.mini=arguments.mini;
		run();
		return this;
	}

	function run(){

		formHandler();
		// при выключенных кукисах неправильно работает форма авторизации
		// если добавить в актион урлтокен то работает безьявовый вариант явовый не работает !!!!
		

		// проверяем параметр в урле
		if ( isdefined('url.redir') ){
			redir = '#url.redir#';
		}else{
			redir = 'http://#CGI.SERVER_NAME#/?page=pasport';
		}
			//redir = #request.CRequest.updateURL(false,"#redir#")#;

		rbac = request.RBAC; //request.factoryService.getService('rbac');
		if ( rbac.findAssignedRoles('guest') ){
			action = '/?page=pasport&redir=#UrlEncodedFormat("http://#CGI.SERVER_NAME#/?page=pasport")#';
			action = #request.CRequest.updateURL(false,"#action#")#;
			instance.view = logInForm(instance.mini,action);
		}else{
			action = '/?page=pasport&redir=#UrlEncodedFormat("http://#CGI.SERVER_NAME#/?page=pasport")#';
			action = #request.CRequest.updateURL(false,"#action#")#;
			instance.view = logOutForm(instance.mini,action);
		}


	}

	// обработчик формы если ява выключена
	private function formHandler(){
		// --- обработчик формы---
		//errmsg = '';
		if ( isdefined('form.logout') ){
		  authorization = factoryService.getService('authorization');
	          result = authorization.logoutUser();
				if ( result.LOGGEDIN is 0 ){
				factoryService.getService('redirector').redirect('#redir#');
			}
		}
		
		if ( isdefined('form.login') and isdefined('form.username') and isdefined('form.password') ){
		  authorization = factoryService.getService('authorization');
		      result = authorization.loginUser(#form.username#,#form.password#);
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
		// --- обработчик формы---
	}

	function logInForm(mini='true', action=''){

		if (arguments.mini){
			view = '
			<div class="grid_8">
				<form name="LogIn" action = "#arguments.action#" method = "post">
					<div style="text-align:right; ">
					<input type = "text" placeholder="логин" name = "username" value = "" size = "10" maxlength = "22"><input class="passwd-label" type = "password" placeholder="пароль" name = "password" value = "" size = "10" maxlength = "20"><input class="g-button g-button-submit" type = "submit" name = "login" value = "Войти">
					</div>
				</form>
			</div>';
		}else{

			// Если JavaScript выключен то попадаем в action
			// сейчас скрипты добавляются жостко в объекте CJavaScript
			// нужно его перевести в аппликатион и пусть каждый скрипт в него добавляет свои пометки
			//factoryService.getService('CJavaScript').addJScript(fileName=',/js/jquery.validate.js');
			//factoryService.getService('CJavaScript').addJScript(fileName=',/js/authorization.js');

			param name='form.username' default='';
			param name='errmsg' default='';

			view = '';
			view &='<div class="prefix_6 grid_4">
				<div class="signin-box">
				<h2>ООО "Жемчужина подолья"</h2>
				<form name="LogIn" id="logInForm" action="#arguments.action#" method="post">
					<div class="username-div">
						<label><strong class="username-label">Логин</strong></label>
						<input style="width:100%;" type="text" id="username" name="username" value="#form.username#" maxlength = "20" >';
			if (instance.username is not ''){
			view &= '		<label for="username" class="error" generated="0">#instance.username#</label>';
			}
			view &= '	</div>
					<div class="passwd-div">
						<label><strong class="passwd-label">Пароль</strong></label>
						<input style="width:100%;" type="password" id="password" name="password" maxlength = "20">';
			if (instance.password is not ''){
			view &= '		<label for="password" class="error" generated="1">#instance.password#</label>';
			}
			view &= '
					</div>
					<input type="hidden" name="redir" value="#redir#">
					<p><input class="g-button g-button-submit" type="submit" name="login" value="Войти"></p>
					<div id="mes" style="color:red;">
					';
			if (instance.message is not ''){
				view &= '#instance.message#';
			}
			view &=	'</div></form>
				</div></div>';
		}
		return view;
	}


	function logOutForm(mini='true', action=''){
		if (arguments.mini){
			view = '
			<div class="grid_8">
				<form name="LogOut" action = "#arguments.action#" method = "post">
					<div style="text-align:right;">
					<b>Пользователь - #instance.user.getUserName()#</b>
					<input class="g-button g-button-submit" type = "submit" name = "logout" value = "Выйти">
					</div>
				</form>
			</div>';
		}else{
			// надо подумать, но на странице паспорт если вошли должен быть редирект в кабинет.
			// но если будет логаут в кабинете и не в шапке то здесь нужна форма и есть проблема с явой в этом месте
			view= '<div id="logout" class="signin-box">Страница авторизации.</div>';
			userGroup = instance.user.getUserGroups();
			if ( userGroup == 2){
				factoryService.getService('redirector').redirect('#request.CRequest.updateURL(false,"/?page=rbac")#');
			}else if( userGroup == 3){
				factoryService.getService('redirector').redirect('#request.CRequest.updateURL(false,"/?page=reception")#');
			}else if( userGroup == 4){
				factoryService.getService('redirector').redirect('#request.CRequest.updateURL(false,"/?page=services")#');
			}else if( userGroup == 5){
				factoryService.getService('redirector').redirect('#request.CRequest.updateURL(false,"/?page=cabinet")#');
			}else if( userGroup == 9){
				factoryService.getService('redirector').redirect('#request.CRequest.updateURL(false,"/?page=cabinet")#');
			}else if( userGroup == 10){
				factoryService.getService('redirector').redirect('#request.CRequest.updateURL(false,"/?page=usersGraphics")#');
			}else{
				factoryService.getService('redirector').redirect('#request.CRequest.updateURL(false,"/?page=patients")#');
			}
		}
		return view;
	}

	function View() {
		return instance.view;
  	}

}