/*
	Нужно дописать СЕТТЕР и ГЕТТЕР.
	Нужно стравнить сравнить то что есть в базе и то что есть по умолчанию.
	лишнее удалить , недостающее добавить.

*/
component displayname="CClient" {

	// в лок обернуть
	instance._default = structNew();
	structAppend( instance._default, request.factoryService.getService('CSettings').getSettings('system') );
	structAppend( instance._default, request.factoryService.getService('CSettings').getSettings('menu') );
	structAppend( instance._default, request.factoryService.getService('CSettings').getSettings('user') );
	structAppend( instance._default, request.factoryService.getService('CSettings').getSettings('services') );
	structAppend( instance._default, request.factoryService.getService('CSettings').getSettings('reception') );
	//writeDump(instance._default);
	instance._client = structNew();
	
	function init(){
		
		instance._client = client; //Сюда помещаются клиентские данные которые есть в БД
		// потом поменять request на application
		//writeDump(instance._client);
		
		for (key in instance._default){
			if ( !structKeyExists(instance._client, '#key#') || instance._client['#key#'] is ''){
				client[key] = instance._default[key];
				instance._client[key] = instance._default[key];
			}
		}
		// Удаление старых клиентских переменных.
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
		enableVarList=StructKeyList(instance._default); // если написать переменные как javascript и javaScript, скрипт не сработает

		for ( i=1; i<=ListLen(clientVarList); i++) {
			varName=ListGetAt(clientVarList,i);
			if (!ListFind(enableVarList,varName)) {
				DeleteClientVariable(varName);
			}
		}
	}

}
