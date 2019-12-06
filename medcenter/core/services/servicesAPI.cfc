/*
	servicesAPI - список услуг.
*/

component attributeName='servicesAPI' output='false'{

	// Псевдо конструктор
	instance.servicesDAO = createObject('component', 'core.db.servicesDAO' ).Init();

	instance.services = {};

	function init(){
		//setServicesList();
		return this;
	}

	// список пользовательских групп
	//function setServicesList(){
	//	qServices = instance.servicesDAO.readServiceList();
	//	instance.services = qServices;
	//}

	function getServicesList(sortBy,emptID,stID){
		qServices = instance.servicesDAO.readServiceList(arguments.sortBy,arguments.emptID,arguments.stID);
		return qServices;
		//return instance.services;
	}

	function getService( plsid ){
		qService = instance.servicesDAO.readService( arguments.plsid );
		return qService;
	}

	function addService( plsName, plsDescription, plsShablon, plsPriceOt, plsPriceDo, plsCost, emptID, stID, plsStatus, plsTime ){

		plsName = arguments.plsName;
		plsDescription = arguments.plsDescription;
		plsShablon = arguments.plsShablon;
		plsPriceOt = arguments.plsPriceOt;
		plsPriceDo = arguments.plsPriceDo;
		plsCost = arguments.plsCost;
		emptID = arguments.emptID;
		stID = arguments.stID;
		plsStatus = arguments.plsStatus;
		plsTime = arguments.plsTime;

		var result = structNew();
		result.RETVAL = 0;
		result.RETDESC = "";
		result.STRUCT = structNew(); // для валидации полей

		validator = request.factoryService.getService('Validator');
		                                               //required
		var struct_ = validator.checkInput('#plsName#',true,'checkString',2,250);
		if ( !struct_.retval ){
			structInsert(result.struct, 'plsName','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.plsDescription#',false,'checkString',0,250);
		if ( !struct_.retval ){
			structInsert(result.struct, 'plsDescription','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.plsShablon#',false,'checkString',0,10000);
		if ( !struct_.retval ){
			structInsert(result.struct, 'plsShablon','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.plsPriceOt#',true,'isNumeric',1,10);
		if ( !struct_.retval ){
			structInsert(result.struct, 'plsPriceOt','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.plsPriceDo#',false,'isNumeric',0,10);
		if ( !struct_.retval ){
			structInsert(result.struct, 'plsPriceDo','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.plsCost#',true,'isNumeric',1,10);
		if ( !struct_.retval ){
			structInsert(result.struct, 'plsCost','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.emptID#',true,'isNumeric',1,3);
		if ( !struct_.retval ){
			structInsert(result.struct, 'emptID','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.stID#',true,'isNumeric',1,3);
		if ( !struct_.retval ){
			structInsert(result.struct, 'stID','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.plsStatus#',false,'isNumeric',1,2);
		if ( !struct_.retval ){
			structInsert(result.struct, 'plsStatus','#struct_.retdesc#');
		}
		var struct_ = validator.checkInput('#arguments.plsTime#',true,'checkString',1,10);
		if ( !struct_.retval ){
			structInsert(result.struct, 'plsTime','#struct_.retdesc#');
		}
		//--------------------------------------------------------------------
		rbac = request.RBAC;
		if ( !rbac.CheckAccess('services','create') ){
			structInsert(result.struct, 'RBAC','У вас недостаточно прав!');
		}
		//--------------------------------------------------------------------
	        // если обнаружены ошибки
		if ( structIsEmpty(result.struct) ){

			structCreateService = instance.servicesDAO.createService( plsName, plsDescription, plsPriceOt, plsPriceDo, plsCost, emptID, stID, plsStatus, plsTime, plsShablon );

			if (structCreateService.RETVAL == 1){
				result.RETVAL = structCreateService.RETVAL;
				result.RETDESC = structCreateService.RETDESC;
			}else {
				result.RETVAL = structCreateService.RETVAL;
				result.RETDESC = structCreateService.RETDESC;
			}

		}
		return result;
	}

	function editeService( plsID, plsName, plsDescription, plsShablon, plsPriceOt, plsPriceDo, plsCost, emptID, stID, plsStatus, plsTime ){

	        plsID = arguments.plsID;
		plsName = arguments.plsName;
		plsDescription = arguments.plsDescription;
		plsShablon = arguments.plsShablon;
		plsPriceOt = arguments.plsPriceOt;
		plsPriceDo = arguments.plsPriceDo;
		plsCost = arguments.plsCost;
		emptID = arguments.emptID;
		stID = arguments.stID;
		plsStatus = arguments.plsStatus;
		plsTime = arguments.plsTime;

		var result = structNew();
		result.RETVAL = 0;
		result.RETDESC = "";
		result.STRUCT = structNew(); // для валидации полей

		validator = request.factoryService.getService('Validator');
		                                                 //required                 //DB
		var struct_ = validator.checkInput('#plsName#',true,'checkString',2,250 );
		if ( !struct_.retval ){
			structInsert(result.struct, 'plsName','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.plsDescription#',false,'checkString',0,250);
		if ( !struct_.retval ){
			structInsert(result.struct, 'plsDescription','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.plsShablon#',false,'checkString',0,10000);
		if ( !struct_.retval ){
			structInsert(result.struct, 'plsShablon','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.plsPriceOt#',true,'isNumeric',1,10);
		if ( !struct_.retval ){
			structInsert(result.struct, 'plsPriceOt','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.plsPriceDo#',false,'isNumeric',0,10);
		if ( !struct_.retval ){
			structInsert(result.struct, 'plsPriceDo','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.plsCost#',true,'isNumeric',1,10);
		if ( !struct_.retval ){
			structInsert(result.struct, 'plsCost','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.emptID#',true,'isNumeric',0,3);
		if ( !struct_.retval ){
			structInsert(result.struct, 'emptID','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.stID#',true,'isNumeric',0,3);
		if ( !struct_.retval ){
			structInsert(result.struct, 'stID','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.plsStatus#',false,'isNumeric',1,2);
		if ( !struct_.retval ){
			structInsert(result.struct, 'plsStatus','#struct_.retdesc#');
		}
		var struct_ = validator.checkInput('#arguments.plsTime#',true,'checkString',1,10);
		if ( !struct_.retval ){
			structInsert(result.struct, 'plsTime','#struct_.retdesc#');
		}
		//--------------------------------------------------------------------
		rbac = request.RBAC;
		if ( !rbac.CheckAccess('services','update') ){
			structInsert(result.struct, 'RBAC','У вас недостаточно прав!');
		}
		//--------------------------------------------------------------------
	        // если обнаружены ошибки
		if ( structIsEmpty(result.struct) ){

			structUpdateService = instance.servicesDAO.updateService( plsID, plsName, plsDescription, plsPriceOt, plsPriceDo, plsCost, emptID, stID, plsStatus, plsTime, plsShablon );

			if (structUpdateService.RETVAL == 1){
				result.RETVAL = structUpdateService.RETVAL;
				result.RETDESC = structUpdateService.RETDESC;
			}else {
				result.RETVAL = structUpdateService.RETVAL;
				result.RETDESC = structUpdateService.RETDESC;
			}

		}
		return result;
	}

	function getMemento(){
		return instance;
	}
}