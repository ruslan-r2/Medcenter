/*
	widget captcha - ������ ����� 
*/

component attributeName='captcha' output='false'{

	// ������ �����������
	factoryService = request.factoryService;
	instance.CCaptcha = factoryService.getService('CCaptcha'); // �������� ������ �����
	// �������� ��� ��� ���
	//instance.javaScript = factoryService.getService('CJavaScript').addMeta(fileName=',/js/captcha.js');

	function Init() {
		run();
		return this;
	}

	function run(){

		if ( isDefined('url.redir') ){
			redir = #request.CRequest.updateURL(false,"#url.redir#")#;
		}else{
			redir = 'http://127.0.0.1/';
		}

		formHandler();

	}

	// ���������� ����� ���� ��� ���������
	function formHandler(){
		param name='errmsg' default='';
		param name='captcha' default='';
		//--- ���������� ����� ---
		if ( isdefined('form.ok') ){
			if ( instance.CCaptcha.getCaptcha(form.UUID) == form.captcha ){
				//errmsg = "��� ��������� ����.";

                		// ����� �������� ��������� �������� ����� ������������ ����������.
				factoryService.getService('CFireWall').setUserIpParam( role='user', description='������� ��� � ���������� � ������� IP, ������������ ���� �����.', doLog=true);
				// ����� ������� IP �� ����
				//instance.fireWallDAO.deleteIP(UserIP=#instance.UserIp.getCurrentIp()#);

				factoryService.getService('redirector').redirect('#redir#');
			}else{
				errmsg = "������������ ����� �����.";
				// ���� ������� �� ����������� ������� ��������� ������
			}
			// ���� ������� �� ����������� ������� ��������� ������
			instance.CCaptcha.delCaptcha(form.UUID);
		//--- ���������� ����� ---
		}
	}


	function View() {

		UUID = createUUID(); // ���������� ID ��� �����
 		instance.CCaptcha.generateCaptcha(UUID); // ��������� ����� ��� ID �����

		savecontent variable="cfimage"{ 
			include 'cfimage.cfm';
		}

		view = '';
		view &= '<div id="mes" style="color:red;">#errmsg#</div>
			<div id="block">
			<form id="captcha" name="captcha" action="#request.CRequest.updateURL(false,"/?page=captcha")#" method="post">
				<div>	
					#cfimage#
					<input type="text" name="captcha" value="" maxlength="10" size="10">
					<input type="hidden" name="UUID" value="#UUID#" >
					<input type="hidden" name="redir" value="#redir#">
				</div>
				<input type="submit" name="update" value="<>" >
				<input type="submit" name="ok" value="ok" >
			</form>
			</div>';

		writeOutPut(view);	
	}

}