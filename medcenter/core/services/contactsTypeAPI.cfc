/*
	contactsTypeAPI - список услуг.
*/

component attributeName='contactsTypeAPI' output='false'{

	// ѕсевдо конструктор
	instance.contactsTypeDAO = createObject('component', 'core.db.contactsTypeDAO' ).Init();

	instance.contactsType = {};

	function init(){
		return this;
	}
	// список пользовательских групп

	function getContactsTypeList(){
		qContactsType = instance.contactsTypeDAO.readContactsTypeList();
		return qContactsType;
	}

	function getMemento(){
		return instance;
	}
}