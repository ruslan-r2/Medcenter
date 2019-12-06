/*
	phrases API - сервис
*/
component displayname="phrasesAPI" output="false" {

	// Псевдо конструктор
	instance = {phrases = '', phrasesDAO = '' };
	instance.phrasesDAO = createObject('component', 'core.db.phrasesDAO' ).init();
		
	function init(){
		return this;
	}

	function getPhrases(userID,phKey){
	        instance.phrases = instance.phrasesDAO.readPhrases(arguments.userID, arguments.phKey);
		return instance.phrases;
	}

	function addPhrase( userID, phKey, phValue ){

		userID = arguments.userID;
		phKey = arguments.phKey;
		phValue = arguments.phValue;

		var result = structNew();
		result.RETVAL = 0;
		result.RETDESC = "";
		result.STRUCT = structNew(); // для валидации полей

		// проверку полей формы перед отправкой в базу нужно организовать здесь
		// нужно структурировать формат ответа функции, чтобы можно было использовать
		// в любых скриптах получается как API

		validator = request.factoryService.getService('Validator');

		if ( userID != session.sessionStorage.getObject('user').getUserId() ){
			structInsert(result.struct, 'RBAC','У Вас нет прав доступа.');
		}else{
			var struct_ = validator.checkInput('#phValue#',true,'checkString',1,1500);
			if ( !struct_.retval ){
				structInsert(result.struct, 'phValue','#struct_.retdesc#');
			}
		}

		//--------------------------------------------------------------------

	        // если обнаружены ошибки
		if ( structIsEmpty(result.struct) ){
			phValue=replace(phValue, chr(39), "#chr(34)#", "all");
			phValue=replace(phValue, chr(60), "&##60;", "all");
			phValue=replace(phValue, chr(62), "&##62;", "all");
			structCreatePhrase = instance.phrasesDAO.createPhrase( userID, phKey, phValue );

			if (structCreatePhrase.RETVAL == 1){
				result.RETVAL = structCreatePhrase.RETVAL;
				result.RETDESC = structCreatePhrase.RETDESC;
			}else {
				result.RETVAL = structCreatePhrase.RETVAL;
				result.RETDESC = structCreatePhrase.RETDESC;
			}

		}
		return result;
	}

	function deletePhrase( userID, phKey, phValue ){

		userID = arguments.userID;
		phKey = arguments.phKey;
		phValue = arguments.phValue;

		var result = structNew();
		result.RETVAL = 0;
		result.RETDESC = "";
		result.STRUCT = structNew(); // для валидации полей

		validator = request.factoryService.getService('Validator');

		if ( userID != session.sessionStorage.getObject('user').getUserId() ){
			structInsert(result.struct, 'RBAC','У Вас нет прав доступа.');
		}else{
			var struct_ = validator.checkInput('#phValue#',true,'checkString',1,1500);
			if ( !struct_.retval ){
				structInsert(result.struct, 'phValue','#struct_.retdesc#');
			}
		}

		//--------------------------------------------------------------------

	        // если обнаружены ошибки
		if ( structIsEmpty(result.struct) ){
			phValue=replace(phValue, chr(39), "#chr(34)#", "all");
			phValue=replace(phValue, chr(60), "&##60;", "all");
			phValue=replace(phValue, chr(62), "&##62;", "all");
			structDeletePhrase = instance.phrasesDAO.deletePhrase( userID, phKey, phValue );

			if (structDeletePhrase.RETVAL == 1){
				result.RETVAL = structDeletePhrase.RETVAL;
				result.RETDESC = structDeletePhrase.RETDESC;
			}else {
				result.RETVAL = structDeletePhrase.RETVAL;
				result.RETDESC = structDeletePhrase.RETDESC;
			}

		}
		return result;
	}

	function getMemento(){
		return instance;
	}

}