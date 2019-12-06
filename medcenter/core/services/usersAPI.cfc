/*
	users API - сервис
*/
component displayname="usersAPI" output="false" {

	// Псевдо конструктор
	instance = {users = '', userDAO = '' };

	instance.userDAO = createObject('component', 'core.db.userDAO' ).init();


		
	function init(){
		return this;
	}

	function getAllUserList(){
	        instance.users = instance.userDAO.readUsers();
		return instance.users;
	}

	function getUserList(){
	        instance.users = instance.userDAO.readUsers('5,9,13');
		return instance.users;
	}

	function getUser( userid ){
		qUser = instance.userDAO._readUser( arguments.userid );
		return qUser;
	}

	function getMemento(){
		return instance;
	}


}