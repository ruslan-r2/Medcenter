/*
	sickListsAPI - ������ �����.
*/

component attributeName='sickListsAPI' output='false'{

	// ������ �����������
	instance.sickListsDAO = createObject('component', 'core.db.sickListsDAO' ).Init();

	function init(){
		return this;
	}

	function getAllSickLists(){
		qSickLists = instance.sickListsDAO.readSickLists();
		return qSickLists;
	}

	/*
	������� ������� �������� ����������� �����
	������� ������� ��������� ����������� ����� � ��������� ������� ��� ����� ��������
	������� ������� �������� �������� ����������� ����� � ������������ � ������� � � ����� �����
	������� ...
	*/

	// �������� ������� � ������� ����� �������� ������� ���������� ������
	function findSickList( rpID, userID, ptID, slStatus ){
		qFindSL = instance.sickListsDAO.findSickList( arguments.rpID, arguments.userID, arguments.ptID, arguments.slStatus );
		return qFindSL;
	}

}