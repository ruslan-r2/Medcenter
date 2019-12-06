/*
*/
component displayname="settingsDAO" output="false" {

	// ������ �����������
	instance = {datasource = ''} ; // ������
	instance.datasource = createObject('component', 'core.db.Datasource').init();

	function init() {
		return this ;
	}

	function readSettings(){
		qSettings = new Query();
		qSettings.setName("settings");
		qSettings.setTimeout("5");
		qSettings.setDatasource("#instance.datasource.getDSName()#");
		qSettings.setSQL("select * from bbs_settings");

		var result = qSettings.execute(); // ��� ��������� � result � prefix
		var dataSetting=result.getResult();
		return dataSetting; // ���������� query
	}
}