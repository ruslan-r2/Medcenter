/*	��������:
	��� ���������� ������� ���� � ���� ������ ��������� �� ���� ��������, ����� ������ ���� ������� ��
	���� ���������� region �� ���������� ����������� ������. ��� �������� �������� ������ ��� ����������
	����� ��������� �� �������������.

	dataType: 2-boolian; 1-numeric; 0-string;	// �� ������ ������� ������ ������
							// ��� ��������� ������ ��������� � ������ ��� ������������
*/
component displayname='userSettings' output='false' {

	instance.user = request.factoryService.getService('CSettings').getSettings('user','query'); //query
	instance.userMessage = '';
	instance.menu = request.factoryService.getService('CSettings').getSettings('menu','query'); //query
	instance.menuMessage = '';
	//writedump(instance.user);

	function Init() {
		handler();
		return this;
	}

	function handler(){
		// ���������� �����
		if ( isdefined('form.varUserSave') ){
			for (var x=1; x<=instance.user.recordcount; x++){
				if ( listFind( instance.user.listVarValue[x] , form[instance.user.cfvar[x]] ) ){
					client[instance.user.cfvar[x]] = form[instance.user.cfvar[x]]; // ��� ������
					instance.userMessage = '��������� ���������!';
				}else{
					// �����������
					instance.userMessage = '������������ ������ ������!';
				}
			}
		}

		if ( isdefined('form.varMenuSave') ){
			for (var x=1; x<=instance.menu.recordcount; x++){
				if ( listFind( instance.menu.listVarValue[x] , form[instance.menu.cfvar[x]] ) ){
					client[instance.menu.cfvar[x]] = form[instance.menu.cfvar[x]]; // ��� ������
					instance.menuMessage = '��������� ���������!';
				}else{
					// �����������
					instance.menuMessage = '������������ ������ ������!';
				}
			}

		}

	}

	function View() {
	var menu = '<div class="grid_8"><div class="signin-box">';
	menu &= '<h2>���������������� ���������.</h2>';
	menu &= '<strong>��������� ������������.</strong>';
		// loop
		//writeDump(instance.user);
		menu &= '<form id="" name="formUser" action="#request.CRequest.updateURL(false,"/?page=settings")#" method="post">';
		for (var x=1; x<=instance.user.recordcount; x++){
			menu &= '<p>#instance.user.name[x]# - ';
				menu &= '#selectMenu("dropdown", instance.user.cfvar[x], instance.user.listVarName[x], instance.user.listVarValue[x], client[instance.user.cfvar[x]])#';
			menu &= '</p>';
		}
		menu &= '<input type="submit" name="varUserSave" value="���������">';
		menu &= '</form>';
		if( instance.userMessage != '' ){
			menu &= '<label class="error">#instance.userMessage#</label>';
		}


	menu &= '<strong>��������� ����.</strong>';
		// loop
		//writeDump(instance.menu);
		menu &= '<form id="" name="formMenu" action="#request.CRequest.updateURL(false,"/?page=settings")#" method="post">';
		for (var x=1; x<=instance.menu.recordcount; x++){
			menu &= '<p>#instance.menu.name[x]# - ';
				menu &= '#selectMenu("dropdown", instance.menu.cfvar[x], instance.menu.listVarName[x], instance.menu.listVarValue[x], client[instance.menu.cfvar[x]])#';
			menu &= '</p>';
		}
		menu &= '<input type="submit" name="varMenuSave" value="���������">';
		menu &= '</form>';
		if( instance.menuMessage != '' ){
			menu &= '<label class="error">#instance.menuMessage#</label>';
		}


	menu &= '</div></div>';
	//writeDump(client);

	return menu;

	

	}

	function selectMenu(string type='dropdown', string name, string listName, string listValue, string value){
		var menu='';

		menu &= '<select name="#arguments.name#">';
		for (var x=1; x<=#listLen(arguments.listName)#; x++ ){
			menu &= '<option value="#listGetAt(arguments.listValue,x)#"';
			if (listGetAt(arguments.listValue,x) == arguments.value){
				menu &= 'selected';
			}
			menu &= '>#listGetAt(arguments.listName,x)#</option>';
		}
		menu &= '</select>';

		return menu;
	}

	/*
	function YesNo(string type='dropdown', string name, boolian value){ // type: radio, dropdown
		var menu='';
		var tag_last_yes_no_radio = 0;
		if (arguments.type=='dropdown'){
			menu &= '<select name="#arguments.name#">';
			menu &= '<option value="0"';
			if(arguments.value == true){ menu &= 'selected';}
			menu &= '>��</option>';
			menu &= '<option value="1"';
			if(arguments.value == false){ menu &= 'selected';}
			menu &= '>���</option>';
			menu &= '</select>';
		}else if (arguments.type=='radio'){
			menu &= '<input type="Radio" name="#arguments.name#" id="#tag_last_yes_no_radio#" value="1"';
			if (arguments.value == true){ menu&='checked';}
			menu&= '>��';
			menu&= '&nbsp;&nbsp;&nbsp;';
			tag_last_yes_no_radio = tag_last_yes_no_radio + 1;
			menu &= '<input type="Radio" name="#arguments.name#" id="#tag_last_yes_no_radio#" value="0"';
			if (arguments.value == false){ menu&='checked'; }
			menu &= '>���';
			tag_last_yes_no_radio = tag_last_yes_no_radio + 1;
		}
		return menu;
	}
	*/
}