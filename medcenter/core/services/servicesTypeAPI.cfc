/*
	servicesAPI - список услуг.
*/

component attributeName='servicesTypeAPI' output='false'{

	// Псевдо конструктор
	instance.servicesTypeDAO = createObject('component', 'core.db.servicesTypeDAO' ).Init();

	instance.servicesType = {};

	function init(){
		setServicesTypeList();
		return this;
	}

	// список пользовательских групп
	function setServicesTypeList(){
		qServicesType = instance.servicesTypeDAO.readServiceTypeList();
		instance.servicesType = qServicesType;
	}
	function getServicesTypeList() { return instance.servicesType; }

	function getServiceType( stid ){
		qServiceType = instance.servicesTypeDAO.readServiceType( arguments.stid );
		return qServiceType;
	}

	function addServiceType( stName, stDescription, stStatus ){

		stName = arguments.stName;
		stDescription = arguments.stDescription;
		stStatus = arguments.stStatus;

		var result = structNew();
		result.RETVAL = 0;
		result.RETDESC = "";
		result.STRUCT = structNew(); // для валидации полей

		validator = request.factoryService.getService('Validator');
		                                               //required
		var struct_ = validator.checkInput('#stName#',true,'checkString',2,50);
		if ( !struct_.retval ){
			structInsert(result.struct, 'stName','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.stDescription#',false,'checkString',0,250);
		if ( !struct_.retval ){
			structInsert(result.struct, 'stDescription','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.stStatus#',false,'isNumeric',1,2);
		if ( !struct_.retval ){
			structInsert(result.struct, 'stStatus','#struct_.retdesc#');
		}

		//--------------------------------------------------------------------
	        // если обнаружены ошибки
		if ( structIsEmpty(result.struct) ){

			structCreateServiceType = instance.servicesTypeDAO.createServiceType( stName, stDescription, stStatus );

			if (structCreateServiceType.RETVAL == 1){
				result.RETVAL = structCreateServiceType.RETVAL;
				result.RETDESC = structCreateServiceType.RETDESC;
			}else {
				result.RETVAL = structCreateServiceType.RETVAL;
				result.RETDESC = structCreateServiceType.RETDESC;
			}

		}
		return result;
	}

	function editeServiceType( stID, stName, stDescription, stStatus ){

	        stID = arguments.stID;
		stName = arguments.stName;
		stDescription = arguments.stDescription;
		stStatus = arguments.stStatus;

		var result = structNew();
		result.RETVAL = 0;
		result.RETDESC = "";
		result.STRUCT = structNew(); // для валидации полей

		validator = request.factoryService.getService('Validator');
		                                                 //required                 //DB
		var struct_ = validator.checkInput('#stName#',true,'checkString',2,50 );
		if ( !struct_.retval ){
			structInsert(result.struct, 'stName','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.stDescription#',false,'checkString',0,250);
		if ( !struct_.retval ){
			structInsert(result.struct, 'stDescription','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.stStatus#',false,'isNumeric',1,2);
		if ( !struct_.retval ){
			structInsert(result.struct, 'stStatus','#struct_.retdesc#');
		}

		//--------------------------------------------------------------------
	        // если обнаружены ошибки
		if ( structIsEmpty(result.struct) ){

			structUpdateServiceType = instance.servicesTypeDAO.updateServiceType( stID, stName, stDescription, stStatus );
			if (structUpdateServiceType.RETVAL == 1){
				result.RETVAL = structUpdateServiceType.RETVAL;
				result.RETDESC = structUpdateServiceType.RETDESC;
			}else {
				result.RETVAL = structUpdateServiceType.RETVAL;
				result.RETDESC = structUpdateServiceType.RETDESC;
			}

		}
		return result;
	}

	function getMemento(){
		return instance;
	}
}