/*
*/
component displayname="phrasesDAO" output="false" {

	/* Псевдо конструктор */
	instance = {datasource = ''} ; // объект

	function init() {
		instance.datasource = createObject('component', 'core.db.Datasource').init();
		return this ;
	}
	
	function readPhrases( userID, phKey ) {
		qPhrases = new Query();
		qPhrases.setName("qPhrases");
		qPhrases.setTimeout("5");
		qPhrases.setDatasource("#variables.instance.datasource.getDSName()#");

		qPhrases.setSQL("SELECT * FROM phrases WHERE user_id = '#arguments.userID#' AND ph_key = '#arguments.phKey#'");
	
		var execute = qPhrases.execute(); // вся структура и result и prefix
		var result = execute.getResult();

		return result;
	}

	function createPhrase(required numeric userID, required string phKey, required string phValue ) {
		// дописать время создания и ip
		createPhrase = new Query();
		createPhrase.setDatasource("#instance.datasource.getDSName()#");
		createPhrase.setName("createPhrase");
		createPhrase.setTimeout("5");
		createPhrase.addParam(name = "userID", value = "#arguments.userID#", cfsqltype = "cf_sql_integer" );
		createPhrase.addParam(name = "phKey", value = "#arguments.phKey#", cfsqltype = "cf_sql_varchar" );
		createPhrase.addParam(name = "phValue", value = "#arguments.phValue#", cfsqltype = "cf_sql_varchar" );
			
		createPhrase.setSQL("INSERT INTO phrases ( user_id, ph_key, ph_value )
			VALUES ( :userID, :phKey, :phValue )
			");

		createPhrase.execute(); // вся структура и result и prefix

		var structCreatePhrase = structNew();
		structCreatePhrase.RETVAL = 1; // create
		structCreatePhrase.RETDESC = 'Фраза добавлена.';
		return structCreatePhrase;
	}

	function deletePhrase(required numeric userID, required string phKey, required string phValue ) {
		// дописать время создания и ip
		deletePhrase = new Query();
		deletePhrase.setDatasource("#instance.datasource.getDSName()#");
		deletePhrase.setName("deletePhrase");
		deletePhrase.setTimeout("5");
		deletePhrase.addParam(name = "userID", value = "#arguments.userID#", cfsqltype = "cf_sql_integer" );
		deletePhrase.addParam(name = "phKey", value = "#arguments.phKey#", cfsqltype = "cf_sql_varchar" );
		deletePhrase.addParam(name = "phValue", value = "#arguments.phValue#", cfsqltype = "cf_sql_varchar" );

		deletePhrase.setSQL("DELETE FROM phrases WHERE user_id = :userID AND ph_key = :phKey AND ph_value = :phValue");			

		deletePhrase.execute(); // вся структура и result и prefix

		var structDeletePhrase = structNew();
		structDeletePhrase.RETVAL = 1; // create
		structDeletePhrase.RETDESC = 'Фраза удалена!';
		return structDeletePhrase;
	}

}