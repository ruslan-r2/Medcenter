/*
	sickListsAPI - список услуг.
*/

component attributeName='sickListsAPI' output='false'{

	// Псевдо конструктор
	instance.sickListsDAO = createObject('component', 'core.db.sickListsDAO' ).Init();

	function init(){
		return this;
	}

	function getAllSickLists(){
		qSickLists = instance.sickListsDAO.readSickLists();
		return qSickLists;
	}

	/*
	сделать функцию открытия больничного листа
	сделать функцию продления больничного листа с проверкой сколько раз можно продлять
	сделать функцию проверки открытия больничного листа у пользователя у доктора и в каком приёме
	сделать ...
	*/

	// добавить функцию в которой будут хранится статусы больничных листов
	function findSickList( rpID, userID, ptID, slStatus ){
		qFindSL = instance.sickListsDAO.findSickList( arguments.rpID, arguments.userID, arguments.ptID, arguments.slStatus );
		return qFindSL;
	}

}