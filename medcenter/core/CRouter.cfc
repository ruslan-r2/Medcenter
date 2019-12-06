component attributeName='CRouter' {

	// ������ �����������
	// �������� ��������� ������ pageList � pageDefault
	instance.settings = request.factoryService.getService('CSettings').getSettings('router'); // ���������
	instance.CFireWall = request.factoryService.getService('CFireWall'); // ������
	instance.CRequest = request.CRequest; // ������
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
				// ����� �������� �������� ��������� �������� � ���� ��������� ok �� �� ������� �� �������� captcha - ban - deny
				// ����� ������� ������ � ��������� captcha, ban, deny !!
				if ( ListFind('captcha,ban,deny',instance.CRequest.GetUrl('page')) AND ListFind('user,robot', fwRole) ) {
					instance.redirect.redirect('#request.CRequest.updateURL(false,"/?page=warning")#','&message=#UrlEncodedFormat("������ � �������� #page# ������.")#');
				}


				if (request.CCGI.getCGI('QUERY_STRING')=='') {
					// ��� ���� ���������� � ������ digann.ru ����� query_string ������ � ���� ����� default-home
					pageBuild=instance.settings.pageDefault;  // default home
				} else {
					pageBuild=instance.CRequest.GetUrl('page'); // ���� � ��� ��� page �� false
					if (pageBuild!=false and !ListFind(instance.settings.pageList,pageBuild)) {
						// �������� ������ � ��������� �������
						// ���� �������� �� ������������ ��������
						request.factoryService.getService('Clog').AddLogging(ssection='CRouter', type='event', description='��������� �������� �� ����������');
						// �������� �������� � ���������� � ���� ���� � �������
						instance.redirect.redirect('#request.CRequest.updateURL(false,"/?page=warning")#','message=#UrlEncodedFormat("��������� �������� #page# �� ����������")#');
					}
				}
			
				rbac= request.RBAC; //request.factoryService.getService('rbac');
				if (rbac.CheckAccess('#pageBuild#','access')) {
					render=createObject('component','Builder.page.#pageBuild#').init();
					render.Render();
				} else {
					// �������� ������ � ��������� �������
					request.factoryService.getService('Clog').AddLogging(ssection='CRouter', type='event', description='������ � ������ �������� ������');
					// �������� �������� � ���������� � ���� ���� � �������
					instance.redirect.redirect('#request.CRequest.updateURL(false,"/?page=warning")#','message=#UrlEncodedFormat("������ � �������� #page# ������")#');
				}
			}else{
				//
				instance.redirect.redirect('#request.CRequest.updateURL(false,"/?page=warning")#','&message=#UrlEncodedFormat("������������ ������� � URL")#');
			}

		}

	} // end function
}