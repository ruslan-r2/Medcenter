component displayname="Datasource" output="false" hint="Это класс базы данных." {
	// Псевдо-конструктор
	instance = { DSName = 'bbs_test', username = '', password = '' } ;

	function init(){ 
		/* Устанавливаем значения при инициализации модели */
		//instance.DSName = arguments.DSName;
		//instance.username = arguments.username;
		//instance.password = arguments.password;
		return this; 
	}

	// getters / accessors
	function getDSName() {
		return instance.DSName; 
	}
	
	function getUsername() {
		return instance.username;
	}
	
	function getPassword() {
		return instance.password;
	}
	
}