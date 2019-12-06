/* 
	������ ������ �������� ��� --
*/

component attributeName='sickLists' output='false'{
	// ������ �����������
	factoryService = request.factoryService;

	instance.view = '';
	instance.message = '';
	instance.RBAC = '';

	//instance.cdmsName = '';

	function Init(string section, string action) {
		section = arguments.section;
		action = arguments.action;

		if (section == 'false'){
			//companysDmsListFormHandler();
			instance.view = sickListsForm();

		}else if( section == 'sickList' ){
			if( action == 'add' ){
				//addCompanyDMSFormHandler();
				instance.view = 'addSickListForm()';

			}else if( action == 'edite' ){
				//cdmsid = request.CRequest.getUrl('cdmsid');
				//updateCompanyDMSFormHandler(); 
				instance.view = 'updateSickListForm(cdmsid)';

			}else if( action == 'delete'){
				//instance.view = 'delete group';

			}
		}
		return this;

	}

	function checkedRadio( value, status ){
		if (arguments.value == arguments.status){
			return 'checked';
		}else{
			return '';
		}
	}

	function checkedSelect( value, status ){
		if (arguments.value == arguments.status){
			return 'selected';
		}else{
			return '';
		}
	}


	///////////////////////////////////////////////////////////////////////////

	function sickListsForm(){

		// ���������� � RBAC � ������� ��� ���� ���. ���� ������� ����, �� ���������� ��� �����, ����
		// ���� �� ������ �������� �� �����.
		sickLists = factoryService.getService('sickListsAPI').getAllSickLists();
		var view = '';
		view &= '<div class="grid_16"><div class="signin-box"><h2>������ ���������� ������: ##����##</h2>';
			view &= '<table class="td_head" width="100%">
						<tr><td style="text-align:right;" colspan="12"><a class="g-button g-button-submit" href="/?page=sickLists&section=sickList&action=add">+�������� ���������� ����</a></td></tr>
						<tr style="color:grey;">
						<th>id</th> 
						<th>� ��</th> 
						<th>� �� ������</th> 
						<th>�������</th>
						<th>� ������ �����</th> 
						<th>�� ����� �����</th> 
						<th>����</th>
						<th>����</th>
						<th>���������� � ������</th>
						<th>����������</th>
						<th>������</th>
						<th> --- </th>
						</tr>';
			//writeDump(sickLists);
			if (sickLists.recordcount){
			for (var x=1; x<=sickLists.recordcount; x++){
				var class = IIF(x MOD 2, DE('tr_hover'), DE('tr_hover1'));
				view &= '<tr class="block #class#">
					<td>#sickLists.sl_id[x]#</td> 
					<td>#sickLists.sl_number[x]#</td> 
					<td>#sickLists.sl_number_parent[x]#</td> 
					<td>#sickLists.pt_id[x]#</td> 
					<td>#sickLists.sl_date_start[x]# - #sickLists.sl_date_start1[x]# - #sickLists.sl_date_start2[x]#</td>
					<td>#sickLists.sl_date_end[x]# - #sickLists.sl_date_end1[x]# - #sickLists.sl_date_end2[x]#</td>
					<td>#sickLists.user_id[x]# - #sickLists.user_id1[x]# - #sickLists.user_id2[x]#</td> 
					<td>#sickLists.rp_id[x]# - #sickLists.rp_id1[x]# - #sickLists.rp_id2[x]#</td>
					<td>#sickLists.sl_date_closing[x]#</td>
					<td>#sickLists.sl_description[x]#</td>
					<td>#sickLists.sl_status[x]#</td>
					<td> <a href="/?page=users&section=user&action=edite&userid=userList.user_id[x]">�������������</a> | <a href="/?page=users&section=user&action=delete&userid=userList.user_id[x]">�������</a> </td>
					</tr>';
			}
			}else{
			view &= '<tr><td colspan="12"><font color="red">� ���� ������ ��� ���������� ������!</font></td></tr>';
			}
			view &= '<tr><td style="text-align:right;" colspan="12"><a class="g-button g-button-submit" href="/?page=sickLists&section=sickList&action=add">+�������� ���������� ����</a></td></tr>';

			view &= '</table>';
		view &= '</div></div>';

		return view;
	}


	///////////////////////////////////////////////////////////////////////////

	function View() {
		return instance.view;
  	}

}