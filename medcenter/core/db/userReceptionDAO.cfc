component displayName='userReceptionDAO'{

	// Псевдо конструктор
	instance = {datasource = ''} ; // объект
	instance.datasource = createObject('component', 'core.db.Datasource').init();


	function Init (){
		return this;
	}

	function readReception( rpID ){
		qReception = new Query();
		qReception.setName("readReception");
		qReception.setTimeout("5");
		qReception.setDatasource("#variables.instance.datasource.getDSName()#");

		qReception.setSQL("SELECT * FROM reception WHERE rp_id = #arguments.rpID# AND rp_status >= 1 ");
	
		var execute = qReception.execute(); // вся структура и result и prefix
		var result = execute.getResult();
		return result; //query
	}

	function readUserReception( userID, date ){
		qUserReception = new Query();
		qUserReception.setName("readUserReception");
		qUserReception.setTimeout("5");
		qUserReception.setDatasource("#variables.instance.datasource.getDSName()#");

		qUserReception.setSQL("SELECT * FROM reception WHERE user_id = #arguments.userID# AND rp_status >= 1 AND rp_date = #arguments.date# ORDER BY rp_starttime_default");
	
		var execute = qUserReception.execute(); // вся структура и result и prefix
		var result = execute.getResult();
		return result; //query
	}

	function checkUserReception( rpID='', userID, date, starttime, endtime ){

		rpID = arguments.rpID;
		userID = arguments.userID;
		date = CreateODBCDate(arguments.date);
		starttime = CreateODBCTime(arguments.starttime);
		endtime = CreateODBCTime(arguments.endtime);

		qUserReception = new Query();
		qUserReception.setName("readUserReception");
		qUserReception.setTimeout("5");
		qUserReception.setDatasource("#variables.instance.datasource.getDSName()#");

		if (rpID is ''){
		qUserReception.setSQL("SELECT * FROM reception WHERE user_id = #userID# AND rp_status >= 1 AND rp_date = #date# AND rp_starttime_default <= #starttime# AND rp_endtime_default >= #starttime# OR
					user_id = #userID# AND rp_status >= 1 AND rp_date = #date# AND rp_starttime_default <= #endtime# AND rp_endtime_default >= #endtime# OR
					user_id = #userID# AND rp_status >= 1 AND rp_date = #date# AND rp_starttime_default >= #starttime# AND rp_endtime_default <= #endtime#");
		}else{
		qUserReception.setSQL("SELECT * FROM reception WHERE user_id = #userID# AND rp_status >= 1 AND rp_date = #date# AND rp_starttime_default <= #starttime# AND rp_endtime_default >= #starttime# AND rp_id <> #rpID# OR
					user_id = #userID# AND rp_status >= 1 AND rp_date = #date# AND rp_starttime_default <= #endtime# AND rp_endtime_default >= #endtime# AND rp_id <> #rpID# OR
					user_id = #userID# AND rp_status >= 1 AND rp_date = #date# AND rp_starttime_default >= #starttime# AND rp_endtime_default <= #endtime# AND rp_id <> #rpID#");
		}

		var execute = qUserReception.execute(); // вся структура и result и prefix
		var result = execute.getResult();
		return result; //query
	}

	function createUserReception(required numeric userID, rpDate, rpStartTime, rpEndTime, numeric rpStatus ) {
		// дописать время создания
		createUserReception = new Query();
		createUserReception.setDatasource("#instance.datasource.getDSName()#");
		createUserReception.setName("createUserReception");
		createUserReception.setTimeout("5");
		createUserReception.addParam(name = "userID", value = "#arguments.userID#", cfsqltype = "cf_sql_integer" );
		createUserReception.addParam(name = "rpDate", value = "#arguments.rpDate#", cfsqltype = "cf_sql_date" );
		createUserReception.addParam(name = "rpStartTime", value = "#arguments.rpStartTime#", cfsqltype = "cf_sql_time" );
		createUserReception.addParam(name = "rpEndTime", value = "#arguments.rpEndTime#", cfsqltype = "cf_sql_time" );
		createUserReception.addParam(name = "rpStatus", value = "#arguments.rpStatus#", cfsqltype = "cf_sql_integer" );
		createUserReception.addParam(name = "rpDateAdd", value = "#CreateODBCDateTime(now())#", cfsqltype = "cf_sql_date" );
		createUserReception.addParam(name = "rpUserIDAdd", value = "#session.sessionStorage.getObject('user').getUserId()#", cfsqltype = "cf_sql_integer" );
			
		createUserReception.setSQL("INSERT INTO reception ( user_id, rp_date, rp_starttime_default, rp_endtime_default, rp_status, rp_dateadd, rp_useridadd )
			VALUES ( :userID, :rpDate, :rpStartTime, :rpEndTime, :rpStatus, :rpDateAdd, :rpUserIDAdd )
			");

		ret = createUserReception.execute(); // вся структура и result и prefix
		//writeDump(ret.getPrefix().GENERATEDKEY);
		//break;

		var structCreateUserReception = structNew();
		structCreateUserReception.RETVAL = 1; // create
		structCreateUserReception.RETDESC = '#ret.getPrefix().GENERATEDKEY#';
		return structCreateUserReception;
	}

	function _updateUserReception( required numeric rpID, required numeric userID, rpDate, rpStartTime, rpEndTime, rpDescription, numeric rpStatus ){

		_updateUserReception = new Query();
		_updateUserReception.setDatasource("#instance.datasource.getDSName()#");
		_updateUserReception.setName("_updateUserReception");
		_updateUserReception.setTimeout("5");

		_updateUserReception.addParam(name = "rpID", value = "#arguments.rpID#", cfsqltype = "cf_sql_integer" );
		_updateUserReception.addParam(name = "userID", value = "#arguments.userID#", cfsqltype = "cf_sql_integer" );
		_updateUserReception.addParam(name = "rpDate", value = "#arguments.rpDate#", cfsqltype = "cf_sql_date" );
		_updateUserReception.addParam(name = "rpStartTime", value = "#arguments.rpStartTime#", cfsqltype = "cf_sql_time" );
		_updateUserReception.addParam(name = "rpEndTime", value = "#arguments.rpEndTime#", cfsqltype = "cf_sql_time" );
		_updateUserReception.addParam(name = "rpDescription", value = "#arguments.rpDescription#", cfsqltype = "cf_sql_varchar" );
		_updateUserReception.addParam(name = "rpStatus", value = "#arguments.rpStatus#", cfsqltype = "cf_sql_integer" );
		_updateUserReception.addParam(name = "rpUserIDAdd", value = "#session.sessionStorage.getObject('user').getUserId()#", cfsqltype = "cf_sql_integer" );

		_updateUserReception.setSQL("UPDATE reception 
				SET 
				user_id =:userID,
				rp_date=:rpDate,
				rp_starttime_default =:rpStartTime,
				rp_endtime_default =:rpEndTime,
				rp_description =:rpDescription,
				rp_status =:rpStatus,
				rp_useridadd =:rpUserIDAdd 
				WHERE rp_id = :rpID ");

		_updateUserReception.execute();
		var structUpdateUserReception = structNew();
		structUpdateUserReception.RETVAL = 1; // create
		structUpdateUserReception.RETDESC = 'Запись изменена!';
		return structUpdateUserReception;

	}

	function updateUserReception( rpID, ptID ){

		updateUserReception = new Query();
		updateUserReception.setDatasource("#instance.datasource.getDSName()#");
		updateUserReception.setName("updateUserReception");
		updateUserReception.setTimeout("5");

		updateUserReception.addParam(name = "rpID", value = "#arguments.rpID#", cfsqltype = "cf_sql_integer" );
		updateUserReception.addParam(name = "ptID", value = "#arguments.ptID#", cfsqltype = "cf_sql_integer" );
		updateUserReception.addParam(name = "rpUserIDAdd", value = "#session.sessionStorage.getObject('user').getUserId()#", cfsqltype = "cf_sql_integer" );

		updateUserReception.setSQL("UPDATE reception 
				SET 
				pt_id=:ptID,
				rp_useridadd =:rpUserIDAdd 
				WHERE rp_id = :rpID ");

		updateUserReception.execute();
		var structUpdateUserReception = structNew();
		structUpdateUserReception.RETVAL = 1; // create
		structUpdateUserReception.RETDESC = 'Запись изменена!';
		return structUpdateUserReception;

	}

	function startEndUserReception( rpID, rpStatus ){

		SNUserReception = new Query();
		SNUserReception.setDatasource("#instance.datasource.getDSName()#");
		SNUserReception.setName("SNUserReception");
		SNUserReception.setTimeout("5");

		SNUserReception.addParam(name = "rpID", value = "#arguments.rpID#", cfsqltype = "cf_sql_integer" );
		SNUserReception.addParam(name = "rpStatus", value = "#arguments.rpStatus#", cfsqltype = "cf_sql_integer" );
		SNUserReception.addParam(name = "rpUserIDAdd", value = "#session.sessionStorage.getObject('user').getUserId()#", cfsqltype = "cf_sql_integer" );

		if ( arguments.rpStatus == 2 ){
			//rpStartTime = createODBCTime(now());
			SNUserReception.addParam(name = "rpStartTime", value = "#createODBCTime(now())#", cfsqltype = "cf_sql_time" );
			SNUserReception.setSQL("UPDATE reception 
						SET 
						rp_starttime=:rpStartTime,
						rp_status=:rpStatus,
						rp_useridadd =:rpUserIDAdd 
						WHERE rp_id=:rpID");

		}else if( arguments.rpStatus == 3 ){
			//rpEndTime = createODBCTime(now());
			SNUserReception.addParam(name = "rpEndTime", value = "#createODBCTime(now())#", cfsqltype = "cf_sql_time" );
			//writeDump(rpEndTime);
			SNUserReception.setSQL("UPDATE reception 
						SET 
						rp_endtime=:rpEndTime,
						rp_status=:rpStatus,
						rp_useridadd =:rpUserIDAdd 
						WHERE rp_id=:rpID");
		}



		SNUserReception.execute();
		var structSNUserReception = structNew();
		structSNUserReception.RETVAL = 1; // create
		structSNUserReception.RETDESC = 'Статус записи изменён!';
		return structSNUserReception;

	}

	function deleteUserReception( rpID ) {
		deleteUserReception = new Query();
		deleteUserReception.setDatasource("#instance.datasource.getDSName()#");
		deleteUserReception.setName("deleteUserReception");
		deleteUserReception.setTimeout("5");
		deleteUserReception.addParam(name = "rpID", value = "#arguments.rpID#", cfsqltype = "cf_sql_integer" );
		deleteUserReception.addParam(name = "rpStatus", value = "0", cfsqltype = "cf_sql_integer" );
		deleteUserReception.addParam(name = "rpUserIDDelete", value = "#session.sessionStorage.getObject('user').getUserId()#", cfsqltype = "cf_sql_integer" );
			
		//deleteUserReception.setSQL("DELETE FROM reception WHERE rp_id = :rpID ");
		deleteUserReception.setSQL("UPDATE reception 
				SET 
				rp_status=:rpStatus,
				rp_useriddelete=:rpUserIDDelete 
				WHERE rp_id = :rpID ");

		deleteUserReception.execute(); // вся структура и result и prefix

		var structDeleteUserReception = structNew();
		structDeleteUserReception.RETVAL = 1; // create
		structDeleteUserReception.RETDESC = 'Запись к врачу удалена!';
		return structDeleteUserReception;
	}

}