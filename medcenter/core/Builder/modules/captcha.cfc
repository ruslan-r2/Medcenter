/*
	widget captcha - виджет капча 
*/

component attributeName='captcha' output='false'{

	// псевдо конструктор
	factoryService = request.factoryService;
	instance.CCaptcha = factoryService.getService('CCaptcha'); // вызываем службу капча
	// включена ява или нет
	//instance.javaScript = factoryService.getService('CJavaScript').addMeta(fileName=',/js/captcha.js');

	function Init() {
		run();
		return this;
	}

	function run(){

		if ( isDefined('url.redir') ){
			redir = #request.CRequest.updateURL(false,"#url.redir#")#;
		}else{
			redir = 'http://127.0.0.1/';
		}

		formHandler();

	}

	// обработчик формы если ява выключена
	function formHandler(){
		param name='errmsg' default='';
		param name='captcha' default='';
		//--- Обработчик формы ---
		if ( isdefined('form.ok') ){
			if ( instance.CCaptcha.getCaptcha(form.UUID) == form.captcha ){
				//errmsg = "Все правильно ввел.";

                		// нужно сбросить настройки фаервола чтобы пользователя пропустить.
				factoryService.getService('CFireWall').setUserIpParam( role='user', description='Снимаем бан и подозрение с данного IP, пользователь ввел капчу.', doLog=true);
				// нужно удалять IP из базы
				//instance.fireWallDAO.deleteIP(UserIP=#instance.UserIp.getCurrentIp()#);

				factoryService.getService('redirector').redirect('#redir#');
			}else{
				errmsg = "Неправильные цифры капчи.";
				// надо удалить из сессионного объекта введенные данные
			}
			// надо удалить из сессионного объекта введенные данные
			instance.CCaptcha.delCaptcha(form.UUID);
		//--- Обработчик формы ---
		}
	}


	function View() {

		UUID = createUUID(); // уникальный ID для формы
 		instance.CCaptcha.generateCaptcha(UUID); // генрируем капчу для ID формы

		savecontent variable="cfimage"{ 
			include 'cfimage.cfm';
		}

		view = '';
		view &= '<div id="mes" style="color:red;">#errmsg#</div>
			<div id="block">
			<form id="captcha" name="captcha" action="#request.CRequest.updateURL(false,"/?page=captcha")#" method="post">
				<div>	
					#cfimage#
					<input type="text" name="captcha" value="" maxlength="10" size="10">
					<input type="hidden" name="UUID" value="#UUID#" >
					<input type="hidden" name="redir" value="#redir#">
				</div>
				<input type="submit" name="update" value="<>" >
				<input type="submit" name="ok" value="ok" >
			</form>
			</div>';

		writeOutPut(view);	
	}

}