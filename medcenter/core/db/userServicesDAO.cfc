/* услуги которые добавлины к приёму у врача
*/

component displayName='usersServicesDAO'{

	// Псевдо конструктор
	instance = {datasource = ''} ; // объект
	instance.datasource = createObject('component', 'core.db.Datasource').init();


	function Init (){
		return this;
	}

	function readEmpServices( empType ){
		qEmpService = new Query();
		qEmpService.setName("readEmpServices");
		qEmpService.setTimeout("5");
		qEmpService.setDatasource("#variables.instance.datasource.getDSName()#");

		qEmpService.setSQL("SELECT * FROM pricelist_services WHERE pls_status >= 1 AND empt_id IN (#arguments.empType#) ORDER BY empt_id,st_id,pls_name");
	
		var execute = qEmpService.execute(); // вся структура и result и prefix
		var result = execute.getResult();
		return result; //query
	}

	function readReceptionServices(rpID){
		qRService = new Query();
		qRService.setName("readRServices");
		qRService.setTimeout("5");
		qRService.setDatasource("#variables.instance.datasource.getDSName()#");

		qRService.setSQL("SELECT * FROM services WHERE rp_id = #arguments.rpID# ORDER BY st_id,sv_name");
	
		var execute = qRService.execute(); // вся структура и result и prefix
		var result = execute.getResult();
		return result; //query
	}

	function readReceptionService(svID){
		qRService = new Query();
		qRService.setName("readRService");
		qRService.setTimeout("5");
		qRService.setDatasource("#variables.instance.datasource.getDSName()#");

		qRService.setSQL("SELECT * FROM services WHERE sv_id = #arguments.svID#");
	
		var execute = qRService.execute(); // вся структура и result и prefix
		var result = execute.getResult();
		return result; //query
	}

	function deleteReceptionService( svID ) {
		// дописать время создания и ip
		deleteReceptionService = new Query();
		deleteReceptionService.setDatasource("#instance.datasource.getDSName()#");
		deleteReceptionService.setName("deleteReceptionService");
		deleteReceptionService.setTimeout("5");
		deleteReceptionService.addParam(name = "svID", value = "#arguments.svID#", cfsqltype = "cf_sql_integer" );
			
		deleteReceptionService.setSQL("DELETE FROM services WHERE sv_id = :svID ");

		deleteReceptionService.execute(); // вся структура и result и prefix

		var structDeleteReceptionService = structNew();
		structDeleteReceptionService.RETVAL = 1; // create
		structDeleteReceptionService.RETDESC = 'Услуга удалена!';
		return structDeleteReceptionService;
	}

	function deleteReceptionServices( rpID ) {
		// дописать время создания и ip
		deleteReceptionServices = new Query();
		deleteReceptionServices.setDatasource("#instance.datasource.getDSName()#");
		deleteReceptionServices.setName("deleteReceptionServices");
		deleteReceptionServices.setTimeout("5");
		deleteReceptionServices.addParam(name = "rpID", value = "#arguments.rpID#", cfsqltype = "cf_sql_integer" );
			
		deleteReceptionServices.setSQL("DELETE FROM services WHERE rp_id = :rpID ");

		deleteReceptionServices.execute(); // вся структура и result и prefix

		var structDeleteReceptionServices = structNew();
		structDeleteReceptionServices.RETVAL = 1; // create
		structDeleteReceptionServices.RETDESC = 'Услуги удалены!';
		return structDeleteReceptionServices;
	}

	function createReceptionService(required numeric rpID, plsID, svPrice, svCost, svName, svTime, svDescription, svStatus, stID, plsShablon, userInterest ) {
		// дописать время создания и ip
		createReceptionService = new Query();
		createReceptionService.setDatasource("#instance.datasource.getDSName()#");
		createReceptionService.setName("createReceptionService");
		createReceptionService.setTimeout("5");
		createReceptionService.addParam(name = "rpID", value = "#arguments.rpID#", cfsqltype = "cf_sql_integer" );
		createReceptionService.addParam(name = "plsID", value = "#arguments.plsID#", cfsqltype = "cf_sql_integer" );
		createReceptionService.addParam(name = "svPrice", value = "#arguments.svPrice#", cfsqltype = "cf_sql_money" );
		createReceptionService.addParam(name = "svCost", value = "#arguments.svCost#", cfsqltype = "cf_sql_money" );
		createReceptionService.addParam(name = "svName", value = "#arguments.svName#", cfsqltype = "cf_sql_varchar" );
		createReceptionService.addParam(name = "svTime", value = "#arguments.svTime#", cfsqltype = "cf_sql_integer" );
		createReceptionService.addParam(name = "svDescription", value = "#arguments.svDescription#", cfsqltype = "cf_sql_varchar" );
		createReceptionService.addParam(name = "svStatus", value = "#arguments.svStatus#", cfsqltype = "cf_sql_integer" );
		createReceptionService.addParam(name = "stID", value = "#arguments.stID#", cfsqltype = "cf_sql_integer" );
		createReceptionService.addParam(name = "plsShablon", value = "#arguments.plsShablon#", cfsqltype = "cf_sql_varchar" );
		createReceptionService.addParam(name = "userInterest", value = "#arguments.userInterest#", cfsqltype = "cf_sql_money" );
			
		createReceptionService.setSQL("INSERT INTO services ( rp_id, pls_id, sv_price, sv_cost, sv_name, sv_time, sv_description, sv_status, st_id, pls_shablon, user_interest ) 
			VALUES ( :rpID, :plsID, :svPrice, :svCost, :svName, :svTime, :svDescription, :svStatus, :stID, :plsShablon, :userInterest )
			");

		createReceptionService.execute(); // вся структура и result и prefix

		var structCreateReceptionService = structNew();
		structCreateReceptionService.RETVAL = 1; // create
		structCreateReceptionService.RETDESC = 'Услуга добавлена!';
		return structCreateReceptionService;
	}

	function updateReceptionService( svID, plsShablon ){

		updateReceptionService = new Query();
		updateReceptionService.setDatasource("#instance.datasource.getDSName()#");
		updateReceptionService.setName("updateReceptionService");
		updateReceptionService.setTimeout("5");

		updateReceptionService.addParam(name = "svID", value = "#arguments.svID#", cfsqltype = "cf_sql_integer" );
		updateReceptionService.addParam(name = "plsShablon", value = "#arguments.plsShablon#", cfsqltype = "cf_sql_varchar" );

		updateReceptionService.setSQL("UPDATE services 
				SET 
				pls_shablon=:plsShablon 
				WHERE sv_id = :svID");

		updateReceptionService.execute();
		var structUpdateReceptionService = structNew();
		structUpdateReceptionService.RETVAL = 1; // create
		structUpdateReceptionService.RETDESC = 'Документ услуги изменён!';
		return structUpdateReceptionService;

	}

	function updateReceptionServicePrice( svID, svPrice, userInterest ){

		updateReceptionServicePrice = new Query();
		updateReceptionServicePrice.setDatasource("#instance.datasource.getDSName()#");
		updateReceptionServicePrice.setName("updateReceptionServicePrice");
		updateReceptionServicePrice.setTimeout("5");

		updateReceptionServicePrice.addParam(name = "svID", value = "#arguments.svID#", cfsqltype = "cf_sql_integer" );
		updateReceptionServicePrice.addParam(name = "svPrice", value = "#arguments.svPrice#", cfsqltype = "cf_sql_money" );
		updateReceptionServicePrice.addParam(name = "userInterest", value = "#arguments.userInterest#", cfsqltype = "cf_sql_money" );

		updateReceptionServicePrice.setSQL("UPDATE services 
				SET 
				sv_price=:svPrice,
				user_interest=:userInterest 
				WHERE sv_id = :svID");

		updateReceptionServicePrice.execute();
		var structUpdateReceptionServicePrice = structNew();
		structUpdateReceptionServicePrice.RETVAL = 1; // create
		structUpdateReceptionServicePrice.RETDESC = 'Цена услуги изменена!';
		return structUpdateReceptionServicePrice;

	}

	function updateReceptionServiceStatus( svIDs, svStatus ){

		updateReceptionServiceStatus = new Query();
		updateReceptionServiceStatus.setDatasource("#instance.datasource.getDSName()#");
		updateReceptionServiceStatus.setName("updateReceptionServiceStatus");
		updateReceptionServiceStatus.setTimeout("5");

		updateReceptionServiceStatus.addParam(name = "svIDs", value = "#arguments.svIDs#", cfsqltype = "cf_sql_varchar" );
		updateReceptionServiceStatus.addParam(name = "svStatus", value = "#arguments.svStatus#", cfsqltype = "cf_sql_integer" );

		updateReceptionServiceStatus.setSQL("UPDATE services 
				SET 
				sv_status=:svStatus 
				WHERE sv_id IN (#svIDs#)");

		updateReceptionServiceStatus.execute();
		var structUpdateReceptionServiceStatus = structNew();
		structUpdateReceptionServiceStatus.RETVAL = 1; // create
		if (arguments.svStatus == 1){
			structUpdateReceptionServiceStatus.RETDESC = 'Статус услуг\и изменен на "НЕ ОПЛАЧЕНО"!';
		}else if(arguments.svStatus == 2){
			structUpdateReceptionServiceStatus.RETDESC = 'Статус услуг\и изменен на "ОПЛАЧЕНО"!';
		}else if(arguments.svStatus == 3){
			structUpdateReceptionServiceStatus.RETDESC = 'Статус услуг\и изменен на "ГС СКАЗАЛА"!';
		}

		return structUpdateReceptionServiceStatus;

	}

}