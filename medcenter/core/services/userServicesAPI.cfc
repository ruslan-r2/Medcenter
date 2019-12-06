/*
	servicesAPI - список услуг.
*/

component attributeName='usersServicesAPI' output='false'{

	// Псевдо конструктор
	instance.userServicesDAO = createObject('component', 'core.db.userServicesDAO' ).Init();

	//instance.services = {};

	function init(){
		return this;
	}

	// список пользовательских групп

	function getEmpServices( empType ){
		qEmpServices = instance.userServicesDAO.readEmpServices( arguments.empType );
		return qEmpServices;
	}

	function getReceptionServices( rpID ){
		qRServices = instance.userServicesDAO.readReceptionServices( arguments.rpID );
		return qRServices;
	}

	function getReceptionService( svID ){
		qRService = instance.userServicesDAO.readReceptionService( arguments.svID );
		return qRService;
	}

	function deleteReceptionService( rpID, svID ){
		rpID = arguments.rpID;
		svID = arguments.svID;

		var result = structNew();
		result.RETVAL = 0;
		result.RETDESC = "";
		result.STRUCT = structNew(); // для валидации полей

		factoryService = request.factoryService;
		var qReception = factoryService.getService('userReceptionAPI').getReception(rpID);
		if ( qReception.rp_status > 1 AND qReception.user_id != session.sessionStorage.getObject('user').getUserId() ){
			structInsert(result.struct, 'RBAC','У Вас нет прав доступа. Приём начат и вы не можете вносить изменения!');
		}else{
			if (qReception.rp_status == 3 AND DateCompare(DateAdd("d", +7, qReception.rp_date), now(),"d") == -1){
				structInsert(result.struct, 'rpStatus','Данную запись редактировать нельзя, приём окончен! #DateCompare(DateAdd("d", +7, qReception.rp_date), now(),"d")#');
			}
		}

	        // если обнаружены ошибки
		if ( structIsEmpty(result.struct) ){
			structDeleteReceptionService = instance.userServicesDAO.deleteReceptionService( svID );

			if (structDeleteReceptionService.RETVAL == 1){
				result.RETVAL = structDeleteReceptionService.RETVAL;
				result.RETDESC = structDeleteReceptionService.RETDESC;
			}else {
				result.RETVAL = structDeleteReceptionService.RETVAL;
				result.RETDESC = structDeleteReceptionService.RETDESC;
			}
                }
		return result;
	}

	function addReceptionService( rpID, plsID, svPrice, svCost, svName, svTime, svDescription, svStatus, stID, plsShablon, userInterest ){

		rpID = arguments.rpID;
		plsID = arguments.plsID;
		svPrice = arguments.svPrice;
		svCost = arguments.svCost;
		svName = arguments.svName;
		svTime = arguments.svTime;
		svDescription = arguments.svDescription;
		svStatus = arguments.svStatus;
		stID = arguments.stID;
		plsShablon = arguments.plsShablon;
		userInterest = arguments.userInterest;
		

		var result = structNew();
		result.RETVAL = 0;
		result.RETDESC = "";
		result.STRUCT = structNew(); // для валидации полей

		factoryService = request.factoryService;
		var qReception = factoryService.getService('userReceptionAPI').getReception(rpID);
		if ( qReception.rp_status > 1 AND qReception.user_id != session.sessionStorage.getObject('user').getUserId() ){
			structInsert(result.struct, 'RBAC','У Вас нет прав доступа. Приём начат и вы не можете вносить изменения!');
		}else{
			if (qReception.rp_status == 3 AND DateCompare(DateAdd("d", +7, qReception.rp_date), now(),"d") == -1){
				structInsert(result.struct, 'rpStatus','Данную запись редактировать нельзя, приём окончен! #DateCompare(DateAdd("d", +7, qReception.rp_date), now(),"d")#');
			}
		}

		//--------------------------------------------------------------------

	        // если обнаружены ошибки
		if ( structIsEmpty(result.struct) ){
			structCreateReceptionService = instance.userServicesDAO.createReceptionService( rpID, plsID, svPrice, svCost, svName, svTime, svDescription, svStatus, stID, plsShablon, userInterest );

			if (structCreateReceptionService.RETVAL == 1){
				result.RETVAL = structCreateReceptionService.RETVAL;
				result.RETDESC = structCreateReceptionService.RETDESC;
			}else {
				result.RETVAL = structCreateReceptionService.RETVAL;
				result.RETDESC = structCreateReceptionService.RETDESC;
			}
                }
		return result;
	}

	function editeReceptionService( rpID, svID, plsShablon ){

		rpID = arguments.rpID;
		svID = arguments.svID;
		ptAnamnez = arguments.plsShablon;

		var result = structNew();
		result.RETVAL = 0;
		result.RETDESC = "";
		result.STRUCT = structNew(); // для валидации полей


		factoryService = request.factoryService;
		var qReception = factoryService.getService('userReceptionAPI').getReception(rpID);
		if ( qReception.user_id != session.sessionStorage.getObject('user').getUserId() ){
			structInsert(result.struct, 'RBAC','У Вас нет прав доступа.');
		}else{
			if (qReception.rp_status == 3 AND DateCompare(DateAdd("d", +7, qReception.rp_date), now(),"d") == -1){
				structInsert(result.struct, 'rpStatus','Данную запись редактировать нельзя, приём окончен!');
			}else{
				validator = request.factoryService.getService('Validator');
				for (var i=1; i<=arrayLen(plsShablon); i++){
					var struct_ = validator.checkInput('#plsShablon[i].data#',false,'checkString',0,2000);
					if ( !struct_.retval ){
						structInsert(result.struct, '#plsShablon[i].name#','#struct_.retdesc#');
					}
				}
			}
		}
		//--------------------------------------------------------------------

	        // если обнаружены ошибки
		if ( structIsEmpty(result.struct) ){

			plsShablon = SerializeJSON(plsShablon);
			//writeDump(plsShablon);
			structEditeReceptionService = instance.userServicesDAO.updateReceptionService(svID,plsShablon);
			if (structEditeReceptionService.RETVAL == 1){
				result.RETVAL = structEditeReceptionService.RETVAL;
				result.RETDESC = structEditeReceptionService.RETDESC;
			}else {
				result.RETVAL = structEditeReceptionService.RETVAL;
				result.RETDESC = structEditeReceptionService.RETDESC;
			}

		}
		return result;
	}

	function editeReceptionServicePrice( svID, svPrice, svPriceOt, svPriceDo, userInterest ){

		svID = arguments.svID;
		svPrice = arguments.svPrice;
		svPriceOt = arguments.svPriceOt;
		svPriceDo = arguments.svPriceDo;
		userInterest = arguments.userInterest;

		var result = structNew();
		result.RETVAL = 0;
		result.RETDESC = "";
		result.STRUCT = structNew(); // для валидации полей

		// проверку сделать статуса услуги - оплачена или нет
		factoryService = request.factoryService;
		qService = factoryService.getService( 'userServicesAPI' ).getReceptionService( svID );
		if ( qService.sv_status is 2) {
			structInsert(result.struct, 'svStatus','Услуга оплачена! Редактировать нельзя!');

		}else{
			//
			validator = request.factoryService.getService('Validator');
			var struct_ = validator.checkInput('#svPrice#',false,'isNumeric',0,10);
			if ( !struct_.retval ){
				structInsert(result.struct, 'svPrice','#struct_.retdesc#');
			}
			// сделать проверку чтобы за границы диапазона цена не выходила.
			if ( svPriceDo == ''){
				structInsert(result.struct, 'svPrice','Для данной услуги цена фиксированная и менять её нельзя!');
			}else if ( svPrice < svPriceOt OR svPrice > svPriceDo ){
				structInsert(result.struct, 'svPrice','Цена для данной услуги может быть только от #svPriceOt# до #svPriceDo#');
			}
		}

		//--------------------------------------------------------------------

	        // если обнаружены ошибки
		if ( structIsEmpty(result.struct) ){

			structEditeReceptionServicePrice = instance.userServicesDAO.updateReceptionServicePrice(svID,svPrice, userInterest);
			if (structEditeReceptionServicePrice.RETVAL == 1){
				result.RETVAL = structEditeReceptionServicePrice.RETVAL;
				result.RETDESC = structEditeReceptionServicePrice.RETDESC;
			}else {
				result.RETVAL = structEditeReceptionServicePrice.RETVAL;
				result.RETDESC = structEditeReceptionServicePrice.RETDESC;
			}

		}
		return result;
	}

	function editeReceptionServiceStatus( svIDs, svStatus ){

		svIDs = arguments.svIDs;
		svStatus = arguments.svStatus;

		var result = structNew();
		result.RETVAL = 0;
		result.RETDESC = "";
		result.STRUCT = structNew(); // для валидации полей

		// проверку сделать статуса услуги - оплачена или нет
		//factoryService = request.factoryService;
		//qService = factoryService.getService( 'userServicesAPI' ).getReceptionService( svID );
		//if ( qService.sv_status is 2) {
		//	structInsert(result.struct, 'svStatus','Услуга оплачена! Редактировать нельзя!');

		//}else{
			//
			validator = request.factoryService.getService('Validator');
			var struct_ = validator.checkInput('#svStatus#',false,'isNumeric',0,10);
			if ( !struct_.retval ){
				structInsert(result.struct, 'svStatus','#struct_.retdesc#');
			}
			if ( svIDs == ''){
				structInsert(result.struct, 'svIDs','Нужно выбрать услугу! #now()#');
			}
		//}
		//--------------------------------------------------------------------

	        // если обнаружены ошибки
		if ( structIsEmpty(result.struct) ){

			structEditeReceptionServiceStatus = instance.userServicesDAO.updateReceptionServiceStatus(svIDs,svStatus);
			if (structEditeReceptionServiceStatus.RETVAL == 1){
				result.RETVAL = structEditeReceptionServiceStatus.RETVAL;
				result.RETDESC = structEditeReceptionServiceStatus.RETDESC;
			}else {
				result.RETVAL = structEditeReceptionServiceStatus.RETVAL;
				result.RETDESC = structEditeReceptionServiceStatus.RETDESC;
			}

		}
		return result;
	}


	function getMemento(){
		return instance;
	}
}