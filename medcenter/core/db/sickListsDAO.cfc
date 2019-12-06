component displayName='sickListsDAO'{

	// Псевдо конструктор
	instance = {datasource = ''} ; // объект
	instance.datasource = createObject('component', 'core.db.Datasource').init();


	function Init (){
		return this;
	}

	function readSickLists(){

		qSickList = new Query();
		qSickList.setName("readSickLists");
		qSickList.setTimeout("5");
		qSickList.setDatasource("#variables.instance.datasource.getDSName()#");

		qSickList.setSQL("SELECT * FROM sick_lists");
	
		var execute = qSickList.execute(); // вся структура и result и prefix
		var result = execute.getResult();
		return result; //query
	}

	function findSickList( rpID, userID, ptID, slStatus ){

		//rpID = arguments.rpID;
		//userID = arguments.userID;
		//ptID = arguments.ptID;
		//slStatus = arguments.slStatus;
		writeDump(arguments);

		qFindSL = new Query();
		qFindSL.setName("findSickList");
		qFindSL.setTimeout("5");
		qFindSL.setDatasource("#variables.instance.datasource.getDSName()#");

		qFindSL.setSQL("SELECT * FROM sick_lists");
	
		var execute = qFindSL.execute(); // вся структура и result и prefix
		var result = execute.getResult();
		return result; //query
	}

}