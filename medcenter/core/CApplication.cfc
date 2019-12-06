component name="CApplication" output="false"{

function init(){

		// у каждого пользователя своя фабрика
		request.factoryService = createObject("component","core.factoryService").init();

		// система безопасности RBAC
		request.RBAC = request.factoryService.getService('rbac');
		//writeDUmp(request.RBAC.getMemento());

// ----------------------------------CCoreStart--------------------------------------------------------------------
		// Контроллер CCGI содержит в себе все cgi переменные
		// дублировать cgi переменные не надо
		request.CCGI = createObject("component","CCoreStart.CCGI").init();

		// Клиентские переменные client.* содержаться в базе, указатель в cookie (cfid и cftoken)
		// дублировать client переменные не надо
		request.CClient = createObject("component","CCoreStart.CClient").init();

		// контролируем переменные cookie.*, все кроме cfid и cftoken удаляется.
		// дублировать cookie переменные не надо
		request.CCookie = createObject("component","CCoreStart.CCookie").init();

		// все что пришло в урле контролируется здесь POST\GET form url и т.д
		request.CRequest = createObject("component","CCoreStart.CRequest").init();
	
		// Объект fireWall проверяет ip по базе и следит за уровнем предупреждений у пользователя.
		// Скорей всего фаервол не будет хранится в application а будет создаваться для каждого пользователя.
		// fierWall должен либо возвращать данные как он отработал, или содержать в себе эту структуру с данными
		request.factoryService.getService('CFireWall').runFireWall();

// ----------------------------------CRouter--------------------------------------------------------------------
		// мое мнение рутер запускать в любом случае а вот рендер пусть уже сам разбирается
		// в каком виде выводить информцию html или json

		//if (cgi.script_name is not '/ajax.cfc'){ // это условие для ajax запроса
		if ( request.CRequest.isAjax() is 'html'){ // это условие для ajax запроса
			// рутер
			CRouter = CreateObject("component","core.CRouter").Init();
			CRouter.run();
		} // это условие для ajax запроса
		//writeDump( request.CRequest.isAjax() );


// ----------------------------------CCoreStop--------------------------------------------------------------------
		// собираем все статистику и логи и записываем.
		// проверяем если редирект не пустой то редиректим.
		//writeDump(request.factoryService.getService('CLog').ReadLogging());

		// Записываем все что есть в логе
		//request.factoryService.getService('CLog').SaveLogging();

		// кидаем на редирект
		//objRedirect = request.factoryService.getService('redirector');
		//if (!objRedirect.getState()){
		//	objRedirect.redirect();
		//}
		//writeoutput('<hr>STOP!!!<hr>');
	}
}