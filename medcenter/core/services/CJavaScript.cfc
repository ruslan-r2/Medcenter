/*
	Данный объект сохраняет в себе пути скриптов JavaScript всех меню сайта.
	В момен инициализации виджета, если динамическое с javaScript то в этот объект
	добавляется путь это скрипта.
*/
component attributeName='CJavaScript' output='false'{

	// Псевдо конструктор
	instance.listJScripts = structNew();
	instance.listJScripts.pasport = '/js/jquery.js,/js/jquery.validate.js,/js/authorization.js';
	instance.listJScripts.registration = '/js/jquery.js,/js/jquery.validate.js,/js/registration.js';
	instance.listJScripts.reception = '/js/jquery.js,/js/jquery.pickmeup.min.js,/js/calendar.js,/js/reception.js';
	instance.listJScripts.cabinet = '/js/jquery.js,/js/jquery.pickmeup.min.js,/js/calendar1.js,/js/cabinet.js';
	instance.listJScripts.temp = '/js/jquery.js,/js/temp1.js';
	//instance.listJScripts.patients = '/js/jquery.js,/js/jquery.maskedinput.js,/js/input.js';
	instance.listJScripts.services = '/js/jquery.js,/js/jquery.tooltipster.min.js,/js/title.js';
	instance.listJScripts.companysDMS = '/js/jquery.js,/js/jquery.pickmeup.min.js,/js/calendar2.js';

	function init(){
		return this;
	}

	function getListJScripts(string page) {
		if (StructKeyExists(instance.listJScripts,arguments.page)) {
			return instance.listJScripts[arguments.page];
		} else {
			return '';
		}
	}

	/*
	function addJScript(string filename=''){
		listAppend(instance.listJScripts, arguments.filename, ',');
	}
	*/
}