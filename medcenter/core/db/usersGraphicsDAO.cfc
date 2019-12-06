component displayName='usersGraphicsDAO'{

	// Псевдо конструктор
	instance = {datasource = ''} ; // объект
	instance.datasource = createObject('component', 'core.db.Datasource').init();


	function Init (){
		return this;
	}

	function readUsersGraphicsList( userID, startDate, endDate ){
		qUI = new Query();
		qUI.setName("readUGL");
		qUI.setTimeout("5");
		qUI.setDatasource("#variables.instance.datasource.getDSName()#");

		if ( arguments.userID != '' ){
			qUI.setSQL("SELECT * FROM users_graphics WHERE user_id = #arguments.userID# AND gr_date >= #arguments.startDate# AND gr_date <= #arguments.endDate#");
		}else{
			qUI.setSQL("SELECT * FROM users_graphics WHERE gr_date >= #arguments.startDate# AND gr_date <= #arguments.endDate#");
		}
	
		var execute = qUI.execute(); // вся структура и result и prefix
		var result = execute.getResult();
		return result; //query
	}

	function readUserGraphic( grID ){
		qUG = new Query();
		qUG.setName("readUG");
		qUG.setTimeout("5");
		qUG.setDatasource("#variables.instance.datasource.getDSName()#");

		qUG.setSQL("SELECT * FROM users_graphics WHERE gr_id = #arguments.grID#");
	
		var execute = qUG.execute(); // вся структура и result и prefix
		var result = execute.getResult();
		return result; //query
	}

	function createUserGraphic(required numeric userID, numeric grType, grDate, grStartTime, grEndTime, numeric grStatus ) {
		// дописать время создания и ip
		createUserGraphic = new Query();
		createUserGraphic.setDatasource("#instance.datasource.getDSName()#");
		createUserGraphic.setName("createUserGraphic");
		createUserGraphic.setTimeout("5");
		createUserGraphic.addParam(name = "userID", value = "#arguments.userID#", cfsqltype = "cf_sql_integer" );
		createUserGraphic.addParam(name = "grType", value = "#arguments.grType#", cfsqltype = "cf_sql_integer" );
		createUserGraphic.addParam(name = "grDate", value = "#arguments.grDate#", cfsqltype = "cf_sql_date" );
		createUserGraphic.addParam(name = "grStartTime", value = "#arguments.grStartTime#", null=yesNoFormat(NOT len(trim(arguments.grStartTime))), cfsqltype = "cf_sql_time" );
		createUserGraphic.addParam(name = "grEndTime", value = "#arguments.grEndTime#", null=yesNoFormat(NOT len(trim(arguments.grEndTime))), cfsqltype = "cf_sql_time" );
		createUserGraphic.addParam(name = "grStatus", value = "#arguments.grStatus#", cfsqltype = "cf_sql_integer" );
			
		createUserGraphic.setSQL("INSERT INTO users_graphics ( user_id, gr_type, gr_date, gr_starttime, gr_endtime, gr_status )
			VALUES ( :userID, :grType, :grDate, :grStartTime, :grEndTime, :grStatus )
			");

		createUserGraphic.execute(); // вся структура и result и prefix

		var structCreateUserGraphic = structNew();
		structCreateUserGraphic.RETVAL = 1; // create
		structCreateUserGraphic.RETDESC = 'График создан!';
		return structCreateUserGraphic;
	}

	function updateUserGraphic(required numeric grID, required numeric userID, required numeric grType, grDate, grStartTime, grEndTime, numeric grStatus ){

		updateUserGraphic = new Query();
		updateUserGraphic.setDatasource("#instance.datasource.getDSName()#");
		updateUserGraphic.setName("updateUserGraphic");
		updateUserGraphic.setTimeout("5");

		updateUserGraphic.addParam(name = "grID", value = "#arguments.grID#", cfsqltype = "cf_sql_integer" );
		updateUserGraphic.addParam(name = "userID", value = "#arguments.userID#", cfsqltype = "cf_sql_integer" );
		updateUserGraphic.addParam(name = "grType", value = "#arguments.grType#", cfsqltype = "cf_sql_integer" );
		updateUserGraphic.addParam(name = "grDate", value = "#arguments.grDate#", cfsqltype = "cf_sql_date" );
		updateUserGraphic.addParam(name = "grStartTime", value = "#arguments.grStartTime#", null=yesNoFormat(NOT len(trim(arguments.grStartTime))), cfsqltype = "cf_sql_time" );
		updateUserGraphic.addParam(name = "grEndTime", value = "#arguments.grEndTime#", null=yesNoFormat(NOT len(trim(arguments.grEndTime))), cfsqltype = "cf_sql_time" );
		updateUserGraphic.addParam(name = "grStatus", value = "#arguments.grStatus#", cfsqltype = "cf_sql_integer" );

		updateUserGraphic.setSQL("UPDATE users_graphics 
				SET 
				user_id=:userID,
				gr_type=:grType,
				gr_date=:grDate,
				gr_starttime=:grStartTime,
				gr_endtime=:grEndTime,
				gr_status=:grStatus 
				WHERE gr_id = :grID ");

		updateUserGraphic.execute();
		var structupdateUserGraphic = structNew();
		structupdateUserGraphic.RETVAL = 1; // create
		structupdateUserGraphic.RETDESC = 'Запись изменена!';
		return structupdateUserGraphic;

	}

	function checkUserGraphic( userID, grID, grType, grDate, grStartTime, grEndTime ){

		userID = arguments.userID;
		grID = arguments.grID;
		grType = arguments.grType;
		grDate = CreateODBCDate(arguments.grDate);

		chUG = new Query();
		chUG.setName("checkUG");
		chUG.setTimeout("5");
		chUG.setDatasource("#variables.instance.datasource.getDSName()#");

		if ( arguments.grType == 1){
			grStartTime = CreateODBCTime(dateAdd('s', -1, arguments.grStartTime));
			grEndTime = CreateODBCTime(arguments.grEndTime);

			chUG.setSQL("SELECT * FROM users_graphics a, reception b 
					WHERE a.user_id = #userID# 
						AND b.user_id = #userID# 
						AND a.gr_id = #grID# 
						AND a.gr_date = #grDate# 
						AND b.rp_date = #grDate# 
						AND b.rp_starttime_default <= #grStartTime# 
						AND b.rp_status > 0 
					OR a.user_id = #userID# 
						AND b.user_id = #userID# 
						AND a.gr_id = #grID# 
						AND a.gr_date = #grDate# 
						AND b.rp_date = #grDate# 
						AND b.rp_endtime_default >= #grEndTime# 
						AND b.rp_status > 0 ");
		}else{
			chUG.setSQL("SELECT * FROM users_graphics a, reception b 
					WHERE a.user_id = #userID# 
						AND b.user_id = #userID# 
						AND a.gr_id = #grID# 
						AND a.gr_date = #grDate# 
						AND b.rp_date = #grDate# 
						AND b.rp_status > 0 ");
		}
	
		var execute = chUG.execute(); // вся структура и result и prefix
		var result = execute.getResult();
		return result; //query
	}

}