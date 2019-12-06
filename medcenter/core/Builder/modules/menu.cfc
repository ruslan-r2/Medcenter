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

		// ������ ��������������
		menu &= #renderMenu('RBAC','access','RBAC','/?page=rbac')#;
		menu &= #renderMenu('typeEmployees','access','���� ��������','/?page=typeEmployees')#;
		menu &= #renderMenu('users','access','������������','/?page=users')#;
		menu &= #renderMenu('companysDms','access','�������� ���','/?page=companysDms')#;

		// �����������
		menu &= #renderMenu('services','access','������','/?page=services')#;
		menu &= #renderMenu('servicesType','access','���� �����','/?page=servicesType')#;
		menu &= #renderMenu('usersInterest','access','% �� �����','/?page=usersInterest')#;

		// ����������� ��������
		menu &= #renderMenu('usersGraphics','access','������ ������','/?page=usersGraphics')#;

		// ������������
		menu &= #renderMenu('reception','access','������������','/?page=reception')#;
		menu &= #renderMenu('patients','access','���������','/?page=patients')#;

		// ����
		menu &= #renderMenu('cabinet','access','�������','/?page=cabinet')#;
		menu &= #renderMenu('sickLists','access','����������','/?page=sickLists')#;

		//��������� ������������
		menu &= #renderMenu('settings','access','���������','/?page=settings')#;

		// �������� ��������
		menu &= #renderMenu('temp','access','����','/?page=temp')#;

		menu &= '
				</div>
			</div> ';

		return menu;
	}
}