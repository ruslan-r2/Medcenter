/*
	�������� ���� ��� ajax ��������.
*/
component displayname="ajax" output="false"{

	remote function login(required string username, required string password, string redir){
		authorization = request.factoryService.getService('authorization');
		// ����� ��� �������� �������� � ��� ��� ������������ ��� ���������
		// ����� ����������� ������ � ���������� ������������!
		result = authorization.loginUser(arguments.userName, arguments.password, arguments.redir);
		//sleep(2000);
		return result;
	}

	remote function logout(){

		authorization = request.factoryService.getService('authorization');

		result = authorization.logoutUser();
		return result;
	}

	remote function registration(required string username, required string password, required string password1, string tel_mob, string mail, string captcha, string UUID){
		authorization = request.factoryService.getService('authorization');
		// ����� ��� �������� �������� � ��� ��� ������������ ��� ���������
		// ����� ����������� ������ � ���������� ������������!
		result = authorization.registrationUser(arguments.username, arguments.password, arguments.password1, arguments.tel_mob, arguments.mail, arguments.captcha, arguments.UUID);
		return result;
	}

	remote function checkUserName(string username){
		validator = request.factoryService.getService('Validator');
		return validator.checkInputDB('bbs_users','user_name',arguments.username); // ���������� true \false
	}

	remote function checkEmail(string mail){
		validator = request.factoryService.getService('Validator');
		return validator.checkInputDB('bbs_users','user_mail',arguments.mail); // ���������� true \false
	}

	remote function checkTelMob(string tel_mob){
		validator = request.factoryService.getService('Validator');
		return validator.checkInputDB('bbs_users','user_telmob',arguments.tel_mob); // ���������� true \false
	}

	remote function checkCaptcha(string captcha, string UUID){
		validator = request.factoryService.getService('Validator');
		struct_ = validator.checkCaptcha(captcha,UUID); // ���������� ��������� retval retdesc
		return struct_.retval; // ���� true ���� false
	}

	remote function javaScripts(string page='null'){ // ��� ����� � ��� ������� �������� �������� undefined 
		var list = request.factoryService.getService('CJavaScript').getListJScripts(arguments.page);
		return list;
	}

	remote function addPhrase(required string phrase, required numeric userID, required string phKey, numeric num){
		result = request.factoryService.getService('phrasesAPI').addPhrase(arguments.userID, arguments.phKey, arguments.phrase ); //HTMLEditFormat(arguments.phrase)
		structInsert(result, 'num', arguments.num );
		phrase=replace(arguments.phrase, chr(39), "#chr(34)#", "all");
		phrase=replace(phrase, chr(60), "&##60;", "all");
		phrase=replace(phrase, chr(62), "&##62;", "all");
		structInsert(result, 'phrase', phrase );
		return result;
	}

	remote function deletePhrase(required string phrase, required numeric userID, required string phKey, numeric num){
		result = request.factoryService.getService('phrasesAPI').deletePhrase(arguments.userID, arguments.phKey, arguments.phrase ); //HTMLEditFormat(arguments.phrase)
		structInsert(result, 'num', arguments.num );
		phrase=replace(arguments.phrase, chr(39), "#chr(34)#", "all");
		phrase=replace(phrase, chr(60), "&##60;", "all");
		phrase=replace(phrase, chr(62), "&##62;", "all");
		structInsert(result, 'phrase', phrase );
		return result;
	}

	remote function paidServices( svIDs, svStatus ){
		result = request.factoryService.getService('userServicesAPI').editeReceptionServiceStatus( arguments.svIDs, arguments.svStatus );
		return result;

	}

	/*
	remote function checkCaptcha(string captcha, string UUID, string redir=''){

		result = structNew();
		//result.RETVAL = 0;
		//result.RETDESC= '';

		objCaptcha = request.factoryService.getService('CCaptcha');
		if ( objCaptcha.getCaptcha(urlDecode(arguments.UUID)) == arguments.captcha ){
			result.RETVAL = 1;
			result.RETDESC= '';
			result.REDIR= arguments.redir;
			// ��������� �����
			request.factoryService.getService('CCaptcha').delCaptcha(urlDecode(arguments.UUID));
			// ���������� � ��������
			request.factoryService.getService('CFireWall').goodUser();
		}else{
			result.RETVAL = 0;
			result.RETDESC= '����������� ������ �� �����';
		}

		return result;
	}
	*/

}