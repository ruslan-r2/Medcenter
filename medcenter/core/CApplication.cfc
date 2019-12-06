component name="CApplication" output="false"{

function init(){

		// � ������� ������������ ���� �������
		request.factoryService = createObject("component","core.factoryService").init();

		// ������� ������������ RBAC
		request.RBAC = request.factoryService.getService('rbac');
		//writeDUmp(request.RBAC.getMemento());

// ----------------------------------CCoreStart--------------------------------------------------------------------
		// ���������� CCGI �������� � ���� ��� cgi ����������
		// ����������� cgi ���������� �� ����
		request.CCGI = createObject("component","CCoreStart.CCGI").init();

		// ���������� ���������� client.* ����������� � ����, ��������� � cookie (cfid � cftoken)
		// ����������� client ���������� �� ����
		request.CClient = createObject("component","CCoreStart.CClient").init();

		// ������������ ���������� cookie.*, ��� ����� cfid � cftoken ���������.
		// ����������� cookie ���������� �� ����
		request.CCookie = createObject("component","CCoreStart.CCookie").init();

		// ��� ��� ������ � ���� �������������� ����� POST\GET form url � �.�
		request.CRequest = createObject("component","CCoreStart.CRequest").init();
	
		// ������ fireWall ��������� ip �� ���� � ������ �� ������� �������������� � ������������.
		// ������ ����� ������� �� ����� �������� � application � ����� ����������� ��� ������� ������������.
		// fierWall ������ ���� ���������� ������ ��� �� ���������, ��� ��������� � ���� ��� ��������� � �������
		request.factoryService.getService('CFireWall').runFireWall();

// ----------------------------------CRouter--------------------------------------------------------------------
		// ��� ������ ����� ��������� � ����� ������ � ��� ������ ����� ��� ��� �����������
		// � ����� ���� �������� ��������� html ��� json

		//if (cgi.script_name is not '/ajax.cfc'){ // ��� ������� ��� ajax �������
		if ( request.CRequest.isAjax() is 'html'){ // ��� ������� ��� ajax �������
			// �����
			CRouter = CreateObject("component","core.CRouter").Init();
			CRouter.run();
		} // ��� ������� ��� ajax �������
		//writeDump( request.CRequest.isAjax() );


// ----------------------------------CCoreStop--------------------------------------------------------------------
		// �������� ��� ���������� � ���� � ����������.
		// ��������� ���� �������� �� ������ �� ����������.
		//writeDump(request.factoryService.getService('CLog').ReadLogging());

		// ���������� ��� ��� ���� � ����
		//request.factoryService.getService('CLog').SaveLogging();

		// ������ �� ��������
		//objRedirect = request.factoryService.getService('redirector');
		//if (!objRedirect.getState()){
		//	objRedirect.redirect();
		//}
		//writeoutput('<hr>STOP!!!<hr>');
	}
}