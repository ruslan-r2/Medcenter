component displayName='servicesTypeDAO'{

	// Псевдо конструктор
	instance = {datasource = ''} ; // объект
	instance.datasource = createObject('component', 'core.db.Datasource').init();


	function Init (){
		return this;
	}

	function readServiceTypeList(){
		qServiceTypeList = new Query();
		qServiceTypeList.setName("readServiceTypeList");
		qServiceTypeList.setTimeout("5");
		qServiceTypeList.setDatasource("#variables.instance.datasource.getDSName()#");

		qServiceTypeList.setSQL("SELECT * FROM services_type");
	
		var execute = qServiceTypeList.execute(); // вся структура и result и prefix
		var result = execute.getResult();
		return result; //query
	}

	function readServiceType( stid ){
		qServiceType = new Query();
		qServiceType.setName("readServiceType");
		qServiceType.setTimeout("5");
		qServiceType.setDatasource("#variables.instance.datasource.getDSName()#");

		qServiceType.setSQL("SELECT * FROM services_type WHERE st_id = '#arguments.stid#' ");
	
		var execute = qServiceType.execute(); // вся структура и result и prefix
		var result = execute.getResult();
		return result; //query
	}

	function createServiceType( required string stName, string stDescription , numeric stStatus ) {
		// дописать время создания и ip
		createServiceType = new Query();
		createServiceType.setDatasource("#instance.datasource.getDSName()#");
		createServiceType.setName("createServiceType");
		createServiceType.setTimeout("5");
		createServiceType.addParam(name = "stName", value = "#arguments.stName#", cfsqltype = "cf_sql_varchar" );
		createServiceType.addParam(name = "stDescription", value = "#arguments.stDescription#", cfsqltype = "cf_sql_varchar" );
		createServiceType.addParam(name = "stStatus", value = "#arguments.stStatus#", cfsqltype = "cf_sql_integer" );
			
		createServiceType.setSQL("INSERT INTO services_type ( st_name, st_description, st_status )
			VALUES ( :stName, :stDescription, :stStatus )
			");

		createServiceType.execute(); // вся структура и result и prefix

		var structCreateServiceType = structNew();
		structCreateServiceType.RETVAL = 1; // create
		structCreateServiceType.RETDESC = 'Тип служащего создан!';
		return structCreateServiceType;
	}

	function updateServiceType(required numeric stID, required string stName, string stDescription , numeric stStatus ){

		updateServiceType = new Query();
		updateServiceType.setDatasource("#instance.datasource.getDSName()#");
		updateServiceType.setName("updateServiceType");
		updateServiceType.setTimeout("5");

		updateServiceType.addParam(name = "stID", value = "#arguments.stID#", cfsqltype = "cf_sql_integer" );
		updateServiceType.addParam(name = "stName", value = "#arguments.stName#", cfsqltype = "cf_sql_varchar" );
		updateServiceType.addParam(name = "stDescription", value = "#arguments.stDescription#", cfsqltype = "cf_sql_varchar" );
		updateServiceType.addParam(name = "stStatus", value = "#arguments.stStatus#", cfsqltype = "cf_sql_integer" );

		updateServiceType.setSQL("UPDATE services_type 
				SET 
				st_name=:stName,
				st_description=:stDescription,
				st_status=:stStatus 
				WHERE st_id = :stID ");

		updateServiceType.execute();
		var structupdateServiceType = structNew();
		structupdateServiceType.RETVAL = 1; // create
		structupdateServiceType.RETDESC = 'Услуга изменена!';
		return structupdateServiceType;

	}

}