/*
	userServicesAPI - ������ �����.
*/

component attributeName='usersServicesAPI' output='false'{

	// ������ �����������
	instance.usersServicesDAO = createObject('component', 'core.db.usersServicesDAO' ).Init();

	//instance.services = {};

	function init(){
		return this;
	}

	// ������ ���������������� �����
	function getUserServices( userID, _date ){
		qUserServices = instance.usersServicesDAO.readUserServices( arguments.userID, arguments._date );
		return qUserServices;
	}

	// CRUD

	function getMemento(){
		return instance;
	}
}