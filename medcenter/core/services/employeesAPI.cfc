/*
	employeesAPI - типы служащих.
*/

component attributeName='employeesServiceAPI' output='false'{

	// Псевдо конструктор
	instance.employeesDAO = createObject('component', 'core.db.employeesDAO' ).Init();

	instance.employees = {};

	function init(){
		setEmployeesList();
		return this;
	}

	// список пользовательских групп
	function setEmployeesList(){
		qEmployees = instance.employeesDAO.readEmployeesList();
		instance.employees = qEmployees;
	}

	function getEmployeesList() { return instance.employees; }

	function getEmployee( emptid ){
		qEmployee = instance.employeesDAO.readEmployee( arguments.emptid );
		return qEmployee;
	}

	function addEmployee( emptName, emptDescription, emptParent, emptChild, emptStatus ){

		emptName = arguments.emptName;
		emptDescription = arguments.emptDescription;
		emptParent = arguments.emptParent;
		emptChild = arguments.emptChild;
		emptStatus = arguments.emptStatus;

		var result = structNew();
		result.RETVAL = 0;
		result.RETDESC = "";
		result.STRUCT = structNew(); // для валидации полей

		validator = request.factoryService.getService('Validator');
		                                                 //required                 //DB
		var struct_ = validator.checkInput('#emptName#',true,'isAllowSimbolRusEn',2,50, true, 'type_employees', 'empt_name','Наименование типа служащего');
		if ( !struct_.retval ){
			structInsert(result.struct, 'emptName','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.emptDescription#',false,'checkString',0,250);
		if ( !struct_.retval ){
			structInsert(result.struct, 'emptDescription','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.emptParent#',false,'isNumeric',0,3);
		if ( !struct_.retval ){
			structInsert(result.struct, 'emptParent','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.emptChild#',false,'isNumeric',0,3);
		if ( !struct_.retval ){
			structInsert(result.struct, 'emptChild','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.emptStatus#',false,'isNumeric',0,2);
		if ( !struct_.retval ){
			structInsert(result.struct, 'emptStatus','#struct_.retdesc#');
		}

		//--------------------------------------------------------------------

	        // если обнаружены ошибки
		if ( structIsEmpty(result.struct) ){

			structCreateEmployee = instance.employeesDAO.createEmployee( emptName, emptDescription, emptParent, emptChild, emptStatus );

			if (structCreateEmployee.RETVAL == 1){
				result.RETVAL = structCreateEmployee.RETVAL;
				result.RETDESC = structCreateEmployee.RETDESC;
			}else {
				result.RETVAL = structCreateEmployee.RETVAL;
				result.RETDESC = structCreateEmployee.RETDESC;
			}

		}
		return result;
	}

	function editeEmployee( emptID, emptName, emptDescription, emptParent, emptChild, emptStatus ){

	        emptID = arguments.emptID;
		emptName = arguments.emptName;
		emptDescription = arguments.emptDescription;
		emptParent = arguments.emptParent;
		emptChild = arguments.emptChild;
		emptStatus = arguments.emptStatus;

		var result = structNew();
		result.RETVAL = 0;
		result.RETDESC = "";
		result.STRUCT = structNew(); // для валидации полей

		validator = request.factoryService.getService('Validator');
		                                                 //required                 //DB
		var struct_ = validator.checkInput('#emptName#',true,'isAllowSimbolRusEn',2,50, false, 'type_employees', 'empt_name','Наименование типа служащего');
		if ( !struct_.retval ){
			structInsert(result.struct, 'emptName','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.emptDescription#',false,'checkString',0,250);
		if ( !struct_.retval ){
			structInsert(result.struct, 'emptDescription','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.emptParent#',false,'isNumeric',0,3);
		if ( !struct_.retval ){
			structInsert(result.struct, 'emptParent','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.emptChild#',false,'isNumeric',0,3);
		if ( !struct_.retval ){
			structInsert(result.struct, 'emptChild','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.emptStatus#',false,'isNumeric',0,2);
		if ( !struct_.retval ){
			structInsert(result.struct, 'emptStatus','#struct_.retdesc#');
		}

		//--------------------------------------------------------------------

	        // если обнаружены ошибки
		if ( structIsEmpty(result.struct) ){

			structUpdateEmployee = instance.employeesDAO.updateEmployee( emptID, emptName, emptDescription, emptParent, emptChild, emptStatus );

			if (structUpdateEmployee.RETVAL == 1){
				result.RETVAL = structUpdateEmployee.RETVAL;
				result.RETDESC = structUpdateEmployee.RETDESC;
			}else {
				result.RETVAL = structUpdateEmployee.RETVAL;
				result.RETDESC = structUpdateEmployee.RETDESC;
			}

		}
		return result;
	}


	function getMemento(){
		return instance;
	}
}