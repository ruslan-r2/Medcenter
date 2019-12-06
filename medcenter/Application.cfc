component displayname="Application" output="false" {

    request.start_t = getTickCount();

    this.name="MEDCENTER.RU";
    this.sessionmanagement="true";
    this.clientmanagement="true";
    this.setclientcookies="true";
    this.sessiontimeout=CreateTimeSpan(0,8,0,0);
    this.clientstorage="bbs_test";
    this.applicationtimeout=CreateTimeSpan(1,0,0,0);

	function OnApplicationStart(){

		// ������������� ��������� ����������
		application.applicationStorage = createObject("component","core.applicationStorage").init();
		// ������ ������ ������� ��������
		factoryService = createObject("component","core.factoryService").init();
		// ����� ��������� csettings
		factoryService.getService('CSettings').setSettings();
	}

	function onSessionStart(){
		// ������������� ��������� ������
		session.sessionStorage = createObject("component","core.sessionStorage").init();
		// � ���� ����� ����� ����� ������������ ������������
	}
	
	function onRequestStart(){ // onRequestStart(required string targetPage)
		CreateObject('component','core.CApplication').init();
	}

	function onRequestEnd(){
		request.end_t = getTickCount();
		if ( request.CRequest.isAjax() is 'html'){ // ��� ������� ��� ajax �������
			writeOutPut('<div id="block" style="text-align:center">����� ��������� �������: #numberFormat(request.end_t-request.start_t)# ms.</div>');
		}
	}


	function OnError(exception,eventName) {
	    try { 
	      errorHandler=createObject('component','core.errorHandler').Init();
	      errorHandler.Handler(arguments.exception);
	    } catch(any e) {
	      WriteOutput('����������� ������');
	    } 
	}

}