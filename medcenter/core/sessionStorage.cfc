/*
  Контроллер сессий - sessionStorage
*/

component displayname="sessionStorage" output="false" {

	// Псевдо конструктор
	//lock scope="session" type="exclusive" timeout="15" {
		session.object = structNew();
		//session.object = {};
	//}
	
	function init(){
		//getObject('user');
		return this;
	}
	
	function getObject(required string object){
		//lock scope="session" type="readonly" timeout="15" {
			sobject = session.object;
		//}
	    if (StructKeyExists(sobject,arguments.object)) {
    		return sobject[arguments.object];
	    } else {
    		//lock scope="session" type="exclusive" timeout="15" {
			session.object[arguments.object] = CreateObject('component','core.models.#arguments.object#').init();
			return session.object[arguments.object];
    		//}
	    }

	}

	function getMemento(){
		//lock scope="session" type="readonly" timeout="15" {
			return session.object;
		//}
	}

}