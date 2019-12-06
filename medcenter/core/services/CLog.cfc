/*
  ������ ������ - Service CLOG
*/

component displayname="CLog" output="false" {

	// ������ �����������
	instance = {objLogDAO = ''};
	instance.objLogDAO = createObject('component', 'core.db.logDAO' ).init();
	
	function init(){
		return this;
	}

	// ��������� ������� �������-Log � LogDAO . ������.
	function AddLogging(required string ssection, required string type, string description){

	        // ������ ��� �����������
		lock scope="session" type="readonly" timeout="5" {
			userIP = session.sessionStorage.getObject('userIP'); // ��������� ������
		}
		// ����� ������� ���������� cgi � client ����� ���������
		// ���������� � ����
		instance.objLogDAO.CreateLogging(
			now(),			//dateTimeCreate, // ����� �������� ������
			userIP.getCurrentIp(),	//userIP,// IP ����� ������������
			arguments.ssection,	// ������ � ������� ��������� �������\������
			arguments.type, 	// ��� �������\������
			cgi.QUERY_STRING,	//surl,	// url � ������ ������
			arguments.description,	// ������ ��������
			client.CFID,		// CFID ������������
			client.CFToken);	// CFToken ������������
	}

}