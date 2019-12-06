component displayName='usersServicesDAO'{

	// ������ �����������
	instance = {datasource = ''} ; // ������
	instance.datasource = createObject('component', 'core.db.Datasource').init();


	function Init (){
		return this;
	}

	function readUserServices( userID, date ){
		qUserServices = new Query();
		qUserServices.setName("readUserServices");
		qUserServices.setTimeout("5");
		qUserServices.setDatasource("#variables.instance.datasource.getDSName()#");

		qUserServices.setSQL("SELECT * FROM services WHERE user_id = #arguments.userID# AND sv_date = #arguments.date#");
	
		var execute = qUserServices.execute(); // ��� ��������� � result � prefix
		var result = execute.getResult();
		return result; //query
	}

}