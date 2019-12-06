/*
	Поле обязательно для заполнения.
	Разрешены только латинские буквы(<B>A-Z</B>), цифры(<B>0-9</B>), символ подчеркивания(<B>_</B>) и точка(.).
	Минимальная длина 2 символа.
	Максимальная длина 20 символов.
*/
component name="validator" output="false" {

	// псевдо конструктор
	function init(){
		return this;
	}
	// ----------------------------------------------------------------------------------------------------
	// проверка нескольких полей
	function checkInputGroup( list, type ){

	var struct = {};
	struct.retval = false;
	struct.retdesc = '';

		// обязательно одно из полей
		if (arguments.type is 'requiredOneOfField'){
			struct.retdesc = 'Заполните одно из полей.';
			for (i=1; i LTE listLen(arguments.list); i++){
				if ( listGetAt(arguments.list,i) is not '' ){
					struct.retval = true;
				}else{
					struct.retdesc = 'Заполните одно из полей.';
				}
			}
		}

		// сравнение двух полей
		if (arguments.type is 'checkSameAs'){
			struct.retdesc &= 'Пароли не совпадают. ';
			struct.retval = checkSameAs(arguments.list);
		}
		// проверка в базе
		return struct;
	}

	// проверка одного поля
	function checkInput( str, _required, regEx, minLen, maxLen, DB=false, table_name='', field_name='', field_name_rus=''){

	var struct = {};
	struct.retval = false;
	struct.retdesc = '';

		// -- Формируем сообщения
		// -- required
		if (arguments._required is true){
			struct.retdesc &= 'Поле обязательно для заполнения. ';
		}
		// -- regEx
		if(arguments.regEx is 'checkString'){struct.retdesc &= 'Разрешены строковые значения и цифры.';}
		else if(arguments.regEx is 'isAllowSimbol'){struct.retdesc &= 'Разрешены латинские буквы(A-Z), цифры(0-9), символ подчеркивания(_) и точка(.). ';}
		else if(arguments.regEx is 'isAllowSimbolRusEn'){struct.retdesc &= 'Разрешены латинские буквы(A-Z), русские буквы(А-Я), цифры(0-9), символ подчеркивания(_) и точка(.). ';}
		else if(arguments.regEx is 'isValidPassword'){struct.retdesc &= 'Cлабый пароль. Пароль должен содержать одну заглавную букву, одну строчную букву и цифру. ';}
		else if(arguments.regEx is 'isValidEmail'){struct.retdesc &= 'Укажите действительный E-mail адрес. ';}
		else if(arguments.regEx is 'isValidTelMob'){struct.retdesc &= 'Разрешены только цифры. Начинается с цифры 9. ';}
		else if(arguments.regEx is 'isValidTelGor'){struct.retdesc &= 'Разрешены только цифры. Начинается с цифры 4. ';}
		else if(arguments.regEx is 'isNumeric'){struct.retdesc &= 'Разрешены только цифры. ';}
		else if(arguments.regEx is 'isDate'){struct.retdesc &= 'Неправильный формат даты. ';}
		else if(arguments.regEx is 'isTime'){struct.retdesc &= 'Неправильный формат времени. ';}

		// -- minLen
		if ( arguments.minLen is not 0) { // можно допустить
			struct.retdesc &= 'Минимальное количество символов #arguments.minLen#. ';
		}
		// -- maxLen
		if ( arguments.maxLen is not 0) { // при максимальном кол-ве символов 0 быть не должно!
			struct.retdesc &= 'Максимальное количество символов #arguments.maxLen#. ';
		}



		// -- Валидация полей.
		// -- required
		if ( arguments._required is true AND arguments.str is '') {
			struct.retval = false;
		}else if ( arguments._required is false AND arguments.str is ''){
			struct.retval = true;
		// -- regEx
		}else{
			if ( arguments.regEx is 'checkString'){ struct.retval = checkString(arguments.str); }
			if ( arguments.regEx is 'isAllowSimbol'){ struct.retval = isAllowSimbol(arguments.str); }
			if ( arguments.regEx is 'isAllowSimbolRusEn'){ struct.retval = isAllowSimbolRusEn(arguments.str); }
			if ( arguments.regEx is 'isValidPassword'){ struct.retval = isValidPassword(arguments.str); }
			if ( arguments.regEx is 'isValidEmail'){ struct.retval = isValidEmail(arguments.str); }
			if ( arguments.regEx is 'isValidTelMob'){ struct.retval = isValidTelMob(arguments.str); }
			if ( arguments.regEx is 'isValidTelGor'){ struct.retval = isValidTelGor(arguments.str); }
			if ( arguments.regEx is 'isNumeric'){ struct.retval = isNumeric(arguments.str); }
			if ( arguments.regEx is 'isDate'){ struct.retval = _isDate(arguments.str); }
			if ( arguments.regEx is 'isTime'){ struct.retval = _isTime(arguments.str); }

			// --minLen --maxLen проверка на длинну не меньше и не больше
			if ( struct.retval is not false ){
				struct.retval = checkRangeLen(arguments.str, arguments.minLen, arguments.maxLen);
			}
		}

		if ( arguments.DB ){
			if ( struct.retval is not false AND arguments.str is not ''){
				struct.retval = checkInputDB(arguments.table_name, arguments.field_name, arguments.str);
				struct.retdesc = '#arguments.field_name_rus# уже зарегистрирован другим пользователем.';
				//writeDump( checkInputDB(arguments.table_name, arguments.field_name, arguments.str) );
			}
		}

		return struct;
	}
	// ----------------------------------------------------------------------------------------------------

	function isAllowSimbol(str){
		if ( ReFind("^[a-zA-Z0-9\_\.]*$", arguments.str) ){ return true; }
		else { return false; }
	}

	function isAllowSimbolRusEn(str){
		if ( ReFind("^[a-zA-Zа-яА-Я0-9\_\.]*$", arguments.str) ){ return true; }
		else { return false; }
	}

	function isValidPassword(str){
		if ( ReFind("(?=^.{8,}$)((?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$", arguments.str) ){ return true;}
		else { return false;}
	}

	function isValidEmail(str){
		if ( ReFind("^[a-z0-9_\-]+(\.[_a-z0-9\-]+)*@([_a-z0-9\-]+\.)+([a-z]{2}|aero|arpa|biz|com|coop|edu|gov|info|int|jobs|mil|museum|name|nato|net|org|pro|travel)$", arguments.str) ){ return true;}
		else { return false;}
	}

	function isValidTelMob(str){
		if ( ReFind("^9+[0-9]*$", arguments.str) ){ return true;}
		else { return false;}
	}

	function isValidTelGor(str){
		if ( ReFind("^4+[0-9]*$", arguments.str) ){ return true;}
		else { return false;}
	}


	function isNumeric(str){ return isValid("numeric",arguments.str); } // numeric - цифровой
	function isInteger(str){ return isValid("integer",arguments.str); } // integer - целое
	function _isDate(str){ return isValid("date",arguments.str); }
	function _isTime(str){ return isValid("time",arguments.str); }


	function checkSameAs(list){
		//writeDump(listLen(arguments.str));
		if ( listLen(arguments.list)==2){ // защита от пустых полей формы
			if( compare( listGetAt(arguments.list,1), listGetAt(arguments.list,2) ) eq 0){ return true; }
			else{ return false; } 
		}else{
			return false;
		}
	}

	function checkString(str){ return isValid("string",arguments.str); }


	function checkCaptcha(string captcha, string UUID){
	var struct = {};
	struct.retval = false;
	struct.retdesc = '';

		objCaptcha = request.factoryService.getService('CCaptcha');
		if ( objCaptcha.getCaptcha(urlDecode(arguments.UUID)) != arguments.captcha ){
			struct.retval = false;
			struct.retdesc = 'Контрольные символы не верны.';
		}else{
			struct.retval = true;
		}
		return struct;
	}

	// temp  checkInputDB
	function checkInputDB( table_name, field_name, value ){

		//var struct = {};
		//struct.retval = false;
		//struct.retdesc = 'База не доступна.';
        
		userDAO = createObject('component', 'core.db.userDAO' ).init();
		qCheckInputDB = userDAO.checkInputDB('#arguments.table_name#','#arguments.field_name#','#arguments.value#');

		//writeDump(qCheckInputDB);
		if (qCheckInputDB.recordcount gt 0){
			return false;
		}else{
			return true;
		}
		//return struct;
	}



	// проверка на минимальную длину строки
	/*
	function checkMinLen(str,length){ 
		if (len(arguments.str) >= arguments.length) { return true; }
		else { return false;}
	}*/

	// проверка на максимальную длину строки
	/*
	function checkMaxLen(str,length){ 
		if  (len(arguments.str) <= arguments.length ) {return true; }
		else { return false; }
	}*/

	// диапазон от MIN до MAX
	function checkRangeLen(str, min, max) {
		if ( len(arguments.str) >= arguments.min AND len(arguments.str) <= arguments.max){return true;}
		else {return false;}
	}


	function getMemento(){
		return instance;
	}

}// компанента