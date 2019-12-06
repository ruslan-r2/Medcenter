/*
	contactsTypeAPI - ������ �����.
*/

component attributeName='contactsTypeAPI' output='false'{

	// ������ �����������
	instance.contactsTypeDAO = createObject('component', 'core.db.contactsTypeDAO' ).Init();

	instance.contactsType = {};

	function init(){
		return this;
	}
	// ������ ���������������� �����

	function getContactsTypeList(){
		qContactsType = instance.contactsTypeDAO.readContactsTypeList();
		return qContactsType;
	}

	function getMemento(){
		return instance;
	}
}