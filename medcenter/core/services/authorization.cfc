/*
  Сервис Авторизации - Service authorization
*/

component displayname="authorization" {
	instance = {user = '', userDAO = '' };

	instance.userDAO = createObject('component', 'core.db.userDAO' ).init();
	lock scope="session" type="exclusive" timeout="5" {
		instance.user = session.sessionStorage.getObject('user'); // сесионный Объект
	}

	function init(){
		return this;
	}

	function getUser( userid ){
		qUser = instance.userDAO._readUser( arguments.userid );
		return qUser;
	}

	function logoutUser(){
		// сбросить сессионный объект user
		instance.user.setUserId(1);
		// Переписать роль пользователя.
		instance.user.setUserName('Гость');
		instance.user.setUserFamily('');
		instance.user.setUserFirstName('');
		instance.user.setUserLastName('');
		instance.user.setUserType('');
		instance.user.setUserGroups('1'); // rbac UserNoReg

		var result.LOGGEDIN = 0;
		result.MESSAGE = "Вы вышли!";
		return result;
	}

	function loginUser(required string username, required string password, string redir=''){
		var result = structNew();
		result.RETVAL = 0;
		result.STRUCT = structNew(); // для валидации полей
		result.RETDESC = ""; // ответ если пропустил валидатор но что то не так в базе
		result.REDIR = "#arguments.redir#"; // этот параметр нужен только для явы

		validator = request.factoryService.getService('Validator');

		var struct_ = validator.checkInput('#arguments.username#',true,'isAllowSimbol',2,20);
		if ( !struct_.retval ){
			structInsert(result.struct, 'username','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.password#',true,'checkString',8,20);
		if ( !struct_.retval ){
			structInsert(result.struct, 'password','#struct_.retdesc#');
		}

		if ( !structIsEmpty(result.struct) ){
			// к базе не пропускает а структура с сообщениями уже есть
		}else{
			// можно еще добавить проверку о том что пользователь уже залогинен
			structUser = instance.userDAO.readUser(arguments.userName, arguments.password);
			if (structUser.RETVAL is true){
				// обновляем объект user
				result.RETVAL = structUser.RETVAL;
				result.RETDESC = structUser.RETDESC;
				// База
				// есть смысл заменить все одной функцией в User
				instance.user.setUserId(structUser.user_id);
				instance.user.setUserName(structUser.user_name);
				instance.user.setUserFamily(structUser.emp_family);
				instance.user.setUserFirstName(structUser.emp_firstname);
				instance.user.setUserLastName(structUser.emp_lastname);
				instance.user.setUserType(structUser.emp_type);	                                      
				instance.user.setUserGroups(structUser.user_groups);
			}
			else {
				// говорим что нет такого пользователя
				result.RETVAL = structUser.RETVAL;
				result.RETDESC = structUser.RETDESC;
			}
		}
		return result;
	}

	function registrationUser(userName, userPass, userPass1, userStatus, userGroups, empType, empFamily, empFirstName, empLastName, empDescription ){

		userName = arguments.userName;
		userPass = arguments.userPass;
		userPass1 = arguments.userPass1;
		userStatus = arguments.userStatus;
		userGroups  = arguments.userGroups;
		empType = arguments.empType;
		empFamily = arguments.empFamily;
		empFirstName = arguments.empFirstName;
		empLastName = arguments.empLastName;
		empDescription = arguments.empDescription;

		var result = structNew();
		result.RETVAL = 0;
		result.RETDESC = "";
		result.STRUCT = structNew(); // для валидации полей

		validator = request.factoryService.getService('Validator');
		                                                          //required                 //DB
		var struct_ = validator.checkInput('#userName#',true,'isAllowSimbol',2,20, true, 'bbs_users', 'user_name','Логин');
		if ( !struct_.retval ){
			structInsert(result.struct, 'userName','#struct_.retdesc#');
		}


		var struct_ = validator.checkInput('#userPass#',true,'isValidPassword',8,20);
		if ( !struct_.retval ){
			structInsert(result.struct, 'userPass','#struct_.retdesc#');
		}

		var struct_ = validator.checkInputGroup('#userPass#,#userPass1#','checkSameAs');
		if ( !struct_.retval ){	structInsert(result.struct, 'userPass1','#struct_.retdesc#');}

		var struct_ = validator.checkInput('#userStatus#',false,'isNumeric',0,2);
		if ( !struct_.retval ){
			structInsert(result.struct, 'userStatus','#struct_.retdesc#');
		}
		var struct_ = validator.checkInput('#userGroups#',false,'isNumeric',0,2);
		if ( !struct_.retval ){
			structInsert(result.struct, 'userGroups','#struct_.retdesc#');
		}
		var struct_ = validator.checkInput('#empType#',false,'checkString',0,250);
		if ( !struct_.retval ){
			structInsert(result.struct, 'empType','#struct_.retdesc#');
		}
		var struct_ = validator.checkInput('#empFamily#',false,'checkString',0,20);
		if ( !struct_.retval ){
			structInsert(result.struct, 'empFamily','#struct_.retdesc#');
		}
		var struct_ = validator.checkInput('#empFirstName#',false,'checkString',0,20);
		if ( !struct_.retval ){
			structInsert(result.struct, 'empFirstName','#struct_.retdesc#');
		}
		var struct_ = validator.checkInput('#empLastName#',false,'checkString',0,20);
		if ( !struct_.retval ){
			structInsert(result.struct, 'empLastName','#struct_.retdesc#');
		}
		var struct_ = validator.checkInput('#empDescription#',false,'checkString',0,50);
		if ( !struct_.retval ){
			structInsert(result.struct, 'empDescription','#struct_.retdesc#');
		}

		//--------------------------------------------------------------------
	        // если обнаружены ошибки
		if ( structIsEmpty(result.struct) ){

			structRegUser = instance.userDAO.createUser(userName, userPass, userStatus, userGroups, empType, empFamily, empFirstName, empLastName, empDescription );
			if (structRegUser.RETVAL == 1){
				result.RETVAL = structRegUser.RETVAL;
				result.RETDESC = structRegUser.RETDESC;
			}else {
				result.RETVAL = structRegUser.RETVAL;
				result.RETDESC = structRegUser.RETDESC;
			}

		}
		return result;
	}

	function editeUser( userID, userName, userPass, userPass1, userStatus, userGroups, empType, empFamily, empFirstName, empLastName, empDescription ){

		userID = arguments.userID;
		userName = arguments.userName;
		userPass = arguments.userPass;
		userPass1 = arguments.userPass1;
		userStatus = arguments.userStatus;
		userGroups  = arguments.userGroups;
		empType = arguments.empType;
		empFamily = arguments.empFamily;
		empFirstName = arguments.empFirstName;
		empLastName = arguments.empLastName;
		empDescription = arguments.empDescription;

		var result = structNew();
		result.RETVAL = 0;
		result.RETDESC = "";
		result.STRUCT = structNew(); // для валидации полей

		validator = request.factoryService.getService('Validator');
		                                                          //required                 //DB
		//var struct_ = validator.checkInput('#userName#',true,'isAllowSimbol',2,20, true, 'bbs_users', 'user_name','Логин');
		var struct_ = validator.checkInput('#userName#',true,'isAllowSimbol',2,20);
		if ( !struct_.retval ){
			structInsert(result.struct, 'userName','#struct_.retdesc#');
		}


		var struct_ = validator.checkInput('#userPass#',true,'isValidPassword',8,20);
		if ( !struct_.retval ){
			structInsert(result.struct, 'userPass','#struct_.retdesc#');
		}

		var struct_ = validator.checkInputGroup('#userPass#,#userPass1#','checkSameAs');
		if ( !struct_.retval ){	structInsert(result.struct, 'userPass1','#struct_.retdesc#');}

		var struct_ = validator.checkInput('#userStatus#',false,'isNumeric',0,2);
		if ( !struct_.retval ){
			structInsert(result.struct, 'userStatus','#struct_.retdesc#');
		}
		var struct_ = validator.checkInput('#userGroups#',false,'isNumeric',0,2);
		if ( !struct_.retval ){
			structInsert(result.struct, 'userGroups','#struct_.retdesc#');
		}
		var struct_ = validator.checkInput('#empType#',false,'checkString',0,250);
		if ( !struct_.retval ){
			structInsert(result.struct, 'empType','#struct_.retdesc#');
		}
		var struct_ = validator.checkInput('#empFamily#',false,'checkString',0,20);
		if ( !struct_.retval ){
			structInsert(result.struct, 'empFamily','#struct_.retdesc#');
		}
		var struct_ = validator.checkInput('#empFirstName#',false,'checkString',0,20);
		if ( !struct_.retval ){
			structInsert(result.struct, 'empFirstName','#struct_.retdesc#');
		}
		var struct_ = validator.checkInput('#empLastName#',false,'checkString',0,20);
		if ( !struct_.retval ){
			structInsert(result.struct, 'empLastName','#struct_.retdesc#');
		}
		var struct_ = validator.checkInput('#empDescription#',false,'checkString',0,50);
		if ( !struct_.retval ){
			structInsert(result.struct, 'empDescription','#struct_.retdesc#');
		}

		//--------------------------------------------------------------------
	        // если обнаружены ошибки
		if ( structIsEmpty(result.struct) ){

			structRegUser = instance.userDAO.updateUser( userID, userName, userPass, userStatus, userGroups, empType, empFamily, empFirstName, empLastName, empDescription );
			if (structRegUser.RETVAL == 1){
				result.RETVAL = structRegUser.RETVAL;
				result.RETDESC = structRegUser.RETDESC;
			}else {
				result.RETVAL = structRegUser.RETVAL;
				result.RETDESC = structRegUser.RETDESC;
			}

		}
		return result;
	}
}