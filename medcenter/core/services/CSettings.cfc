/*
	������ ��������� ���������� � ���� ��� ������ �� �������� ������� �������� ���
	����� ����������.

	������ � ���� bbs_test � � ������� bbs_settings ����� � ���������� DAOSettings.
	DAOSettings ���������� ��������� � ������� ���������� ��� ������ ������� bbs_settings
*/

component displayname="CSettings" output="false" {

	lock scope="application" type="exclusive" timeout="5" {
		instance.settings = application.applicationStorage.getObject('settings'); // ������ ������ application
	}

	function init() {
		return this;
	}
	

	// ���� ����� ���������� ������ ���� ��� ��� ������ ����������
	function setSettings(){
		//settingsDAO - ������;
		settingsDAO = createObject("component", "core.db.settingsDAO").init();

		lock scope="application" type="exclusive" timeout="5" {
			instance.settings.setSettings(settingsDAO.readSettings()); // ������ ����������
		}
	}

	function getSettings(string category='', string type='struct'){
		if (arguments.category=='') {
			return instance.settings.getSettings(); // ��� ��������� settings
		} else {
			return instance.settings.getSettings(arguments.category,arguments.type); // ��������� ������������� ������
		}

	}
	/*
	function getSettings(category='') {
		if (category=='') {
			return instance.settings.getSettings(); // ��� ��������� settings
		} else {
			// �� ����� �������
			if (structKeyExists(instance.settings.getSettings(),category)){
				return instance.settings.getSettings(category); // ��������� ������������� ������
			}else{
				writeOutPut('������������� ��������� ��� � ����: #category#');
				abort;
			}
		}
	}
	*/

	
}