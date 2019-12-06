/*	20.02.2012 - AlRus( Repin R.).
* 	Фабрика сервисов
* 	Если сервис уже создан возвращает сервис в виде объекта,
* 	если сервис еще не созда, создает и возвращает сервис в виде объекта.
*/

component name='factoryService' output='false'{

	// Псевдо конструктор
	instance.services = structNew();

	function init(){
		// можно при первом запуске создать сервис сразу, например CSettings
		// но лучше создавать сервис в той части скрипта где это нужно!!!
		return this;
	}

	function getService(required string service){
	    if (StructKeyExists(instance.services,arguments.service)) {
	      return instance.services[arguments.service];
	    } else {
	      instance.services[arguments.service]=CreateObject('component','core.services.#arguments.service#').init();
	      return instance.services[arguments.service];
	    }
	}

	function getMemento(){
		return instance;
	}


}