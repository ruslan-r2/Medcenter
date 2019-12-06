/*
*/
component displayname="schedulesDAO" output="false" {

	// ������ �����������
	instance = {datasource = ''} ; // ������
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

		var result = qSchedules.execute(); // ��� ��������� � result � prefix
		var data=result.getResult();
		return data; // ���������� query
	}
}