/*
	users graphics API - сервис
*/
component displayname="usersGraphicsAPI" output="false" {

	// Псевдо конструктор
	//instance.usersGraphicsDAO = '';
	//instance.usersGraphics = '';


	instance.usersGraphicsDAO = createObject('component', 'core.db.usersGraphicsDAO' ).init();

		
	function init(){
		//setUsersGraphicsList();
		return this;
	}


	function setUsersGraphicsList(userID='', startDate, endDate){
	        instance.usersGraphics = instance.usersGraphicsDAO.readUsersGraphicsList( arguments.userID, arguments.startDate, arguments.endDate );
	}

	function getUsersGraphicsList(){
		return instance.usersGraphics;
	}

	function getUserGraphic( grID ) {
		_qUG = instance.usersGraphicsDAO.readUserGraphic( arguments.grID );
		return _qUG;
	}

	function getUserGraphics( userID , date ) {

		var qUsersGraphicsList = getUsersGraphicsList();
		qUserGraphicsList = new Query();
		qUserGraphicsList.setName("qUserGraphics");
		qUserGraphicsList.setTimeout("5");
		qUserGraphicsList.setAttributes( tableUsersGraphics = qUsersGraphicsList );
		// --------------------------------------------------------------------------------------------------------------------------
		select ="SELECT * FROM tableUsersGraphics WHERE user_id = #arguments.userID# AND gr_date = #arguments.date#";
		// --------------------------------------------------------------------------------------------------------------------------
		qUserGraphicsList.setSQL(select);

		var execute = qUserGraphicsList.execute(dbtype="query"); // вся структура и result и prefix
		var result = execute.getResult();
		//writeDump( result );
		return result; // возвращает query
	}

	function addUserGraphic( userID, grType, grDate, grStartTime, grEndTime, grStatus ){

		userID = arguments.userID;
		grType = arguments.grType;
		grDate = arguments.grDate;
		grStartTime = arguments.grStartTime;
		grEndTime = arguments.grEndTime;
		grStatus = arguments.grStatus;

		var result = structNew();
		result.RETVAL = 0;
		result.RETDESC = "";
		result.STRUCT = structNew(); // для валидации полей

		validator = request.factoryService.getService('Validator');

		var struct_ = validator.checkInput('#arguments.grType#',true,'isNumeric',1,2);
		if ( !struct_.retval ){
			structInsert(result.struct, 'grType','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.grDate#',true,'isDate',0,100);
		if ( !struct_.retval ){
			structInsert(result.struct, 'grDate','#struct_.retdesc#');
		}
		var struct_ = validator.checkInput('#arguments.grStartTime#',false,'isTime',0,100);
		if ( !struct_.retval ){
			structInsert(result.struct, 'grStartTime','#struct_.retdesc#');
		}
		var struct_ = validator.checkInput('#arguments.grEndTime#',false,'isTime',0,100);
		if ( !struct_.retval ){
			structInsert(result.struct, 'grEndTime','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.grStatus#',true,'isNumeric',1,2);
		if ( !struct_.retval ){
			structInsert(result.struct, 'grStatus','#struct_.retdesc#');
		}
		//--------------------------------------------------------------------
		rbac = request.RBAC;
		if ( !rbac.CheckAccess('usersGraphics','create') ){
			structInsert(result.struct, 'RBAC','У вас недостаточно прав!');
		}
		//--------------------------------------------------------------------

	        // если обнаружены ошибки
		if ( structIsEmpty(result.struct) ){

			structCreateUserGraphic = instance.usersGraphicsDAO.createUserGraphic( userID, grType, grDate, grStartTime, grEndTime, grStatus );

			if (structCreateUserGraphic.RETVAL == 1){
				result.RETVAL = structCreateUserGraphic.RETVAL;
				result.RETDESC = structCreateUserGraphic.RETDESC;
			}else {
				result.RETVAL = structCreateUserGraphic.RETVAL;
				result.RETDESC = structCreateUserGraphic.RETDESC;
			}

		}
		return result;
	}

	function editeUserGraphic( grID, userID, grType, grDate, grStartTime, grEndTime, grStatus ){

	        grID = arguments.grID;
		userID = arguments.userID;
		grType = arguments.grType;
		grDate = arguments.grDate;
		grStartTime = arguments.grStartTime;
		grEndTime = arguments.grEndTime;
		grStatus = arguments.grStatus;

		var result = structNew();
		result.RETVAL = 0;
		result.RETDESC = "";
		result.STRUCT = structNew(); // для валидации полей

		validator = request.factoryService.getService('Validator');

		var struct_ = validator.checkInput('#grType#',true,'isNumeric',1,2);
		if ( !struct_.retval ){
			structInsert(result.struct, 'grType','#struct_.retdesc#');
		}else{
			// передаем в функцию проверки grID и grType и grDate
			qCheck = instance.usersGraphicsDAO.checkUserGraphic( userID, grID, grType, grDate, grStartTime, grEndTime );
			//writeDump(qCheck);
			if (qCheck.recordcount != 0){
				structInsert(result.struct, 'grType','У врача на это время записаны пациенты. Кол-во пациентов: <b>#qCheck.recordcount#</b>.');
			}
		}

		var struct_ = validator.checkInput('#grDate#',true,'isDate',0,100);
		if ( !struct_.retval ){
			structInsert(result.struct, 'grDate','#struct_.retdesc#');
		}
		var struct_ = validator.checkInput('#grStartTime#',false,'isTime',0,100);
		if ( !struct_.retval ){
			structInsert(result.struct, 'grStartTime','#struct_.retdesc#');
		}
		var struct_ = validator.checkInput('#grEndTime#',false,'isTime',0,100);
		if ( !struct_.retval ){
			structInsert(result.struct, 'grEndTime','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#grStatus#',true,'isNumeric',1,2);
		if ( !struct_.retval ){
			structInsert(result.struct, 'grStatus','#struct_.retdesc#');
		}
		//--------------------------------------------------------------------

		//--------------------------------------------------------------------
		rbac = request.RBAC;
		if ( !rbac.CheckAccess('usersGraphics','update') ){
			structInsert(result.struct, 'RBAC','У вас недостаточно прав!');
		}
		//--------------------------------------------------------------------

	        // если обнаружены ошибки
		if ( structIsEmpty(result.struct) ){

			structUpdateUserGraphic = instance.usersGraphicsDAO.updateUserGraphic( grID, userID, grType, grDate, grStartTime, grEndTime, grStatus );

			if (structUpdateUserGraphic.RETVAL == 1){
				result.RETVAL = structUpdateUserGraphic.RETVAL;
				result.RETDESC = structUpdateUserGraphic.RETDESC;
			}else {
				result.RETVAL = structUpdateUserGraphic.RETVAL;
				result.RETDESC = structUpdateUserGraphic.RETDESC;
			}

		}
		return result;
	}

	function getMemento(){
		return instance;
	}


}