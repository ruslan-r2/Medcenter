component displayName='contactsTypeDAO'{

	// Псевдо конструктор
	instance = {datasource = ''} ; // объект
	instance.datasource = createObject('component', 'core.db.Datasource').init();


	function Init (){
		return this;
	}

	function readContactsTypeList(){
		qContactsTypeList = new Query();
		qContactsTypeList.setName("readContactsTypeList");
		qContactsTypeList.setTimeout("5");
		qContactsTypeList.setDatasource("#variables.instance.datasource.getDSName()#");

		qContactsTypeList.setSQL("SELECT * FROM contacts_types");
	
		var execute = qContactsTypeList.execute(); // вся структура и result и prefix
		var result = execute.getResult();
		return result; //query
	}

}