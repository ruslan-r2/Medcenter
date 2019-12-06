/*
  сессионный объект капча - session captcha object
*/

component displayname="captcha" output="false" {

	// псевдо конструктор
	instance.captcha = structNew();

	// сохранять сгенерированные цифры для капчи пр. CFx76q
	// и идентификатор формы для которой генерировался idkey - UUID

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