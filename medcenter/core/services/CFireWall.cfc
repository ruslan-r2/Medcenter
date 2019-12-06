/*
  Сервис FireWall - Service CFireWall
*/

component displayname="CFireWall" output="false" {

	// Псевдо конструктор
	instance = {UserIp = '', fireWallDAO = '' };
	instance.result = structNew(); // для управления выводом страници warnings
	//instance.result.state = true;
	//instance.result.reason = '';

	instance.fireWallDAO = createObject('component', 'core.db.fireWallDAO' ).init();
	lock scope="session" type="exclusive" timeout="5" {
		instance.UserIp = session.sessionStorage.getObject('userIP'); // сесионный Объект
	}
	
	function init(){
		return this;
	}
	
	function runFireWall(){

		var REMOTE_ADDR = request.CCGI.getCGI('REMOTE_ADDR');
		//var REMOTE_ADDR = '66.249.65.184';

		if ( instance.UserIp.getCurrentIp() NEQ REMOTE_ADDR ){ // если ip поменялся в одной сессии то нужно удалить предидущий из базы
			instance.UserIp.setCurrentIp('#REMOTE_ADDR#');
			structIP = instance.fireWallDAO.readIP('#REMOTE_ADDR#');
			if ( !structIsEmpty(structIP) ){
				// заполняе объект instance.UserIp из structIP
				instance.UserIp.setIpFrom('#structIP.ipFrom#');
				instance.UserIp.setIpTo('#structIP.ipTo#');
				instance.UserIp.setIsRange('#structIP.isRange#');
				instance.UserIp.setDateTimeCreate(#structIP.dateTimeCreate#);
				instance.UserIp.setDateTimeEdite(#structIP.dateTimeEdite#);
				instance.UserIp.setRole('#structIP.role#');
				instance.UserIp.setDescription('#structIP.description#');
				instance.UserIp.setIpCfid('#structIP.ipCfid#');
				instance.UserIp.setIpCftoken('#structIP.ipCftoken#');
			}
		}

		// для проверки
		instance.UserIp.setRole('user');
		instance.UserIp.setWarnings(0);
		//instance.UserIp.setDateTimeCreate('');
		//instance.UserIp.setDateTimeEdite("{ts '2012-03-06 15:30:50'}");
		//instance.UserIp.setIpCfid('1608');
		//instance.UserIp.setIpCftoken('81223722');
		// для проверки

// user		
		if (instance.UserIp.getRole() is 'user') {
			if (instance.UserIp.getWarnings() LT 3){
				// в данном цикле нужно анализировать оведение пользователя.
			}
			else if (instance.UserIp.getWarnings() GTE 3){ // Больше или равно 3. такого ip нет в базе и набралось предупреждений
				setUserIpParam( role='podoz', description='Накопилось 3 предупреждения.', doLog=true );

				instance.fireWallDAO.createIP(ipFrom='#instance.UserIp.getCurrentIp()#', ipTo='#instance.UserIp.getCurrentIp()#', isRange='No',dateTimeCreate='#now()#', 
								dateTimeEdite='#now()#',role='podoz', description = 'Накопилось 3 предупреждения.', ipCfid='#client.CFID#',
								ipCftoken='#client.CFToken#');
			}
		}
//podoz		
		if (instance.UserIp.getRole() is 'podoz') {
			if (instance.UserIp.getWarnings() is 0 ){
				if (DateDiff("n",instance.UserIp.getDateTimeEdite(),now()) LT 30 ){ // меньше 30 минут
						// выводим капчу
						// этот цикл получился лишним
				}
				else if (DateDiff("n",instance.UserIp.getDateTimeEdite(),now()) GTE 30 ){ //Больше или равно 30 минут>
					// client.CFID и client.CFToken пока оставить в таком виде
					if (client.CFID IS instance.UserIp.getIpCfid() AND client.CFToken IS instance.UserIp.getIpCftoken() ){
						setUserIpParam( role='podoz', description='Подозрительный IP адрес!', doLog=true );
					}
					else {
						setUserIpParam( role='user', description='Пропускаем данный IP, данные в базе не актуальны.', doLog=true, opsDB='deleteIP');
						instance.fireWallDAO.deleteIP(UserIP=#instance.UserIp.getCurrentIp()#);

					}
				}
			}
			else if (instance.UserIp.getWarnings() IS NOT 0 AND instance.UserIp.getWarnings() LT 3) {
				setUserIpParam( role='podoz', description='Оставляем данный IP под подозрением.', doLog=false );
			}
			else if (instance.UserIp.getWarnings() GTE 3){
				setUserIpParam( role='ban', description='Накопилось 3 предупреждения. Выставляем бан.', doLog=true );
				instance.fireWallDAO.updateIP(UserIP='#instance.UserIp.getCurrentIp()#', dateTimeEdite='#now()#', role='ban', description='Накопилось 3 предупреждения. Выставляем бан.',
								ipCfid='#client.CFID#', ipCftoken='#client.CFToken#');

			}
		}
//ban
		if (instance.UserIp.getRole() is 'ban'){
			if (DateDiff("n",instance.UserIp.getDateTimeEdite(),now()) LT 5 AND instance.UserIp.getWarnings() LT 3 ){
				setUserIpParam( role='ban', description='Время бана не истекло.', doLog=false );
			}
			else if (DateDiff("n",instance.UserIp.getDateTimeEdite(),now()) LT 5 AND instance.UserIp.getWarnings() GTE 3){
				setUserIpParam( role='ban', description='Продляем бан за нарушения.', doLog=true );
				instance.fireWallDAO.updateIP(UserIP='#instance.UserIp.getCurrentIp()#', dateTimeEdite='#now()#', role='ban', description='Продляем бан за нарушения.',
								ipCfid='#client.CFID#', ipCftoken='#client.CFToken#');

			}
			else if ( DateDiff("n",instance.UserIp.getDateTimeEdite(),now()) GTE 5 AND DateDiff("n",instance.UserIp.getDateTimeEdite(),now()) LT 30 AND instance.UserIp.getWarnings() LT 3 ){
				setUserIpParam( role='podoz', description='Снимаем бан с IP но оставляем под подозрением.', doLog=true );
				instance.fireWallDAO.updateIP(UserIP='#instance.UserIp.getCurrentIp()#', dateTimeEdite='#now()#', role='ban', description='Снимаем бан с IP но оставляем под подозрением.',
								ipCfid='#client.CFID#', ipCftoken='#client.CFToken#');

			}
			// нужно проработать более детально это условие.
			else if (DateDiff("n",instance.UserIp.getDateTimeEdite(),now()) GTE 30 AND instance.UserIp.getWarnings() IS 0 ){
				// клиентсские переменные пока оставить
				if (client.CFID IS instance.UserIp.getIpCfid() AND client.CFToken IS instance.UserIp.getIpCftoken() ){
					setUserIpParam( role='podoz', description='Снимаем бан с IP, но оставляем под подозрением.', doLog=true );
					instance.fireWallDAO.updateIP(UserIP='#instance.UserIp.getCurrentIp()#', dateTimeEdite='#now()#', role='ban', description='Снимаем бан с IP, но оставляем под подозрением.',
									ipCfid='#client.CFID#', ipCftoken='#client.CFToken#');

				}
				else {
					//обновляем обект User
					setUserIpParam( role='user', description='Снимаем бан и подозрение с данного IP, скорей всего это уже другой пользователь.', doLog=true);
					instance.fireWallDAO.deleteIP(UserIP=#instance.UserIp.getCurrentIp()#);
				}
			}
		}
//deny
		if (instance.UserIp.getRole() is 'deny' ){ // тип deny и robot выставляется только администратором.
			setUserIpParam( role='deny', description='Обращение с запрещенного IP.', doLog=true );
		}
	}

	function addWarnings(required numeric warning){
	
		instance.UserIP.setWarnings(instance.UserIP.getWarnings() + warning);
		// если предупреждений больше 3 вызываем runFireWall();
		if (instance.UserIP.getWarnings() GTE 3){
				runFireWall();
		}
		
	}

	function setUserIpParam( required role, required description, required doLog ){
		
		//обновляем обект User
		instance.UserIp.setRole('#arguments.role#');
		instance.UserIp.setWarnings(0);
		instance.UserIp.setDateTimeEdite(now());
		instance.UserIp.setDescription('#arguments.description#');

		// логирование
		if (arguments.doLog is true){
			request.factoryService.getService('Clog').AddLogging(ssection='CFireWall', type='#arguments.role#', description='#arguments.description#');
		}
	
		// работа с базой
		
	}

	function getRole(){
		return instance.UserIP.getRole();
	}

	// Для отладки
	function getMemento(){
		return instance.UserIP.getMemento() ;
	}

}
