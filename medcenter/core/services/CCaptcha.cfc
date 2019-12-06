/*
	CCaptcha - ������
*/
component displayname="CCaptcha" output="false" {

	// ������ �����������
	instance.captcha = {}; //������

	lock scope="session" type="exclusive" timeout="5" {
		instance.captcha = session.sessionStorage.getObject('captcha'); // ��������� ������
	}

	
	function init(){
		return this;
	}

	function getCaptcha(required UUID){
		return instance.captcha.getCaptcha(arguments.UUID);
	}

	function delCaptcha(required UUID){
		instance.captcha.delCaptcha(arguments.UUID);
	}


	function generateCaptcha(required UUID){ //UUID ���������� � �����

		//UUID = createUUID();
		UUID = arguments.UUID;

		// ���������� ��������� ������
		countSymbols = randrange(6,6);
		symbols = '';
		for ( x = 1; x LTE countSymbols; x=x+1) {
		  groupSymbols = randrange(1,3);
		  if (groupSymbols is "1"){
		    symbols &= "#chr(randrange(49,57))#";
		  }
		  if (groupSymbols is "2"){
		    symbols &= "#chr(randrange(65,78))#";
		  }
		  if (groupSymbols is "3"){
		    symbols &= "#chr(randrange(80,90))#";
		  }
		}

		instance.captcha.setCaptcha(UUID, symbols); // ������� ������ � ������

	}

	function getMemento(){
		return instance.captcha.getMemento();
	}


}