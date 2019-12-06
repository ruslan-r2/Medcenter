/*
	Данный контролер объединяет в себе всю логику по созданию объекта настроек для
	всего приложения.

	Доступ к базе bbs_test и к таблице bbs_settings скрыт в компаненте DAOSettings.
	DAOSettings возвращает структуру в которой содержатся все записи таблици bbs_settings
*/

component displayname="CSettings" output="false" {

	lock scope="application" type="exclusive" timeout="5" {
		instance.settings = application.applicationStorage.getObject('settings'); // объект причем application
	}

	function init() {
		return this;
	}
	

	// этот метот вызывается только один раз при страте приложения
	function setSettings(){
		//settingsDAO - объект;
		settingsDAO = createObject("component", "core.db.settingsDAO").init();

		lock scope="application" type="exclusive" timeout="5" {
			instance.settings.setSettings(settingsDAO.readSettings()); // Объект приложения
		}
	}

	function getSettings(string category='', string type='struct'){
		if (arguments.category=='') {
			return instance.settings.getSettings(); // вся структура settings
		} else {
			return instance.settings.getSettings(arguments.category,arguments.type); // структура определенного модуля
		}

	}
	/*
	function getSettings(category='') {
		if (category=='') {
			return instance.settings.getSettings(); // вся структура settings
		} else {
			// На время отладки
			if (structKeyExists(instance.settings.getSettings(),category)){
				return instance.settings.getSettings(category); // структура определенного модуля
			}else{
				writeOutPut('Запрашиваемой категории нет в базе: #category#');
				abort;
			}
		}
	}
	*/

	
}