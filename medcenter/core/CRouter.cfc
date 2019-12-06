component attributeName='CRouter' {

	// псевдо конструктор
	// забераем настройки рутера pageList и pageDefault
	instance.settings = request.factoryService.getService('CSettings').getSettings('router'); // структура
	instance.CFireWall = request.factoryService.getService('CFireWall'); // объект
	instance.CRequest = request.CRequest; // объект
	instance.redirect = request.factoryService.GetService('redirector');

	function Init() {
		return this;
	}

	function Run(){
		fwRole = instance.CFireWall.getRole() ;
		if (fwRole is 'podoz'){
			if ( instance.CRequest.GetUrl('page') is not 'captcha'){
				instance.redirect.redirect('#request.CRequest.updateURL(false,"/?page=captcha&redir=#UrlEncodedFormat("http://#CGI.SERVER_NAME#/?#cgi.query_string#")#")#','');
			}else{
				render=createObject('component','Builder.page.captcha').init();
			        render.Render();
			}
		}else if (fwRole is 'ban'){
			if ( instance.CRequest.GetUrl('page') is not 'ban'){
				instance.redirect.redirect('#request.CRequest.updateURL(false,"/?page=ban")#','&message=#instance.CFireWall.getRole()#');
			}else{
				render=createObject('component','Builder.page.ban').init();
			        render.Render();
        		}
		}else if (fwRole is 'deny'){
			if ( instance.CRequest.GetUrl('page') is not 'deny'){
				instance.redirect.redirect('#request.CRequest.updateURL(false,"/?page=deny")#','&message=#instance.CFireWall.getRole()#');
			}else{
				render=createObject('component','Builder.page.deny').init();
			        render.Render();
			}
		}else{
			if ( request.CRequest.CheckUrl() ) {
				// нужно дописать проверку состояния фаервола и если состояние ok то не пускать на страници captcha - ban - deny
				// нужно открыть доступ к страницам captcha, ban, deny !!
				if ( ListFind('captcha,ban,deny',instance.CRequest.GetUrl('page')) AND ListFind('user,robot', fwRole) ) {
					instance.redirect.redirect('#request.CRequest.updateURL(false,"/?page=warning")#','&message=#UrlEncodedFormat("Доступ к странице #page# закрыт.")#');
				}


				if (request.CCGI.getCGI('QUERY_STRING')=='') {
					// это если обратиться к домену digann.ru тогда query_string пустой и надо взять default-home
					pageBuild=instance.settings.pageDefault;  // default home
				} else {
					pageBuild=instance.CRequest.GetUrl('page'); // если в урл нет page то false
					if (pageBuild!=false and !ListFind(instance.settings.pageList,pageBuild)) {
						// вызывеам логгер и указываем причину
						// сюда попадают не существующие страници
						request.factoryService.getService('Clog').AddLogging(ssection='CRouter', type='event', description='Указанной страници не существует');
						// вызываем редирект и записываем в него куда и причину
						instance.redirect.redirect('#request.CRequest.updateURL(false,"/?page=warning")#','message=#UrlEncodedFormat("Указанной страници #page# не существует")#');
					}
				}
			
				rbac= request.RBAC; //request.factoryService.getService('rbac');
				if (rbac.CheckAccess('#pageBuild#','access')) {
					render=createObject('component','Builder.page.#pageBuild#').init();
					render.Render();
				} else {
					// вызывеам логгер и указываем причину
					request.factoryService.getService('Clog').AddLogging(ssection='CRouter', type='event', description='Доступ к данной странице закрыт');
					// вызываем редирект и записываем в него куда и причину
					instance.redirect.redirect('#request.CRequest.updateURL(false,"/?page=warning")#','message=#UrlEncodedFormat("Доступ к странице #page# закрыт")#');
				}
			}else{
				//
				instance.redirect.redirect('#request.CRequest.updateURL(false,"/?page=warning")#','&message=#UrlEncodedFormat("Недопустимые символы в URL")#');
			}

		}

	} // end function
}