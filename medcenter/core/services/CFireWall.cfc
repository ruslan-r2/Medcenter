/*
  —ервис FireWall - Service CFireWall
*/

component displayname="CFireWall" output="false" {

	// ѕсевдо конструктор
	instance = {UserIp = '', fireWallDAO = '' };
	instance.result = structNew(); // дл€ управлени€ выводом страници warnings
	//instance.result.state = true;
	//instance.result.reason = '';

	instance.fireWallDAO = createObject('component', 'core.db.fireWallDAO' ).init();
	lock scope="session" type="exclusive" timeout="5" {
		instance.UserIp = session.sessionStorage.getObject('userIP'); // сесионный ќбъект
	}
	
	function init(){
		return this;
	}
	
	function runFireWall(){

		var REMOTE_ADDR = request.CCGI.getCGI('REMOTE_ADDR');
		//var REMOTE_ADDR = '66.249.65.184';

		if ( instance.UserIp.getCurrentIp() NEQ REMOTE_ADDR ){ // если ip помен€лс€ в одной сессии то нужно удалить предидущий из базы
			instance.UserIp.setCurrentIp('#REMOTE_ADDR#');
			structIP = instance.fireWallDAO.readIP('#REMOTE_ADDR#');
			if ( !structIsEmpty(structIP) ){
				// заполн€е объект instance.UserIp из structIP
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

		// дл€ проверки
		instance.UserIp.setRole('user');
		instance.UserIp.setWarnings(0);
		//instance.UserIp.setDateTimeCreate('');
		//instance.UserIp.setDateTimeEdite("{ts '2012-03-06 15:30:50'}");
		//instance.UserIp.setIpCfid('1608');
		//instance.UserIp.setIpCftoken('81223722');
		// дл€ проверки

// user		
		if (instance.UserIp.getRole() is 'user') {
			if (instance.UserIp.getWarnings() LT 3){
				// в данном цикле нужно анализировать оведение пользовател€.
			}
			else if (instance.UserIp.getWarnings() GTE 3){ // Ѕольше или равно 3. такого ip нет в базе и набралось предупреждений
				setUserIpParam( role='podoz', description='Ќакопилось 3 предупреждени€.', doLog=true );

				instance.fireWallDAO.createIP(ipFrom='#instance.UserIp.getCurrentIp()#', ipTo='#instance.UserIp.getCurrentIp()#', isRange='No',dateTimeCreate='#now()#', 
								dateTimeEdite='#now()#',role='podoz', description = 'Ќакопилось 3 предупреждени€.', ipCfid='#client.CFID#',
								ipCftoken='#client.CFToken#');
			}
		}
//podoz		
		if (instance.UserIp.getRole() is 'podoz') {
			if (instance.UserIp.getWarnings() is 0 ){
				if (DateDiff("n",instance.UserIp.getDateTimeEdite(),now()) LT 30 ){ // меньше 30 минут
						// выводим капчу
						// этот цикл получилс€ лишним
				}
				else if (DateDiff("n",instance.UserIp.getDateTimeEdite(),now()) GTE 30 ){ //Ѕольше или равно 30 минут>
					// client.CFID и client.CFToken пока оставить в таком виде
					if (client.CFID IS instance.UserIp.getIpCfid() AND client.CFToken IS instance.UserIp.getIpCftoken() ){
						setUserIpParam( role='podoz', description='ѕодозрительный IP адрес!', doLog=true );
					}
					else {
						setUserIpParam( role='user', description='ѕропускаем данный IP, данные в базе не актуальны.', doLog=true, opsDB='deleteIP');
						instance.fireWallDAO.deleteIP(UserIP=#instance.UserIp.getCurrentIp()#);

					}
				}
			}
			else if (instance.UserIp.getWarnings() IS NOT 0 AND instance.UserIp.getWarnings() LT 3) {
				setUserIpParam( role='podoz', description='ќставл€ем данный IP под подозрением.', doLog=false );
			}
			else if (instance.UserIp.getWarnings() GTE 3){
				setUserIpParam( role='ban', description='Ќакопилось 3 предупреждени€. ¬ыставл€ем бан.', doLog=true );
				instance.fireWallDAO.updateIP(UserIP='#instance.UserIp.getCurrentIp()#', dateTimeEdite='#now()#', role='ban', description='Ќакопилось 3 предупреждени€. ¬ыставл€ем бан.',
								ipCfid='#client.CFID#', ipCftoken='#client.CFToken#');

			}
		}
//ban
		if (instance.UserIp.getRole() is 'ban'){
			if (DateDiff("n",instance.UserIp.getDateTimeEdite(),now()) LT 5 AND instance.UserIp.getWarnings() LT 3 ){
				setUserIpParam( role='ban', description='¬рем€ бана не истекло.', doLog=false );
			}
			else if (DateDiff("n",instance.UserIp.getDateTimeEdite(),now()) LT 5 AND instance.UserIp.getWarnings() GTE 3){
				setUserIpParam( role='ban', description='ѕродл€ем бан за нарушени€.', doLog=true );
				instance.fireWallDAO.updateIP(UserIP='#instance.UserIp.getCurrentIp()#', dateTimeEdite='#now()#', role='ban', description='ѕродл€ем бан за нарушени€.',
								ipCfid='#client.CFID#', ipCftoken='#client.CFToken#');

			}
			else if ( DateDiff("n",instance.UserIp.getDateTimeEdite(),now()) GTE 5 AND DateDiff("n",instance.UserIp.getDateTimeEdite(),now()) LT 30 AND instance.UserIp.getWarnings() LT 3 ){
				setUserIpParam( role='podoz', description='—нимаем бан с IP но оставл€ем под подозрением.', doLog=true );
				instance.fireWallDAO.updateIP(UserIP='#instance.UserIp.getCurrentIp()#', dateTimeEdite='#now()#', role='ban', description='—нимаем бан с IP но оставл€ем под подозрением.',
								ipCfid='#client.CFID#', ipCftoken='#client.CFToken#');

			}
			// нужно проработать более детально это условие.
			else if (DateDiff("n",instance.UserIp.getDateTimeEdite(),now()) GTE 30 AND instance.UserIp.getWarnings() IS 0 ){
				// клиентсские переменные пока оставить
				if (client.CFID IS instance.UserIp.getIpCfid() AND client.CFToken IS instance.UserIp.getIpCftoken() ){
					setUserIpParam( role='podoz', description='—нимаем бан с IP, но оставл€ем под подозрением.', doLog=true );
					instance.fireWallDAO.updateIP(UserIP='#instance.UserIp.getCurrentIp()#', dateTimeEdite='#now()#', role='ban', description='—нимаем бан с IP, но оставл€ем под подозрением.',
									ipCfid='#client.CFID#', ipCftoken='#client.CFToken#');

				}
				else {
					//обновл€ем обект User
					setUserIpParam( role='user', description='—нимаем бан и подозрение с данного IP, скорей всего это уже другой пользователь.', doLog=true);
					instance.fireWallDAO.deleteIP(UserIP=#instance.UserIp.getCurrentIp()#);
				}
			}
		}
//deny
		if (instance.UserIp.getRole() is 'deny' ){ // тип deny и robot выставл€етс€ только администратором.
			setUserIpParam( role='deny', description='ќбращение с запрещенного IP.', doLog=true );
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
		
		//обновл€ем обект User
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

	// ƒл€ отладки
	function getMemento(){
		return instance.UserIP.getMemento() ;
	}

}
