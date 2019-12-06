/*
	����� �������� ������ � ������.
	����� ��������� �������� �� ��� ���� � ���� � �� ��� ���� �� ���������.
	������ ������� , ����������� ��������.

*/
component displayname="CClient" {

	// � ��� ��������
	instance._default = structNew();
	structAppend( instance._default, request.factoryService.getService('CSettings').getSettings('system') );
	structAppend( instance._default, request.factoryService.getService('CSettings').getSettings('menu') );
	structAppend( instance._default, request.factoryService.getService('CSettings').getSettings('user') );
	structAppend( instance._default, request.factoryService.getService('CSettings').getSettings('services') );
	structAppend( instance._default, request.factoryService.getService('CSettings').getSettings('reception') );
	//writeDump(instance._default);
	instance._client = structNew();
	
	function init(){
		
		instance._client = client; //���� ���������� ���������� ������ ������� ���� � ��
		// ����� �������� request �� application
		//writeDump(instance._client);
		
		for (key in instance._default){
			if ( !structKeyExists(instance._client, '#key#') || instance._client['#key#'] is ''){
				client[key] = instance._default[key];
				instance._client[key] = instance._default[key];
			}
		}
		// �������� ������ ���������� ����������.
		DeleteOld();
		return this;
	}

	function getClient(varClient='') {
		if (varClient=='') {
			return instance._client;
		} else {
			return instance._client[varClient];
		}
	}
	
	function getMemento(){
		return instance;
	}

	function DeleteOld() {
		clientVarList=GetClientVariablesList();
		enableVarList=StructKeyList(instance._default); // ���� �������� ���������� ��� javascript � javaScript, ������ �� ���������

		for ( i=1; i<=ListLen(clientVarList); i++) {
			varName=ListGetAt(clientVarList,i);
			if (!ListFind(enableVarList,varName)) {
				DeleteClientVariable(varName);
			}
		}
	}

}
