/*
	queryUsers.setSQL("SELECT a.user_id, a.user_name, a.user_pass, a.emp_family, a.emp_firstname, a.emp_lastname, a.emp_type, b.empt_name 
			FROM bbs_users a, type_employees b 
			WHERE emp_type NOT IN (#arguments.empType#) 
				AND a.emp_type = b.empt_id 
			ORDER BY a.emp_family");
*/

component displayName='servicesDAO'{

	// Псевдо конструктор
	instance = {datasource = ''} ; // объект
	instance.datasource = createObject('component', 'core.db.Datasource').init();


	function Init (){
		return this;
	}

	function readServiceList(sortBy,emptID,stID){

		//writeDump(sortBy);
		//writeDump(emptID);
		sortBy = arguments.sortBy;
		if (sortBy != false AND sortBy != ''){
			if (sortBy == 'id'){
				_sortBy = 'a.pls_id asc';
			}else{
				_sortBy = 'a.empt_id, a.st_id, a.pls_name';
			}
		}else{
			_sortBy = 'a.empt_id, a.st_id, a.pls_name';
		}

		emptID = arguments.emptID;
		if (emptID != 'all' AND emptID != ''){
			_emptID = 'AND a.empt_id=#emptID#';
		}else{
			_emptID = '';
		}

		stID = arguments.stID;
		if (stID != 'all' AND stID != ''){
			_stID = 'AND a.st_id=#stID#';
		}else{
			_stID = '';
		}

		qServiceList = new Query();
		qServiceList.setName("readServiceList");
		qServiceList.setTimeout("5");
		qServiceList.setDatasource("#variables.instance.datasource.getDSName()#");

		qServiceList.setSQL("SELECT a.pls_id, a.pls_name, a.pls_description, a.pls_price_ot, a.pls_price_do, a.pls_cost, a.empt_id, a.pls_status, a.pls_time, a.st_id, a.pls_shablon, b.empt_name, c.st_name
					FROM pricelist_services a, type_employees b, services_type c
					WHERE a.pls_status >= 0 
						AND b.empt_id = a.empt_id
						AND c.st_id = a.st_id
						#_emptID# 
						#_stID# 
					ORDER BY #_sortBy#");
	
		var execute = qServiceList.execute(); // вся структура и result и prefix
		var result = execute.getResult();
		return result; //query
	}

	function readService( plsid ){
		qService = new Query();
		qService.setName("readService");
		qService.setTimeout("5");
		qService.setDatasource("#variables.instance.datasource.getDSName()#");

		qService.setSQL("SELECT * FROM pricelist_services WHERE pls_id = '#arguments.plsid#' ");
	
		var execute = qService.execute(); // вся структура и result и prefix
		var result = execute.getResult();
		return result; //query
	}

	function createService( required string plsName, string plsDescription , plsPriceOt, plsPriceDo, plsCost, numeric emptID, numeric stID, numeric plsStatus, plsTime, plsShablon ) {
		// дописать время создания и ip
		createService = new Query();
		createService.setDatasource("#instance.datasource.getDSName()#");
		createService.setName("createService");
		createService.setTimeout("5");
		createService.addParam(name = "plsName", value = "#arguments.plsName#", cfsqltype = "cf_sql_varchar" );
		createService.addParam(name = "plsDescription", value = "#arguments.plsDescription#", cfsqltype = "cf_sql_varchar" );
		createService.addParam(name = "plsPriceOt", value = "#arguments.plsPriceOt#", null=yesNoFormat(NOT len(trim(arguments.plsPriceOt))), cfsqltype = "cf_sql_money" );
		createService.addParam(name = "plsPriceDo", value = "#arguments.plsPriceDo#", null=yesNoFormat(NOT len(trim(arguments.plsPriceDo))), cfsqltype = "cf_sql_money" );
		createService.addParam(name = "plsCost", value = "#arguments.plsCost#", cfsqltype = "cf_sql_money" );
		createService.addParam(name = "emptID", value = "#arguments.emptID#", cfsqltype = "cf_sql_integer" );
		createService.addParam(name = "stID", value = "#arguments.stID#", cfsqltype = "cf_sql_integer" );
		createService.addParam(name = "plsStatus", value = "#arguments.plsStatus#", cfsqltype = "cf_sql_integer" );
		createService.addParam(name = "plsTime", value = "#arguments.plsTime#", cfsqltype = "cf_sql_varchar" );
		createService.addParam(name = "plsShablon", value = "#arguments.plsShablon#", cfsqltype = "cf_sql_varchar" );
			
		createService.setSQL("INSERT INTO pricelist_services ( pls_name, pls_description, pls_price_ot, pls_price_do, pls_cost, empt_id, st_id, pls_status, pls_time, pls_shablon )
			VALUES ( :plsName, :plsDescription, :plsPriceOt, :plsPriceDo, :plsCost, :emptID, :stID, :plsStatus, :plsTime, :plsShablon )
			");

		createService.execute(); // вся структура и result и prefix

		var structCreateService = structNew();
		structCreateService.RETVAL = 1; // create
		structCreateService.RETDESC = 'Услуга создана!';
		return structCreateService;
	}

	function updateService(required numeric plsID, required string plsName, string plsDescription, plsPriceOt, plsPriceDo, plsCost, numeric emptID, numeric stID, numeric plsStatus, plsTime, string plsShablon){

		updateService = new Query();
		updateService.setDatasource("#instance.datasource.getDSName()#");
		updateService.setName("updateService");
		updateService.setTimeout("5");

		updateService.addParam(name = "plsID", value = "#arguments.plsID#", cfsqltype = "cf_sql_integer" );
		updateService.addParam(name = "plsName", value = "#arguments.plsName#", cfsqltype = "cf_sql_varchar" );
		updateService.addParam(name = "plsDescription", value = "#arguments.plsDescription#", cfsqltype = "cf_sql_varchar" );
		updateService.addParam(name = "plsPriceOt", value = "#arguments.plsPriceOt#", null=yesNoFormat(NOT len(trim(arguments.plsPriceOt))), cfsqltype = "cf_sql_money" );
		updateService.addParam(name = "plsPriceDo", value = "#arguments.plsPriceDo#", null=yesNoFormat(NOT len(trim(arguments.plsPriceDo))), cfsqltype = "cf_sql_money" );
		updateService.addParam(name = "plsCost", value = "#arguments.plsCost#", cfsqltype = "cf_sql_money" );
		updateService.addParam(name = "emptID", value = "#arguments.emptID#", cfsqltype = "cf_sql_integer" );
		updateService.addParam(name = "stID", value = "#arguments.stID#", cfsqltype = "cf_sql_integer" );
		updateService.addParam(name = "plsStatus", value = "#arguments.plsStatus#", cfsqltype = "cf_sql_integer" );
		updateService.addParam(name = "plsTime", value = "#arguments.plsTime#", cfsqltype = "cf_sql_varchar" );
		updateService.addParam(name = "plsShablon", value = "#arguments.plsShablon#", cfsqltype = "cf_sql_varchar" );

		updateService.setSQL("UPDATE pricelist_services 
				SET 
				pls_name=:plsName,
				pls_description=:plsDescription,
				pls_price_ot=:plsPriceOt,
				pls_price_do=:plsPriceDo,
				pls_cost=:plsCost,
				empt_id=:emptID,
				st_id=:stID,
				pls_status=:plsStatus,
				pls_time=:plsTime,
				pls_shablon=:plsShablon 
				WHERE pls_id = :plsID ");

		updateService.execute();
		var structupdateService = structNew();
		structupdateService.RETVAL = 1; // create
		structupdateService.RETDESC = 'Услуга изменена!';
		return structupdateService;

	}

}