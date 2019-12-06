/*
*/
component displayname="schedulesDAO" output="false" {

	// Псевдо конструктор
	instance = {datasource = ''} ; // объект
	instance.datasource = createObject('component', 'core.db.Datasource').init();

	function init() {
		return this ;
	}

	function readSchedules(){
		qSchedules = new Query();
		qSchedules.setName("schedules");
		qSchedules.setTimeout("5");
		qSchedules.setDatasource("#instance.datasource.getDSName()#");
		qSchedules.setSQL("select * from schedules");

		var result = qSchedules.execute(); // вся структура и result и prefix
		var data=result.getResult();
		return data; // возвращает query
	}
}