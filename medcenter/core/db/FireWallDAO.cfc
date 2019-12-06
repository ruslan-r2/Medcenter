/*	fireWallDAO - CRUD	*/

component displayname="fireWallDAO" output="false" {

	// Псевдо конструктор
	instance = {datasource = ''};

	function init(){
		instance.datasource = createObject('component', 'core.db.Datasource').init();
		return this;
	}

	// CRUD

	function readIP(required string userIP) {

		queryIP = new Query();
		queryIP.setName("readIP");
		queryIP.setTimeout("5");
		queryIP.setDatasource("#instance.datasource.getDSName()#");

		queryIP.addParam(name="ipFrom",value="#arguments.userIP#",cfsqltype="cf_sql_varchar");
   		queryIP.addParam(name="ipTo",value="#arguments.userIP#",cfsqltype="cf_sql_varchar");

		queryIP.setSQL("SELECT id, ipFrom, ipTo, isRange, dateTimeCreate, dateTimeEdite, type, description, ipCfid, ipCftoken FROM iplist WHERE ipFrom <= :ipFrom AND ipTo >= :ipTo");
	
		var execute = queryIP.execute(); // вся структура и result и prefix
		var result = execute.getResult();
		
		// доделать алгоритм удаления двойных записей

		var structIP=structNew();
		if (result.RecordCount gt 0) {
			setVariable('structIP.id',result.id);
			setVariable('structIP.ipFrom',result.ipFrom);
			setVariable('structIP.ipTo',result.ipTo);
			setVariable('structIP.isRange',result.isRange);
			setVariable('structIP.dateTimeCreate',result.dateTimeCreate);
			setVariable('structIP.dateTimeEdite',result.dateTimeEdite);
			setVariable('structIP.role',result.type);
			setVariable('structIP.description',result.description);
			setVariable('structIP.ipCfid',result.ipCfid);
			setVariable('structIP.ipCftoken',result.ipCftoken);
		}

		return structIP; //struct
		//return result;
	}
	
	function createIP(required string ipFrom, required string ipTo, required string isRange, required string dateTimeCreate, required string dateTimeEdite, required string role, required string description, required string ipCfid, required string ipCftoken){

			createIP = new Query();
			createIP.setDatasource("#instance.datasource.getDSName()#");
			createIP.setName("createIP");
			createIP.setTimeout("5");
			
			createIP.addParam(	name = "ipFrom", value = "#arguments.ipFrom#", cfsqltype = "cf_sql_varchar" );
			createIP.addParam(	name = "ipTo", value = "#arguments.ipTo#", cfsqltype = "cf_sql_varchar" );
			createIP.addParam(	name = "isRange", value = "#arguments.isRange#", cfsqltype = "cf_sql_varchar" );
			createIP.addParam(	name = "dateTimeCreate", value = "#arguments.dateTimeCreate#", cfsqltype = "cf_sql_timestamp" );
			createIP.addParam(	name = "dateTimeEdite", value = "#arguments.dateTimeEdite#", cfsqltype = "cf_sql_timestamp" );
			createIP.addParam(	name = "role", value = "#arguments.role#", cfsqltype = "cf_sql_varchar" );
			createIP.addParam(	name = "description", value = "#arguments.description#", cfsqltype = "cf_sql_varchar" );
			createIP.addParam(	name = "ipCfid", value = "#arguments.ipCfid#", cfsqltype = "cf_sql_varchar" );
			createIP.addParam(	name = "ipCftoken", value = "#arguments.ipCftoken#", cfsqltype = "cf_sql_varchar" );
	
			
			createIP.setSQL("INSERT INTO iplist ( ipFrom, ipTo, isRange, dateTimeCreate, dateTimeEdite, type, description, ipCfid, ipCftoken )
								VALUES (:ipFrom, :ipTo, :isRange, :dateTimeCreate, :dateTimeEdite, :role, :description, :ipCfid, :ipCftoken)
								");
			
			createIP.execute(); // вся структура и result и prefix
			// Думаю возвращать ничего не надо
	}

	function deleteIP(required string userIP) {
		deleteIP = new Query();
		deleteIP.setName("deleteIP");
		deleteIP.setTimeout("5");
		deleteIP.setDatasource("#instance.datasource.getDSName()#");

		deleteIP.addParam(name="ipFrom",value="#arguments.userIP#",cfsqltype="cf_sql_varchar");
   		deleteIP.addParam(name="ipTo",value="#arguments.userIP#",cfsqltype="cf_sql_varchar");

		deleteIP.setSQL("DELETE FROM iplist WHERE ipFrom <= :ipFrom AND ipTo >= :ipTo");
	
		var execute = deleteIP.execute(); // вся структура и result и prefix
		var result = execute.getResult();
		//return result;
	}

	function updateIP(required string userIP, required string dateTimeEdite, required string role, required string description, required string ipCfid, required string ipCftoken){

			updateIP = new Query();
			updateIP.setDatasource("#instance.datasource.getDSName()#");
			updateIP.setName("update");
			updateIP.setTimeout("5");

			updateIP.addParam(	name = "ipFrom", value = "#arguments.userIP#", cfsqltype = "cf_sql_varchar" );
			updateIP.addParam(	name = "ipTo", value = "#arguments.userIP#", cfsqltype = "cf_sql_varchar" );
			//updateIP.addParam(	name = "isRange", value = "#arguments.isRange#", cfsqltype = "cf_sql_varchar" );
			//updateIP.addParam(	name = "dateTimeCreate", value = "#arguments.dateTimeCreate#", cfsqltype = "cf_sql_timestamp" );
			updateIP.addParam(	name = "dateTimeEdite", value = "#arguments.dateTimeEdite#", cfsqltype = "cf_sql_timestamp" );
			updateIP.addParam(	name = "role", value = "#arguments.role#", cfsqltype = "cf_sql_varchar" );
			updateIP.addParam(	name = "description", value = "#arguments.description#", cfsqltype = "cf_sql_varchar" );
			updateIP.addParam(	name = "ipCfid", value = "#arguments.ipCfid#", cfsqltype = "cf_sql_varchar" );
			updateIP.addParam(	name = "ipCftoken", value = "#arguments.ipCftoken#", cfsqltype = "cf_sql_varchar" );

			updateIP.setSQL("UPDATE iplist 
					SET 
					dateTimeEdite=:dateTimeEdite,
					type=:role,
					description=:description,
					ipCfid=:ipCfid,
					ipCftoken=:ipCftoken 
					WHERE ipFrom <= :ipFrom AND ipTo >= :ipTo ");

			updateIP.execute(); // вся структура и result и prefix
			// Думаю возвращать ничего не надо
	}
}