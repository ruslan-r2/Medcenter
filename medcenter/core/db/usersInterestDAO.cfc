component displayName='userInterestDAO'{

	// Псевдо конструктор
	instance = {datasource = ''} ; // объект
	instance.datasource = createObject('component', 'core.db.Datasource').init();


	function Init (){
		return this;
	}

	function readUsersInterestList(){
		qUI = new Query();
		qUI.setName("readUI");
		qUI.setTimeout("5");
		qUI.setDatasource("#variables.instance.datasource.getDSName()#");

		qUI.setSQL("SELECT * FROM users_interest ");
	
		var execute = qUI.execute(); // вся структура и result и prefix
		var result = execute.getResult();
		return result; //query
	}


	function createUserInterest(required numeric userID, required numeric stID, numeric uiType, numeric uiValue, numeric uiStatus ) {
		// дописать время создания и ip
		createUserInterest = new Query();
		createUserInterest.setDatasource("#instance.datasource.getDSName()#");
		createUserInterest.setName("createUserInterest");
		createUserInterest.setTimeout("5");
		createUserInterest.addParam(name = "userID", value = "#arguments.userID#", cfsqltype = "cf_sql_integer" );
		createUserInterest.addParam(name = "stID", value = "#arguments.stID#", cfsqltype = "cf_sql_integer" );
		createUserInterest.addParam(name = "uiType", value = "#arguments.uiType#", cfsqltype = "cf_sql_integer" );
		createUserInterest.addParam(name = "uiValue", value = "#arguments.uiValue#", cfsqltype = "cf_sql_integer" );
		createUserInterest.addParam(name = "uiStatus", value = "#arguments.uiStatus#", cfsqltype = "cf_sql_integer" );
			
		createUserInterest.setSQL("INSERT INTO users_interest ( user_id, st_id, ui_type, ui_value, ui_status )
			VALUES ( :userID, :stID, :uiType, :uiValue, :uiStatus )
			");

		createUserInterest.execute(); // вся структура и result и prefix

		var structCreateUserInterest = structNew();
		structCreateUserInterest.RETVAL = 1; // create
		structCreateUserInterest.RETDESC = '% от услуги создан!';
		return structCreateUserInterest;
	}

	function updateUserInterest(required numeric uiID, required numeric userID, required numeric stID, numeric uiType, numeric uiValue, numeric uiStatus ){

		updateUserInterest = new Query();
		updateUserInterest.setDatasource("#instance.datasource.getDSName()#");
		updateUserInterest.setName("updateUserInterest");
		updateUserInterest.setTimeout("5");

		updateUserInterest.addParam(name = "uiID", value = "#arguments.uiID#", cfsqltype = "cf_sql_integer" );
		updateUserInterest.addParam(name = "userID", value = "#arguments.userID#", cfsqltype = "cf_sql_integer" );
		updateUserInterest.addParam(name = "stID", value = "#arguments.stID#", cfsqltype = "cf_sql_integer" );
		updateUserInterest.addParam(name = "uiType", value = "#arguments.uiType#", cfsqltype = "cf_sql_integer" );
		updateUserInterest.addParam(name = "uiValue", value = "#arguments.uiValue#", cfsqltype = "cf_sql_integer" );
		updateUserInterest.addParam(name = "uiStatus", value = "#arguments.uiStatus#", cfsqltype = "cf_sql_integer" );

		updateUserInterest.setSQL("UPDATE users_interest 
				SET 
				user_id=:userID,
				st_id=:stID,
				ui_type=:uiType,
				ui_value=:uiValue,
				ui_status=:uiStatus 
				WHERE ui_id = :uiID ");

		updateUserInterest.execute();
		var structupdateUserInterest = structNew();
		structupdateUserInterest.RETVAL = 1; // create
		structupdateUserInterest.RETDESC = 'Запись изменена!';
		return structupdateUserInterest;

	}
}