/*
  объект userIP - userIP object
*/

component displayname="userIP" output="false" {

	// Псевдо конструктор
	// Таблица в базе данных - id, ipFrom, ipTo, isRange, dateTimeCreate, dateTimeEdite, type, description, ipCfid, ipCftoken
	instance.userIP = structNew(); // структура
	instance.userIP.currentIp = '';
	instance.userIP.warnings = 0;
	//из базы
	instance.userIP.ipFrom = '';
	instance.userIP.ipTo = '';
	instance.userIP.isRange = 'No';
	instance.userIP.dateTimeCreate = '#now()#';
	instance.userIP.dateTimeEdite = '#now()#';
	instance.userIP.role = 'user';
	instance.userIP.description = '';
	instance.userIP.ipCfid = '#client.CFID#';
	instance.userIP.ipCftoken = '#client.CFToken#';
	
	function init(){return this;}

	//Getters
	function getCurrentIp(){return instance.userIP.currentIp;}
	function getWarnings(){return instance.userIP.warnings;}
	function getIpFrom(){return instance.userIP.ipFrom;}
	function getIpTo(){return instance.userIP.ipTo;}
	function getIsRange(){return instance.userIP.isRange;}
	function getDateTimeCreate(){return instance.userIP.dateTimeCreate;}
	function getDateTimeEdite(){return instance.userIP.dateTimeEdite;}
	function getRole(){return instance.userIP.role;}
	function getDescription(){return instance.userIP.description;}
	function getIpCfid(){return instance.userIP.ipCfid;}
	function getIpCftoken(){return instance.userIP.ipCftoken;}

	//Setters
	function setCurrentIp(required string currentIp){instance.userIP.currentIp = arguments.currentIp;}
	function setWarnings(required numeric warnings){instance.userIP.warnings = arguments.warnings;}
	function setIpFrom(required string ipFrom){instance.userIP.ipFrom = arguments.ipFrom;}
	function setIpTo(required string ipTo){instance.userIP.ipTo = arguments.ipTo;}
	function setIsRange(required string isRange){instance.userIP.isRange = arguments.isRange;}
	function setDateTimeCreate(required string dateTimeCreate){instance.userIP.dateTimeCreate = arguments.dateTimeCreate;}
	function setDateTimeEdite(required string dateTimeEdite){instance.userIP.dateTimeEdite = arguments.dateTimeEdite;}
	function setRole(required string role){instance.userIP.role = arguments.role;}
	function setDescription(required string description){instance.userIP.description = arguments.description;}
	function setIpCfid(required string ipCfid){instance.userIP.ipCfid = arguments.ipCfid;}
	function setIpCftoken(required string ipCftoken){instance.userIP.ipCftoken = arguments.ipCftoken;}

	// Для дебаагера
	function getMemento(){return instance.userIP;}
}