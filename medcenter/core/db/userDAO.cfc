/*
*/
component displayname="userDAO" output="false" {

	/* Псевдо конструктор */
	instance = {datasource = ''} ; // объект

	function init() {
		instance.datasource = createObject('component', 'core.db.Datasource').init();
		return this ;
	}
	
	// CRUD
/*
			queryUsers.setSQL("SELECT a.user_id, a.user_name, a.user_pass, a.emp_family, a.emp_firstname, a.emp_lastname, a.emp_type, b.empt_name 
						FROM bbs_users a, type_employees b 
						WHERE emp_type NOT IN (#arguments.empType#) 
							AND a.emp_type = b.empt_id 
						ORDER BY a.emp_family");
*/

	function readUsers( empType='' ){
		queryUsers = new Query();
		queryUsers.setName("users");
		queryUsers.setTimeout("5");
		queryUsers.setDatasource("#variables.instance.datasource.getDSName()#");

		if ( arguments.empType == ''){
			//queryUsers.setSQL("SELECT * FROM bbs_users a, type_employees b WHERE a.emp_type = b.empt_id");
			queryUsers.setSQL("SELECT * FROM bbs_users");
		}else{
			queryUsers.setSQL("SELECT user_id, user_name, user_pass, emp_family, emp_firstname, emp_lastname, emp_type 
						FROM bbs_users 
						WHERE user_groups IN (#arguments.empType#) 
						ORDER BY emp_family");  // конструкция NOT IN не работает, из-за того, что в поле emp_type не id -
									// int, а nvarchar пример у булатова "7,26".
		}
	
		var execute = queryUsers.execute(); // вся структура и result и prefix
		var result = execute.getResult();
		return result; //query
	}

	function _readUser( required string userID ) {
		queryUser = new Query();
		queryUser.setName("_qUser");
		queryUser.setTimeout("5");
		queryUser.setDatasource("#variables.instance.datasource.getDSName()#");

		queryUser.setSQL("SELECT * FROM bbs_users WHERE user_id = '#arguments.userID#' ");
	
		var execute = queryUser.execute(); // вся структура и result и prefix
		var result = execute.getResult();

		return result;
	}

	function readUser(required string username, required string password) {
		queryUser = new Query();
		queryUser.setName("quser");
		queryUser.setTimeout("5");
		queryUser.setDatasource("#variables.instance.datasource.getDSName()#");

		queryUser.addParam(	name = "username", value = "#arguments.userName#", cfsqltype = "cf_sql_varchar" );
		queryUser.addParam(	name = "password", value = "#arguments.password#", cfsqltype = "cf_sql_varchar" );

		queryUser.setSQL("SELECT * FROM bbs_users WHERE user_name = :username AND user_pass = :password ");
	
		var execute = queryUser.execute(); // вся структура и result и prefix
		var result = execute.getResult();

		// доделать алгоритм удаления двойных записей
		var structUser=structNew();
		structUser.RETVAL = 0; // login
		structUser.RETDESC = 'Пользователя с таким логином и паролем нет! #now()#';
		if (result.RecordCount gt 0) {
			structUser.RETDESC = 'Поздравляем вас!';
			structUser.RETVAL = 1;
			//setVariable('structUser.RETVAL',1);
			setVariable('structUser.user_id',result.user_id);
			setVariable('structUser.user_name',result.user_name);
			setVariable('structUser.emp_family',result.emp_family);
			setVariable('structUser.emp_firstname',result.emp_firstname);
			setVariable('structUser.emp_lastname',result.emp_lastname);
			setVariable('structUser.emp_type',result.emp_type);
			setVariable('structUser.user_groups',result.user_groups);
		}
		return structUser;
	}

	// создание нового пользователя - регистрация
	function createUser(required string userName, required string userPass, required numeric userStatus, userGroups, empType, empFamily, empFirstName, empLastName, empDescription ) {
		// дописать время создания и ip
		createUser = new Query();
		createUser.setDatasource("#instance.datasource.getDSName()#");
		createUser.setName("createUser");
		createUser.setTimeout("5");
		createUser.addParam(name = "userName", value = "#arguments.userName#", cfsqltype = "cf_sql_varchar" );
		createUser.addParam(name = "userPass", value = "#arguments.userPass#", cfsqltype = "cf_sql_varchar" );
		createUser.addParam(name = "userStatus", value = "#arguments.userStatus#", cfsqltype = "cf_sql_integer" );
		createUser.addParam(name = "userGroups", value = "#arguments.userGroups#", null=yesNoFormat(NOT len(trim(arguments.userGroups))), cfsqltype = "cf_sql_integer" );
		createUser.addParam(name = "empType", value = "#arguments.empType#", null=yesNoFormat(NOT len(trim(arguments.empType))), cfsqltype = "cf_sql_varchar" );
		createUser.addParam(name = "empFamily", value = "#arguments.empFamily#", cfsqltype = "cf_sql_varchar" );
		createUser.addParam(name = "empFirstName", value = "#arguments.empFirstName#", cfsqltype = "cf_sql_varchar" );
		createUser.addParam(name = "empLastName", value = "#arguments.empLastName#", cfsqltype = "cf_sql_varchar" );
		createUser.addParam(name = "empDescription", value = "#arguments.empDescription#", cfsqltype = "cf_sql_varchar" );
			
		createUser.setSQL("INSERT INTO bbs_users ( user_name, user_pass, user_status, user_groups, emp_type, emp_family, emp_firstname, emp_lastname, emp_description )
			VALUES ( :userName, :userPass, :userStatus, :userGroups, :empType, :empFamily, :empFirstName, :empLastName, :empDescription )
			");

		ss = createUser.execute(); // вся структура и result и prefix
		//writeDump(ss);
		var structRegUser=structNew();
		structRegUser.RETVAL = 1; //REG
		structRegUser.RETDESC = 'Пользователь добавлен!';
		return structRegUser;
	}

	function updateUser(required userID, required string userName, required string userPass, required numeric userStatus, userGroups, empType, empFamily, empFirstName, empLastName, empDescription){

		updateUser = new Query();
		updateUser.setDatasource("#instance.datasource.getDSName()#");
		updateUser.setName("updateUser");
		updateUser.setTimeout("5");

		updateUser.addParam(	name = "userID", value = "#arguments.userID#", cfsqltype = "cf_sql_integer" );
		updateUser.addParam(	name = "userName", value = "#arguments.userName#", cfsqltype = "cf_sql_varchar" );
		updateUser.addParam(	name = "userPass", value = "#arguments.userPass#", cfsqltype = "cf_sql_varchar" );
		updateUser.addParam(	name = "userStatus", value = "#arguments.userStatus#", cfsqltype = "cf_sql_integer" );
		updateUser.addParam(	name = "userGroups", value = "#arguments.userGroups#", null=yesNoFormat(NOT len(trim(arguments.userGroups))), cfsqltype = "cf_sql_integer" );
		updateUser.addParam(	name = "empType", value = "#arguments.empType#", null=yesNoFormat(NOT len(trim(arguments.empType))), cfsqltype = "cf_sql_varchar" );
		updateUser.addParam(	name = "empFamily", value = "#arguments.empFamily#", cfsqltype = "cf_sql_varchar" );
		updateUser.addParam(	name = "empFirstName", value = "#arguments.empFirstName#", cfsqltype = "cf_sql_varchar" );
		updateUser.addParam(	name = "empLastName", value = "#arguments.empLastName#", cfsqltype = "cf_sql_varchar" );
		updateUser.addParam(	name = "empDescription", value = "#arguments.empDescription#", cfsqltype = "cf_sql_varchar" );


		updateUser.setSQL("UPDATE bbs_users 
				SET 
				user_name=:userName,
				user_pass=:userPass,
				user_status=:userStatus,
				user_groups=:userGroups,
				emp_type=:empType,
				emp_family=:empFamily,
				emp_firstname=:empFirstName,
				emp_lastname=:empLastName,
				emp_description=:empDescription 
				WHERE user_id = :userID");

		updateUser.execute();
		var structUpdateUser = structNew();
		structUpdateUser.RETVAL = 1; // create
		structUpdateUser.RETDESC = 'Учётная запись изменена!';
		return structUpdateUser;

	}

	function checkInputDB( string table_name, string field_name, value) {

		qCheck = new Query();
		qCheck.setName("checkInputDB");
		qCheck.setTimeout("5");
		qCheck.setDatasource("#variables.instance.datasource.getDSName()#");

		//queryUser.addParam(	name = "username", value = "#arguments.userName#", cfsqltype = "cf_sql_varchar" );
    		query = "SELECT #arguments.field_name# FROM #arguments.table_name# WHERE #arguments.field_name# = '#arguments.value#'" ;
		//query &= " AND user_id <> 1"; // session.userID

		qCheck.setSQL(query);
		var execute = qCheck.execute(); // вся структура и result и prefix
		var result = execute.getResult();

		return result; // возвращает query
	}
}