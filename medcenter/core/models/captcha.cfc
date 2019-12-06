/*
  ���������� ������ ����� - session captcha object
*/

component displayname="captcha" output="false" {

	// ������ �����������
	instance.captcha = structNew();

	// ��������� ��������������� ����� ��� ����� ��. CFx76q
	// � ������������� ����� ��� ������� ������������� idkey - UUID

	function init(){
		return this;
	}

	function setCaptcha(required string UUID, required string symbols){
		instance.captcha[arguments.UUID] = arguments.symbols;
	}

	function getCaptcha(required string UUID){
		//if (structKeyExists(instance.captcha,#arguments.UUID#)){
			return instance.captcha[arguments.UUID];
		//}
	}

	function delCaptcha(required string UUID){
		if (structKeyExists(instance.captcha,#arguments.UUID#)){
			structDelete(instance.captcha,'#arguments.UUID#');
		}
	}

	function getMemento(){return instance;}

}