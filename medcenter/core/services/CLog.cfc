/*
  Сервис ЖУРНАЛ - Service CLOG
*/

component displayname="CLog" output="false" {

	// Псевдо конструктор
	instance = {objLogDAO = ''};
	instance.objLogDAO = createObject('component', 'core.db.logDAO' ).init();
	
	function init(){
		return this;
	}

	// Интерфейс функции Журнала-Log и LogDAO . ЛОГИКА.
	function AddLogging(required string ssection, required string type, string description){

	        // каждый раз запрашивать
		lock scope="session" type="readonly" timeout="5" {
			userIP = session.sessionStorage.getObject('userIP'); // сесионный Объект
		}
		// потом сделать переменные cgi и client через интерфейс
		// записываем в базу
		instance.objLogDAO.CreateLogging(
			now(),			//dateTimeCreate, // время создания саписи
			userIP.getCurrentIp(),	//userIP,// IP адрес пользователя
			arguments.ssection,	// скрипт в котором произошло событие\ошибка
			arguments.type, 	// тип событие\ошибка
			cgi.QUERY_STRING,	//surl,	// url в момент ошибки
			arguments.description,	// полное описание
			client.CFID,		// CFID пользователя
			client.CFToken);	// CFToken пользователя
	}

}