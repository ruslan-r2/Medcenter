component attributeName='menu' {

	function Init(pageName='') {
		instance.pageCurrent=arguments.pageName;
		instance.noteCount=0;
		return this;
	}

	function renderMenu(string object, string operation, string pageName, string url, ssl='false'){
		rbac = request.RBAC;
		var element = '';
		if ( rbac.CheckAccess(#arguments.object#,#arguments.operation#) ){
			if (instance.pageCurrent==#arguments.object#) {
				element &= '
					 <b>#arguments.pageName#</b> | ';
			}else{
				element &= '
					 <a href="#request.CRequest.updateURL(arguments.ssl,arguments.url)#">#arguments.pageName#</a> | ';
			}
		}
		return element;
	}


	function View() {
		menu = '';
		menu &= '
			<div class="grid_16">
				<div class="signin-box" style="text-align:left;background:##f1f1f1">';

		// Панель администратора
		menu &= #renderMenu('RBAC','access','RBAC','/?page=rbac')#;
		menu &= #renderMenu('typeEmployees','access','Типы служащих','/?page=typeEmployees')#;
		menu &= #renderMenu('users','access','Пользователи','/?page=users')#;
		menu &= #renderMenu('companysDms','access','Компании ДМС','/?page=companysDms')#;

		// Бухгалтерия
		menu &= #renderMenu('services','access','Услуги','/?page=services')#;
		menu &= #renderMenu('servicesType','access','Типы услуг','/?page=servicesType')#;
		menu &= #renderMenu('usersInterest','access','% от услуг','/?page=usersInterest')#;

		// Составители графиков
		menu &= #renderMenu('usersGraphics','access','График врачей','/?page=usersGraphics')#;

		// Регистратура
		menu &= #renderMenu('reception','access','Регистратура','/?page=reception')#;
		menu &= #renderMenu('patients','access','Картотека','/?page=patients')#;

		// Врач
		menu &= #renderMenu('cabinet','access','Кабинет','/?page=cabinet')#;
		menu &= #renderMenu('sickLists','access','Больничные','/?page=sickLists')#;

		//Настройки пользователя
		menu &= #renderMenu('settings','access','Настройки','/?page=settings')#;

		// ткмповая страница
		menu &= #renderMenu('temp','access','Темп','/?page=temp')#;

		menu &= '
				</div>
			</div> ';

		return menu;
	}
}