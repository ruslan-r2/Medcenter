/*
	servicesAPI - список услуг.
*/

component attributeName='userReceptionAPI' output='false'{

	// Псевдо конструктор
	instance.userReceptionDAO = createObject('component', 'core.db.userReceptionDAO' ).Init();
	instance.userServicesDAO = createObject('component', 'core.db.userServicesDAO' ).Init();

	//instance.services = {};

	function init(){
		return this;
	}

	function getReception( rpID ){
		qReception = instance.userReceptionDAO.readReception( arguments.rpID );
		return qReception;
	}

	function getUserReception( userID, date ){
		qUserReception = instance.userReceptionDAO.readUserReception( arguments.userID, arguments.date );
		return qUserReception;
	}

	function checkUserReception( userID, date, starttime, endtime ){
		qUserReception = instance.userReceptionDAO.checkUserReception( arguments.userID, arguments.date, arguments.starttime, arguments.endtime );
		return qUserReception;
	}

	function addUserReception( userID, rpDate, rpStartTime, rpEndTime, rpStatus, grStartTime, grEndTime ){

		userID = arguments.userID;
		rpDate = arguments.rpDate;
		rpStartTime = createODBCTime(arguments.rpStartTime);
		rpEndTime = createODBCTime(arguments.rpEndTime);
		rpStatus = arguments.rpStatus;
		grStartTime = createODBCTime(arguments.grStartTime);
		grEndTime = createODBCTime(arguments.grEndTime);

		var result = structNew();
		result.RETVAL = 0;
		result.RETDESC = "";
		result.STRUCT = structNew(); // для валидации полей

		validator = request.factoryService.getService('Validator');

		var struct_ = validator.checkInput('#arguments.rpDate#',true,'isDate',0,100);
		if ( !struct_.retval ){
			structInsert(result.struct, 'rpDate','#struct_.retdesc#');
		}
		var struct_ = validator.checkInput('#arguments.rpStartTime#',false,'isTime',0,100);
		if ( !struct_.retval ){
			structInsert(result.struct, 'rpStartTime','#struct_.retdesc#');
		}

		_grStartTime = TimeFormat(grStartTime, "HH:mm:ss");
		_rpStartTime = TimeFormat(rpStartTime, "HH:mm:ss");
		_dateCompare = DateCompare("#_grStartTime#", "#_rpStartTime#" , "n");
		if ( _dateCompare == 1 ){
			structInsert(result.struct, '_rpStartTime','Врач не принемает, ещё рано!');
		}

		var struct_ = validator.checkInput('#arguments.rpEndTime#',false,'isTime',0,100);
		if ( !struct_.retval ){
			structInsert(result.struct, 'rpEndTime','#struct_.retdesc#');
		}

		_grEndTime = TimeFormat(grEndTime, "HH:mm:ss");
		_rpEndTime = TimeFormat(rpEndTime, "HH:mm:ss");
		_dateCompare = DateCompare("#_rpEndTime#", "#_grEndTime#" , "n");
		if ( _dateCompare == 1 ){
			structInsert(result.struct, '_rpEndTime','Врач не принемает, уже поздно!');
		}

		var struct_ = validator.checkInput('#arguments.rpStatus#',true,'isNumeric',1,2);
		if ( !struct_.retval ){
			structInsert(result.struct, 'rpStatus','#struct_.retdesc#');
		}else if( DateCompare( _rpStartTime, _rpEndTime ) is 0 OR DateCompare( _rpStartTime, _rpEndTime ) is 1){
			structInsert(result.struct, 'Time','Начало и окончание приема не может быть равно! Дата окончания не должна быть меньше начала приёма!');
		}else{
			// ------------------------------------------------------------------
			// дописать ещё две проверки, дата должна быть не раньше сегодня и
			// начало приёма не должно быть больше окончания приёма !!!!!!!!!!!!
			checkUserReception = instance.userReceptionDAO.checkUserReception( '', userID, rpDate, rpStartTime, rpEndTime );
			//writeDump(checkUserReception);
			if (checkUserReception.recordcount){
				structInsert(result.struct, 'Time','Приём пересекается с другим!');
			}
		}
		//--------------------------------------------------------------------

	        // если обнаружены ошибки
		if ( structIsEmpty(result.struct) ){

			structCreateUserReception = instance.userReceptionDAO.createUserReception( userID, rpDate, rpStartTime, rpEndTime, rpStatus );
			if (structCreateUserReception.RETVAL == 1){
				result.RETVAL = structCreateUserReception.RETVAL;
				result.RETDESC = structCreateUserReception.RETDESC;
			}else {
				result.RETVAL = structCreateUserReception.RETVAL;
				result.RETDESC = structCreateUserReception.RETDESC;
			}

		}
		return result;
	}

	function _editeUserReception( rpID, userID, rpDate, rpStartTime, rpEndTime, rpDescription, rpStatus, grStartTime, grEndTime ){

		rpID = arguments.rpID;
		userID = arguments.userID;
		rpDate = arguments.rpDate;
		rpStartTime = createODBCTime(arguments.rpStartTime);
		//rpEndTime = createODBCTime(dateAdd('s', +1, arguments.rpEndTime));
		rpEndTime = createODBCTime(arguments.rpEndTime);
		rpDescription = arguments.rpDescription;
		rpStatus = arguments.rpStatus;
		grStartTime = createODBCTime(arguments.grStartTime);
		grEndTime = createODBCTime(arguments.grEndTime);

		var result = structNew();
		result.RETVAL = 0;
		result.RETDESC = "";
		result.STRUCT = structNew(); // для валидации полей

		validator = request.factoryService.getService('Validator');

		var struct_ = validator.checkInput('#arguments.rpDate#',true,'isDate',0,100);
		if ( !struct_.retval ){
			structInsert(result.struct, 'rpDate','#struct_.retdesc#');
		}
		var struct_ = validator.checkInput('#arguments.rpStartTime#',false,'isTime',0,100);
		if ( !struct_.retval ){
			structInsert(result.struct, 'rpStartTime','#struct_.retdesc#');
		}

		_grStartTime = TimeFormat(grStartTime, "HH:mm:ss");
		_rpStartTime = TimeFormat(rpStartTime, "HH:mm:ss");
		_dateCompare = DateCompare("#_grStartTime#", "#_rpStartTime#");
		if ( _dateCompare == 1 ){
			structInsert(result.struct, '_rpStartTime','Врач не принемает, ещё рано!');
		}

		var struct_ = validator.checkInput('#arguments.rpEndTime#',false,'isTime',0,100);
		if ( !struct_.retval ){
			structInsert(result.struct, 'rpEndTime','#struct_.retdesc#');
		}

		_grEndTime = TimeFormat(grEndTime, "HH:mm:ss");
		_rpEndTime = TimeFormat(rpEndTime, "HH:mm:ss");
		_dateCompare = DateCompare("#_rpEndTime#", "#_grEndTime#");
		if ( _dateCompare == 1 ){
			structInsert(result.struct, '_rpEndTime','Врач не принемает, уже поздно!');
		}

		var struct_ = validator.checkInput('#arguments.rpDescription#',false,'checkString',0,250);
		if ( !struct_.retval ){
			structInsert(result.struct, 'rpDescription','#struct_.retdesc#');
		}

		if ( arguments.rpStatus > 1 AND userID != session.sessionStorage.getObject('user').getUserId() ){
			structInsert(result.struct, 'RBAC','У Вас нет прав доступа.');
		}

		if ( arguments.rpStatus == 3 AND DateCompare(DateAdd("d", +7, rpDate), now(),"d") == -1){
			structInsert(result.struct, 'rpStatus','Данную запись редактировать нельзя, приём окончен! #DateCompare(DateAdd("d", +7, rpDate), now(),"d")#');

		}else{
			var struct_ = validator.checkInput('#arguments.rpStatus#',true,'isNumeric',1,2);
			if ( !struct_.retval ){
				structInsert(result.struct, 'rpStatus','#struct_.retdesc#');
			}else if( DateCompare( _rpStartTime, _rpEndTime ) is 0 OR DateCompare( _rpStartTime, _rpEndTime ) is 1){
				structInsert(result.struct, 'Time','Начало и окончание приема не может быть равно! Дата окончания не должна быть меньше начала приёма!');
			}else{
				// ------------------------------------------------------------------
				// дописать ещё две проверки, дата должна быть не раньше сегодня и
				// начало приёма не должно быть больше окончания приёма !!!!!!!!!!!!
				checkUserReception = instance.userReceptionDAO.checkUserReception( rpID, userID, rpDate, rpStartTime, rpEndTime );
				//writeDump(checkUserReception);
				if (checkUserReception.recordcount){
					structInsert(result.struct, 'Time','Приём пересекается с другим!');
				}
				//--------------------------------------------------------------------
			}
			//writeDump( _rpStartTime );
			//writeDump( _rpEndTime );

		}


	        // если обнаружены ошибки
		if ( structIsEmpty(result.struct) ){

			structUpdateUserReception = instance.userReceptionDAO._updateUserReception( rpID, userID, rpDate, rpStartTime, rpEndTime, rpDescription, rpStatus );
			if (structUpdateUserReception.RETVAL == 1){
				result.RETVAL = structUpdateUserReception.RETVAL;
				result.RETDESC = structUpdateUserReception.RETDESC;
			}else {
				result.RETVAL = structUpdateUserReception.RETVAL;
				result.RETDESC = structUpdateUserReception.RETDESC;
			}

		}
		return result;
	}

	function editeUserReception( rpID, ptID ){

	        rpID = arguments.rpID;
		ptID = arguments.ptID;

		var result = structNew();
		result.RETVAL = 0;
		result.RETDESC = "";
		result.STRUCT = structNew(); // для валидации полей


		validator = request.factoryService.getService('Validator');

		var struct_ = validator.checkInput('#arguments.rpID#',true,'isNumeric',1,1000000);
		if ( !struct_.retval ){
			structInsert(result.struct, 'rpID','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.ptID#',true,'isNumeric',1,1000000);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptID','#struct_.retdesc#');
		}

		factoryService = request.factoryService;
		var qReception = factoryService.getService('userReceptionAPI').getReception(rpID);
		if (qReception.rp_status == 3 AND DateCompare(DateAdd("d", +7, qReception.rp_date), now(),"d") == -1){
			structInsert(result.struct, 'rpStatus','Данную запись редактировать нельзя, приём окончен! #DateCompare(DateAdd("d", +7, rpDate), now(),"d")#');
		}

	        // если обнаружены ошибки
		if ( structIsEmpty(result.struct) ){

			structUpdateUserReception = instance.userReceptionDAO.updateUserReception( rpID, ptID );

			if (structUpdateUserReception.RETVAL == 1){
				result.RETVAL = structUpdateUserReception.RETVAL;
				result.RETDESC = structUpdateUserReception.RETDESC;
			}else {
				result.RETVAL = structUpdateUserReception.RETVAL;
				result.RETDESC = structUpdateUserReception.RETDESC;
			}

		}
		return result;
	}

	function startEndUserReception( rpID, rpStatus, user_id1, user_id2 ){

	        rpID = arguments.rpID;
		rpStatus = arguments.rpStatus;
		user_id1 = arguments.user_id1;
		user_id2 = arguments.user_id2;

		var result = structNew();
		result.RETVAL = 0;
		result.RETDESC = "";
		result.STRUCT = structNew(); // для валидации полей

		validator = request.factoryService.getService('Validator');

		var struct_ = validator.checkInput('#arguments.rpID#',true,'isNumeric',1,1000000);
		if ( !struct_.retval ){
			structInsert(result.struct, 'rpID','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.rpStatus#',true,'isNumeric',1,1000000);
		if ( !struct_.retval ){
			structInsert(result.struct, 'rpStatus','#struct_.retdesc#');
		}

		if ( user_id1 != user_id2 ){
			structInsert(result.struct, 'RBAC','У Вас нет прав доступа.');
		}

	        // если обнаружены ошибки
		if ( structIsEmpty(result.struct) ){

			structUpdateUserReception = instance.userReceptionDAO.startEndUserReception( rpID, rpStatus );

			if (structUpdateUserReception.RETVAL == 1){
				result.RETVAL = structUpdateUserReception.RETVAL;
				result.RETDESC = structUpdateUserReception.RETDESC;
			}else {
				result.RETVAL = structUpdateUserReception.RETVAL;
				result.RETDESC = structUpdateUserReception.RETDESC;
			}

		}
		return result;
	}

	function deleteUserReception( rpID ){
		rpID = arguments.rpID;

		var result = structNew();
		result.RETVAL = 0;
		result.RETDESC = "";
		result.STRUCT = structNew(); // для валидации полей

	        // если обнаружены ошибки
		if ( structIsEmpty(result.struct) ){

			// в некоторых случаях может произойти перезапись, это плохо
			structDeleteUserReceptionSv = instance.userServicesDAO.deleteReceptionServices( rpID );
			if (structDeleteUserReceptionSv.RETVAL == 1){
				result.RETVAL = structDeleteUserReceptionSv.RETVAL;
				result.RETDESC = structDeleteUserReceptionSv.RETDESC;
			}else {
				result.RETVAL = structDeleteUserReceptionSv.RETVAL;
				result.RETDESC = structDeleteUserReceptionSv.RETDESC;
			}

			structDeleteUserReception = instance.userReceptionDAO.deleteUserReception( rpID );
			if (structDeleteUserReception.RETVAL == 1){
				result.RETVAL = structDeleteUserReception.RETVAL;
				result.RETDESC = structDeleteUserReception.RETDESC;
			}else {
				result.RETVAL = structDeleteUserReception.RETVAL;
				result.RETDESC = structDeleteUserReception.RETDESC;
			}
                }
		return result;
	}


	function getMemento(){
		return instance;
	}
}