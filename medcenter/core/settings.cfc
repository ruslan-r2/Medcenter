component displayname="settings" output="false" {

	//instance.structSettings = structNew();
	instance.querySettings = structNew();
	
	function init(){
		return this;
	}

	function setSettings(required query settings) {
		// нужна проверка на пустой query
		instance.querySettings = arguments.settings;
	}

	function getSettings(string category='', string type='struct') { // type: struct, query

		var _qSettings = instance.querySettings;
		qSettings = new Query();
		qSettings.setName("querySettings");
		qSettings.setTimeout("5");
		qSettings.setAttributes(tableSettings = _qSettings);
		// --------------------------------------------------------------------------------------------------------------------------
		if (arguments.category==''){
			var select ="SELECT * FROM tableSettings";
		}else{
			var select ="SELECT * FROM tableSettings WHERE category = '#arguments.category#'";
		}
		// --------------------------------------------------------------------------------------------------------------------------
		qSettings.setSQL(select);

		var result = qSettings.execute(dbtype="query"); // вся структура и result и prefix
		var querySettings = result.getResult();

		if (arguments.type == 'struct'){
			var structSettings=structNew();
			if (querySettings.RecordCount gt 0) {
				for (x=1; x<=querySettings.RecordCount; x++) {
					setVariable('structSettings.#querySettings.cfvar[x]#',querySettings.data[x]);
					// структура ключ-значение
				}
			}
			return structSettings;
		}else{
			return querySettings; // возвращает query
		}
	}

	function getMemento(){
		return instance;
	}

	
}