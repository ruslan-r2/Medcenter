component displayname="LogDAO" output="false" {

	//Псевдо конструктор --->
	instance = {datasource = ''};
	instance.datasource = createObject('component', 'core.db.Datasource').init();

	function init(){
		return this;
	}

	function CreateLogging(required any dateTimeCreate, required string UserIP, required string ssection, required string type, required string surl, required string description, required string CFID, required string CFToken) {
		try {
			CreateLogging = new Query();
			CreateLogging.setDatasource("#instance.datasource.getDSName()#");
			CreateLogging.setName("insertLogging");
			CreateLogging.setTimeout("5");
			
			CreateLogging.addParam(	name = "dateTimeCreate", value = "#arguments.dateTimeCreate#", cfsqltype = "cf_sql_timestamp" );
			CreateLogging.addParam(	name = "UserIP", value = "#arguments.UserIP#", cfsqltype = "cf_sql_varchar" );
			CreateLogging.addParam(	name = "ssection", value = "#arguments.ssection#", cfsqltype = "cf_sql_varchar" );
			CreateLogging.addParam(	name = "type", value = "#arguments.type#", cfsqltype = "cf_sql_varchar" );
			CreateLogging.addParam(	name = "surl", value = "#arguments.surl#", cfsqltype = "cf_sql_varchar" );
			CreateLogging.addParam(	name = "description", value = "#arguments.description#", cfsqltype = "cf_sql_varchar" );
			CreateLogging.addParam(	name = "CFID", value = "#arguments.CFID#", cfsqltype = "cf_sql_varchar" );
			CreateLogging.addParam(	name = "CFToken", value = "#arguments.CFToken#", cfsqltype = "cf_sql_varchar" );

			CreateLogging.setSQL("INSERT INTO bbs_log ( dateTimeCreate, UserIP, ssection, type, surl, description, CFID, CFToken )
						VALUES (:dateTimeCreate, :UserIP, :ssection, :type, :surl, :description, :CFID, :CFToken)
						");
			
			ss = CreateLogging.execute(); // вся структура и result и prefix
			//writeDump(ss);
		}
		catch (database e) {
			// В этом месте лучше сохранять сразу в файл так как база не доступна.
			// При этом приложение продолжает выполняться без крэша
			// Надо сохранять то что пришло + если ошибка произошла и ее сохранить !!!
			
			//writeOutPut('Ошибка при записи в базу. Пишем в файл.');
			CRLF = Chr(13)&Chr(10);
			request.factoryService.getService('fileManager').addToTextFile('log/log.txt','#arguments.dateTimeCreate#,#arguments.UserIP#,#arguments.ssection#,#arguments.type#,#arguments.surl#,#arguments.description#,#arguments.CFID#,#arguments.CFToken##CRLF#');
			//writeDump( request.factoryService.getService('fileManager').readTxtFile('log/log.txt') );
			//writeDump(e);
			//throw(message='#e.message#', detail = '#e.detail#', ErrorCode='#e.ErrorCode#');
			//abort;
		}
	}
}