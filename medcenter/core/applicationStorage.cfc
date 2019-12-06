/*
	Контроллер переменных приложения - applicationStorage
*/

component displayname="applicationStorage" output="false" {

	// Псевдо конструктор
	//lock scope="application" type="exclusive" timeout="5" {
		application.object = structNew();
		//application.object = {};
	//}
	
	function init(){
		//getObject('settings');
		return this;
	}
	
	function getObject(required string object){
		//lock scope="application" type="readonly" timeout="5" {
			aobject = application.object;
		//}
	    if (StructKeyExists(aobject,arguments.object)) {
    		return aobject[arguments.object];
	    } else {
    		//lock scope="application" type="exclusive" timeout="5" {
			application.object[arguments.object] = CreateObject('component','core.#arguments.object#').init();
			return application.object[arguments.object];
    		//}
	    }

	}

	function getMemento(){
		//lock scope="application" type="readonly" timeout="5" {
			return application.object;
		//}
	}

}