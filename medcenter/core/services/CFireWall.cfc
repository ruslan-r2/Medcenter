/*
  ������ FireWall - Service CFireWall
*/

component displayname="CFireWall" output="false" {

	// ������ �����������
	instance = {UserIp = '', fireWallDAO = '' };
	instance.result = structNew(); // ��� ���������� ������� �������� warnings
	//instance.result.state = true;
	//instance.result.reason = '';

	instance.fireWallDAO = createObject('component', 'core.db.fireWallDAO' ).init();
	lock scope="session" type="exclusive" timeout="5" {
		instance.UserIp = session.sessionStorage.getObject('userIP'); // ��������� ������
	}
	
	function init(){
		return this;
	}
	
	function runFireWall(){

		var REMOTE_ADDR = request.CCGI.getCGI('REMOTE_ADDR');
		//var REMOTE_ADDR = '66.249.65.184';

		if ( instance.UserIp.getCurrentIp() NEQ REMOTE_ADDR ){ // ���� ip ��������� � ����� ������ �� ����� ������� ���������� �� ����
			instance.UserIp.setCurrentIp('#REMOTE_ADDR#');
			structIP = instance.fireWallDAO.readIP('#REMOTE_ADDR#');
			if ( !structIsEmpty(structIP) ){
				// �������� ������ instance.UserIp �� structIP
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

		// ��� ��������
		instance.UserIp.setRole('user');
		instance.UserIp.setWarnings(0);
		//instance.UserIp.setDateTimeCreate('');
		//instance.UserIp.setDateTimeEdite("{ts '2012-03-06 15:30:50'}");
		//instance.UserIp.setIpCfid('1608');
		//instance.UserIp.setIpCftoken('81223722');
		// ��� ��������

// user		
		if (instance.UserIp.getRole() is 'user') {
			if (instance.UserIp.getWarnings() LT 3){
				// � ������ ����� ����� ������������� �������� ������������.
			}
			else if (instance.UserIp.getWarnings() GTE 3){ // ������ ��� ����� 3. ������ ip ��� � ���� � ��������� ��������������
				setUserIpParam( role='podoz', description='���������� 3 ��������������.', doLog=true );

				instance.fireWallDAO.createIP(ipFrom='#instance.UserIp.getCurrentIp()#', ipTo='#instance.UserIp.getCurrentIp()#', isRange='No',dateTimeCreate='#now()#', 
								dateTimeEdite='#now()#',role='podoz', description = '���������� 3 ��������������.', ipCfid='#client.CFID#',
								ipCftoken='#client.CFToken#');
			}
		}
//podoz		
		if (instance.UserIp.getRole() is 'podoz') {
			if (instance.UserIp.getWarnings() is 0 ){
				if (DateDiff("n",instance.UserIp.getDateTimeEdite(),now()) LT 30 ){ // ������ 30 �����
						// ������� �����
						// ���� ���� ��������� ������
				}
				else if (DateDiff("n",instance.UserIp.getDateTimeEdite(),now()) GTE 30 ){ //������ ��� ����� 30 �����>
					// client.CFID � client.CFToken ���� �������� � ����� ����
					if (client.CFID IS instance.UserIp.getIpCfid() AND client.CFToken IS instance.UserIp.getIpCftoken() ){
						setUserIpParam( role='podoz', description='�������������� IP �����!', doLog=true );
					}
					else {
						setUserIpParam( role='user', description='���������� ������ IP, ������ � ���� �� ���������.', doLog=true, opsDB='deleteIP');
						instance.fireWallDAO.deleteIP(UserIP=#instance.UserIp.getCurrentIp()#);

					}
				}
			}
			else if (instance.UserIp.getWarnings() IS NOT 0 AND instance.UserIp.getWarnings() LT 3) {
				setUserIpParam( role='podoz', description='��������� ������ IP ��� �����������.', doLog=false );
			}
			else if (instance.UserIp.getWarnings() GTE 3){
				setUserIpParam( role='ban', description='���������� 3 ��������������. ���������� ���.', doLog=true );
				instance.fireWallDAO.updateIP(UserIP='#instance.UserIp.getCurrentIp()#', dateTimeEdite='#now()#', role='ban', description='���������� 3 ��������������. ���������� ���.',
								ipCfid='#client.CFID#', ipCftoken='#client.CFToken#');

			}
		}
//ban
		if (instance.UserIp.getRole() is 'ban'){
			if (DateDiff("n",instance.UserIp.getDateTimeEdite(),now()) LT 5 AND instance.UserIp.getWarnings() LT 3 ){
				setUserIpParam( role='ban', description='����� ���� �� �������.', doLog=false );
			}
			else if (DateDiff("n",instance.UserIp.getDateTimeEdite(),now()) LT 5 AND instance.UserIp.getWarnings() GTE 3){
				setUserIpParam( role='ban', description='�������� ��� �� ���������.', doLog=true );
				instance.fireWallDAO.updateIP(UserIP='#instance.UserIp.getCurrentIp()#', dateTimeEdite='#now()#', role='ban', description='�������� ��� �� ���������.',
								ipCfid='#client.CFID#', ipCftoken='#client.CFToken#');

			}
			else if ( DateDiff("n",instance.UserIp.getDateTimeEdite(),now()) GTE 5 AND DateDiff("n",instance.UserIp.getDateTimeEdite(),now()) LT 30 AND instance.UserIp.getWarnings() LT 3 ){
				setUserIpParam( role='podoz', description='������� ��� � IP �� ��������� ��� �����������.', doLog=true );
				instance.fireWallDAO.updateIP(UserIP='#instance.UserIp.getCurrentIp()#', dateTimeEdite='#now()#', role='ban', description='������� ��� � IP �� ��������� ��� �����������.',
								ipCfid='#client.CFID#', ipCftoken='#client.CFToken#');

			}
			// ����� ����������� ����� �������� ��� �������.
			else if (DateDiff("n",instance.UserIp.getDateTimeEdite(),now()) GTE 30 AND instance.UserIp.getWarnings() IS 0 ){
				// ����������� ���������� ���� ��������
				if (client.CFID IS instance.UserIp.getIpCfid() AND client.CFToken IS instance.UserIp.getIpCftoken() ){
					setUserIpParam( role='podoz', description='������� ��� � IP, �� ��������� ��� �����������.', doLog=true );
					instance.fireWallDAO.updateIP(UserIP='#instance.UserIp.getCurrentIp()#', dateTimeEdite='#now()#', role='ban', description='������� ��� � IP, �� ��������� ��� �����������.',
									ipCfid='#client.CFID#', ipCftoken='#client.CFToken#');

				}
				else {
					//��������� ����� User
					setUserIpParam( role='user', description='������� ��� � ���������� � ������� IP, ������ ����� ��� ��� ������ ������������.', doLog=true);
					instance.fireWallDAO.deleteIP(UserIP=#instance.UserIp.getCurrentIp()#);
				}
			}
		}
//deny
		if (instance.UserIp.getRole() is 'deny' ){ // ��� deny � robot ������������ ������ ���������������.
			setUserIpParam( role='deny', description='��������� � ������������ IP.', doLog=true );
		}
	}

	function addWarnings(required numeric warning){
	
		instance.UserIP.setWarnings(instance.UserIP.getWarnings() + warning);
		// ���� �������������� ������ 3 �������� runFireWall();
		if (instance.UserIP.getWarnings() GTE 3){
				runFireWall();
		}
		
	}

	function setUserIpParam( required role, required description, required doLog ){
		
		//��������� ����� User
		instance.UserIp.setRole('#arguments.role#');
		instance.UserIp.setWarnings(0);
		instance.UserIp.setDateTimeEdite(now());
		instance.UserIp.setDescription('#arguments.description#');

		// �����������
		if (arguments.doLog is true){
			request.factoryService.getService('Clog').AddLogging(ssection='CFireWall', type='#arguments.role#', description='#arguments.description#');
		}
	
		// ������ � �����
		
	}

	function getRole(){
		return instance.UserIP.getRole();
	}

	// ��� �������
	function getMemento(){
		return instance.UserIP.getMemento() ;
	}

}
