component displayName='employeesDAO'{

	// Псевдо конструктор
	instance = {datasource = ''} ; // объект
	instance.datasource = createObject('component', 'core.db.Datasource').init();


	function Init (){
		return this;
	}

	function readEmployeesList(){
		qEmployeesList = new Query();
		qEmployeesList.setName("readEmployeesList");
		qEmployeesList.setTimeout("5");
		qEmployeesList.setDatasource("#variables.instance.datasource.getDSName()#");

		qEmployeesList.setSQL("SELECT * FROM type_employees ORDER BY empt_name");
	
		var execute = qEmployeesList.execute(); // вся структура и result и prefix
		var result = execute.getResult();
		return result; //query
	}

	function readEmployee( emptid ){
		qEmployee = new Query();
		qEmployee.setName("readEmployee");
		qEmployee.setTimeout("5");
		qEmployee.setDatasource("#variables.instance.datasource.getDSName()#");

		qEmployee.setSQL("SELECT * FROM type_employees WHERE empt_id = '#arguments.emptid#' ");
	
		var execute = qEmployee.execute(); // вся структура и result и prefix
		var result = execute.getResult();
		return result; //query
	}

	function createEmployee( required string emptName, string emptDescription , emptParent, emptChild, numeric emptStatus) {
		// дописать время создания и ip
		createEmployee = new Query();
		createEmployee.setDatasource("#instance.datasource.getDSName()#");
		createEmployee.setName("createEmployee");
		createEmployee.setTimeout("5");
		createEmployee.addParam(name = "emptName", value = "#arguments.emptName#", cfsqltype = "cf_sql_varchar" );
		createEmployee.addParam(name = "emptDescription", value = "#arguments.emptDescription#", cfsqltype = "cf_sql_varchar" );
		createEmployee.addParam(name = "emptParent", value = "#arguments.emptParent#", null=yesNoFormat(NOT len(trim(arguments.emptParent))), cfsqltype = "cf_sql_integer" );
		createEmployee.addParam(name = "emptChild", value = "#arguments.emptChild#", null=yesNoFormat(NOT len(trim(arguments.emptChild))), cfsqltype = "cf_sql_integer" );
		createEmployee.addParam(name = "emptStatus", value = "#arguments.emptStatus#", cfsqltype = "cf_sql_integer" );
			
		createEmployee.setSQL("INSERT INTO type_employees ( empt_name, empt_description, empt_parent, empt_child, empt_status )
			VALUES ( :emptName, :emptDescription, :emptParent, :emptChild, :emptStatus )
			");

		createEmployee.execute(); // вся структура и result и prefix

		var structCreateEmployee = structNew();
		structCreateEmployee.RETVAL = 1; // create
		structCreateEmployee.RETDESC = 'Тип служащего создан!';
		return structCreateEmployee;
	}

	function updateEmployee(required emptID, required string emptName, string emptDescription , emptParent, emptChild, numeric emptStatus){

		updateEmployee = new Query();
		updateEmployee.setDatasource("#instance.datasource.getDSName()#");
		updateEmployee.setName("updateEmployee");
		updateEmployee.setTimeout("5");

		updateEmployee.addParam( name = "emptID", value = "#arguments.emptID#", cfsqltype = "cf_sql_integer" );
		updateEmployee.addParam( name = "emptName", value = "#arguments.emptName#", cfsqltype = "cf_sql_varchar" );
		updateEmployee.addParam( name = "emptDescription", value = "#arguments.emptDescription#", cfsqltype = "cf_sql_varchar" );
		updateEmployee.addParam( name = "emptParent", value = "#arguments.emptParent#", null=yesNoFormat(NOT len(trim(arguments.emptParent))), cfsqltype = "cf_sql_integer" );
		updateEmployee.addParam( name = "emptChild", value = "#arguments.emptChild#", null=yesNoFormat(NOT len(trim(arguments.emptChild))), cfsqltype = "cf_sql_integer" );
		updateEmployee.addParam( name = "emptStatus", value = "#arguments.emptStatus#", cfsqltype = "cf_sql_integer" );

		updateEmployee.setSQL("UPDATE type_employees 
				SET 
				empt_name=:emptName,
				empt_description=:emptDescription,
				empt_parent=:emptParent,
				empt_child=:emptChild,
				empt_status=:emptStatus 
				WHERE empt_id = :emptID");

		updateEmployee.execute();
		var structUpdateEmployee = structNew();
		structUpdateEmployee.RETVAL = 1; // create
		structUpdateEmployee.RETDESC = 'Тип служащего изменён!';
		return structUpdateEmployee;

	}

}