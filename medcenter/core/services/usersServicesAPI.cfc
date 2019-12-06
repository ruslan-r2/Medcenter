/*
	userServicesAPI - список услуг.
*/

component attributeName='usersServicesAPI' output='false'{

	// Псевдо конструктор
	instance.usersServicesDAO = createObject('component', 'core.db.usersServicesDAO' ).Init();

	//instance.services = {};

	function init(){
		return this;
	}

	// список пользовательских групп
	function getUserServices( userID, _date ){
		qUserServices = instance.usersServicesDAO.readUserServices( arguments.userID, arguments._date );
		return qUserServices;
	}

	// CRUD

	function getMemento(){
		return instance;
	}
}