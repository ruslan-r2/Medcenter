/*
	users interest API - сервис
*/
component displayname="usersInterestAPI" output="false" {

	// Псевдо конструктор
	instance.usersInterestDAO = '';
	instance.usersInterest = '';


	instance.usersInterestDAO = createObject('component', 'core.db.usersInterestDAO' ).init();

		
	function init(){
		setUsersInterestList();
		return this;
	}


	function setUsersInterestList(){
	        instance.usersInterest = instance.usersInterestDAO.readUsersInterestList();
	}

	function getUsersInterestList(){
		return instance.usersInterest;
	}

	function getUserInterest( userID, stID='' ) {

		var qUsersInterestList = instance.usersInterest;
		qUserInterestList = new Query();
		qUserInterestList.setName("qUserInterestList");
		qUserInterestList.setTimeout("5");
		qUserInterestList.setAttributes( tableUsersInterest = qUsersInterestList );
		// --------------------------------------------------------------------------------------------------------------------------
		if (arguments.stID == ''){
			var select ="SELECT * FROM tableUsersInterest WHERE user_id = '#arguments.userID#'";
		}else{
			var select ="SELECT * FROM tableUsersInterest WHERE user_id = #arguments.userID# AND st_id = #arguments.stID#";
		}

		// --------------------------------------------------------------------------------------------------------------------------
		qUserInterestList.setSQL(select);

		var execute = qUserInterestList.execute(dbtype="query"); // вся структура и result и prefix
		var result = execute.getResult();
		//writeDump( result );
		return result; // возвращает query
	}

	function addUserInterest( userID, stID, uiType, uiValue, uiStatus ){

		userID = arguments.userID;
		stID = arguments.stID;
		uiType = arguments.uiType;
		uiValue = arguments.uiValue;
		uiStatus = arguments.uiStatus;

		var result = structNew();
		result.RETVAL = 0;
		result.RETDESC = "";
		result.STRUCT = structNew(); // для валидации полей

		validator = request.factoryService.getService('Validator');

		var struct_ = validator.checkInput('#arguments.uiType#',true,'isNumeric',1,2);
		if ( !struct_.retval ){
			structInsert(result.struct, 'uiType','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.uiValue#',true,'isNumeric',0,2);
		if ( !struct_.retval ){
			structInsert(result.struct, 'uiValue','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.uiStatus#',true,'isNumeric',1,2);
		if ( !struct_.retval ){
			structInsert(result.struct, 'uiStatus','#struct_.retdesc#');
		}
		//--------------------------------------------------------------------

	        // если обнаружены ошибки
		if ( structIsEmpty(result.struct) ){

			structCreateUserInterest = instance.usersInterestDAO.createUserInterest( userID, stID, uiType, uiValue, uiStatus );

			if (structCreateUserInterest.RETVAL == 1){
				result.RETVAL = structCreateUserInterest.RETVAL;
				result.RETDESC = structCreateUserInterest.RETDESC;
			}else {
				result.RETVAL = structCreateUserInterest.RETVAL;
				result.RETDESC = structCreateUserInterest.RETDESC;
			}

		}
		return result;
	}

	function editeUserInterest( uiID, userID, stID, uiType, uiValue, uiStatus ){

	        uiID = arguments.uiID;
		userID = arguments.userID;
		stID = arguments.stID;
		uiType = arguments.uiType;
		uiValue = arguments.uiValue;
		uiStatus = arguments.uiStatus;

		var result = structNew();
		result.RETVAL = 0;
		result.RETDESC = "";
		result.STRUCT = structNew(); // для валидации полей

		validator = request.factoryService.getService('Validator');

		var struct_ = validator.checkInput('#arguments.uiType#',true,'isNumeric',1,2);
		if ( !struct_.retval ){
			structInsert(result.struct, 'uiType','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.uiValue#',false,'isNumeric',0,2);
		if ( !struct_.retval ){
			structInsert(result.struct, 'uiValue','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.uiStatus#',true,'isNumeric',1,2);
		if ( !struct_.retval ){
			structInsert(result.struct, 'uiStatus','#struct_.retdesc#');
		}
		//--------------------------------------------------------------------

	        // если обнаружены ошибки
		if ( structIsEmpty(result.struct) ){

			structUpdateUserInterest = instance.usersInterestDAO.updateUserInterest( uiID, userID, stID, uiType, uiValue, uiStatus );

			if (structUpdateUserInterest.RETVAL == 1){
				result.RETVAL = structUpdateUserInterest.RETVAL;
				result.RETDESC = structUpdateUserInterest.RETDESC;
			}else {
				result.RETVAL = structUpdateUserInterest.RETVAL;
				result.RETDESC = structUpdateUserInterest.RETDESC;
			}

		}
		return result;
	}

	function getMemento(){
		return instance;
	}


}