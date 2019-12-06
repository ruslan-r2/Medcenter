/*
  пользователь объект - user object
*/

component displayname="user" output="false" {

	// Псевдо конструктор
	instance.user = structNew(); // структура
	instance.user.id = 1;
	instance.user.Name = 'Гость';
	instance.user.family = '';
	instance.user.firstname = '';
	instance.user.lastname = '';
	instance.user.type = ''; // гость - guest
	instance.user.groups = '1'; // гость - guest
	// либо доверить назначение группы модулю RBAC
	
	function init(){return this;}

	//Геттеры
	function getUserId(){return instance.user.id;}
	function getUserName(){return instance.user.Name;}
	function getUserFamily(){return instance.user.family;}
	function getUserFirstName(){return instance.user.firstname;}
	function getUserLastName(){return instance.user.lastname;}
	function getUserType(){return instance.user.type;}
	function getUserGroups(){return instance.user.groups;}
	
	// Сеттеры
	function setUserId(required numeric id){instance.user.id = arguments.id;}
	function setUserName(required string name){instance.user.Name = arguments.name;}
	function setUserFamily(required string family){instance.user.family = arguments.family;}
	function setUserFirstName(required string firstname){instance.user.firstname = arguments.firstname;}
	function setUserLastName(required string lastname){instance.user.lastname = arguments.lastname;}
	function setUserType(string type){instance.user.type = arguments.type;}
	function setUserGroups(string groups){instance.user.groups = arguments.groups;}
	
	// Для дебаагера
	function getMemento(){return instance.user;}

}