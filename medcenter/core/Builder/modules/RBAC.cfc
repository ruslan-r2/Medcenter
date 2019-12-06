/* 
	Виджет список пользовательские группы.
*/

component attributeName='grouplist' output='false'{
	// псевдо конструктор
	factoryService = request.factoryService;

	instance.view = '';

	instance.groupName = '';
	instance.groupDescription = '';
	instance.rolesID = '';
	instance.groupStatus = '';
	instance.message = '';

	instance.roleName = '';
	instance.roleDescription = '';
	instance.roleChild = '';
	instance.roleParent = '';
	instance.prmsIDs = '';
	instance.roleStatus = '';

	instance.prmsName = '';
	instance.prmsDescription = '';
	instance.obsID = '';
	instance.opsID = '';
	instance.prmsStatus = '';

	instance.obsName = '';
	instance.obsType = '';
	instance.obsDescription = '';
	instance.obsStatus = '';

	instance.opsName = '';
	instance.opsType = '';
	instance.opsDescription = '';
	instance.opsStatus = '';

	// прийдется переменные для форм добавлять внутоь вьювером или оставлять здесь
	// но здесь их будет очень много


	function Init(string section, string action) {
		section = arguments.section;
		action = arguments.action;

		if (section == 'false'){
			instance.view = groupListForm();
			instance.view &= roleListForm();
			instance.view &= permissionListForm();
			instance.view &= objectListForm();
			instance.view &= operationListForm();
			//writeDump(request.RBAC.getmemento());

		}else if( section == 'group' ){
			if( action == 'add' ){
				addGroupFormHandler();
				instance.view = addGroupForm();
			}else if( action == 'edite' ){
				groupid = request.CRequest.getUrl('groupid');
				updateGroupFormHandler(); 
				instance.view = updateGroupForm(groupid);
			}else if( action == 'delete'){
				instance.view = 'delete group';
			}
		}else if( section == 'role' ){
			if( action == 'add' ){
				addRoleFormHandler();
				instance.view = addRoleForm();
			}else if( action == 'edite' ){
				roleid = request.CRequest.getUrl('roleid');
				updateRoleFormHandler(); 
				instance.view = updateRoleForm(roleid);
			}else if( action == 'delete'){
				instance.view = 'delete role';
			}
		}else if( section == 'permission' ){
			if( action == 'add' ){
				addPermissionFormHandler();
				instance.view = addPermissionForm();
			}else if( action == 'edite' ){
				prmsid = request.CRequest.getUrl('prmsid');
				updatePermissionFormHandler(); 
				instance.view = updatePermissionForm(prmsid);
			}else if( action == 'delete'){
				instance.view = 'delete permission';
			}
		}else if( section == 'object' ){
			if( action == 'add' ){
				addObjectFormHandler();
				instance.view = addObjectForm();
			}else if( action == 'edite' ){
				obsid = request.CRequest.getUrl('obsid');
				updateObjectFormHandler(); 
				instance.view = updateObjectForm(obsid);
			}else if( action == 'delete'){
				instance.view = 'delete object';
			}
		}else if( section == 'operation' ){
			if( action == 'add' ){
				addOperationFormHandler();
				instance.view = addOperationForm();
			}else if( action == 'edite' ){
				obsid = request.CRequest.getUrl('opsid');
				updateOperationFormHandler(); 
				instance.view = updateOperationForm(opsid);
			}else if( action == 'delete'){
				instance.view = 'delete operation';
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

	// обработчик формы если ява выключена
	private function addGroupFormHandler(){
		// --- обработчик формы---
		if ( isdefined('form.addGroup') ){
		  if ( !isDefined('form.roles_id') ){
			form.roles_id = '';
		  }
		  rbacAPI = factoryService.getService('rbacAPI');
		      result = rbacAPI.addGroup( #form.group_name# , #form.group_description#, #form.roles_id#, #form.group_status# );
			//writeDump(form);
			//result.RETVAL = 1;
			if ( result.RETVAL is 1 ){
				factoryService.getService('redirector').redirect('/?page=rbac');
			}else{
				// --- пробная версия
				if (StructKeyExists(result, 'RETDESC')) {
					instance.message = result['RETDESC'];
				} else {
					instance.message = '';
				}

				if (StructKeyExists(result.STRUCT, 'groupName')) {
					instance.groupName = result.STRUCT['groupName'];
				} else {
					instance.groupName = '';
				}
				if (StructKeyExists(result.STRUCT, 'groupDescription')) {
					instance.groupDescription = result.STRUCT['groupDescription'];
				} else {
					instance.groupDescription = '';
				}
				if (StructKeyExists(result.STRUCT, 'rolesID')) {
					instance.rolesID = result.STRUCT['rolesID'];
				} else {
					instance.rolesID = '';
				}
				if (StructKeyExists(result.STRUCT, 'groupStatus')) {
					instance.groupStatus = result.STRUCT['groupStatus'];
				} else {
					instance.groupStatus = '';
				}

			}
		}
		// --- обработчик формы---
	}

	function addGroupForm(){

		param name='form.group_name' default='';
		param name='form.group_description' default='';
		param name='form.roles_id' default='';
		param name='form.group_status' default='1'; // включено

		var view = '';
		view &= '
			<form name="" id="" action="#request.CRequest.updateURL(false,"/?page=rbac&section=group&action=add")#" method="post">
			<div class="grid_8"><div class="signin-box">
				<a class="g-button g-button-submit" href="#request.CRequest.updateURL(false,"/?page=rbac")#">Назад</a><br><br>
				<h2>Добавление пользовательской группы</h2>
				<div>
					<label for="group_name"><b>Имя группы:</b></label> 
					<input type="text" name="group_name" value="#form.group_name#" size = "50" maxlength = "50">';

			if (instance.groupName is not ''){
			view &= '		<label for="group_name" class="error" generated="0">#instance.groupName#</label>';
			}

			view &= '
				</div>
				<div>
					<label for="group_description"><b>Описание:</b></label>
					<textarea name = "group_description" rows="6" cols="47" >#form.group_description#</textarea>';

			if (instance.groupDescription is not ''){
			view &= '		<label for="group_description" class="error" generated="0">#instance.groupDescription#</label>';
			}

			view &= '
				</div>
				<div>
					<label for="roles_id"><b>Пользовательские роли:</b></label> ';

				roleList = factoryService.getService('rbacAPI').getRoleList();
				for (var x=1; x<=roleList.recordcount; x++){
					view &= '
						<input type="checkbox" name="roles_id" value="#roleList.role_id[x]#" ';
						if ( ListFind( form.roles_id , roleList.role_id[x] ) ) {
							view &= 'checked';
						} 
					view &= '/> #roleList.role_name[x]# <br>';
                		}
			if (instance.rolesID is not ''){
			view &= '		<label for="roles_id" class="error" generated="0">#instance.rolesID#</label>';
			}

			view &= '</div>
				<div>
					<label for="group_status"><b>Статус:</b></label> 
					<input type="radio" name="group_status" value="1" #checkedRadio("1", form.group_status)# /> Включена <br>
					<input type="radio" name="group_status" value="0" #checkedRadio("0", form.group_status)#/> Выключена <br>
				</div>';

			if (instance.groupStatus is not ''){
			view &= '		<label for="group_status" class="error" generated="0">#instance.groupStatus#</label>';
			}

			view &= '
				<div>
					<input disabled class="g-button g-button-submit" type="submit" name="escape" value="Отмена">
					<input class="g-button g-button-submit" type="submit" name="addGroup" value="Сохранить">
				</div>';

			if (instance.message is not ''){
				view &= '<div id="mes" style="color:red;">#instance.message#</div>';
			}

			view &= '
			</div></div>';

			//writeDump( request.CRequest.getAllForm() );
			//writeDump( request.CRequest.getForm( 'status' ) );

		return view;
	}

	private function updateGroupFormHandler(){
		// --- обработчик формы---
		if ( isdefined('form.updateGroup') ){
		  if ( !isDefined('form.roles_id') ){
			form.roles_id = '';
		  }
		  rbacAPI = factoryService.getService('rbacAPI');
		      result = rbacAPI.editeGroup( #form.group_id#, #form.group_name# , #form.group_description#, #form.roles_id#, #form.group_status# );
			if ( result.RETVAL is 1 ){
				if (StructKeyExists(result, 'RETDESC')) {
					instance.message = result['RETDESC'];
				} else {
					instance.message = '';
				}
				//factoryService.getService('redirector').redirect('/?page=rbac&section=group&action=edite&groupid=#form.group_id#');

			}else{
				// --- пробная версия
				if (StructKeyExists(result, 'RETDESC')) {
					instance.message = result['RETDESC'];
				} else {
					instance.message = '';
				}

				if (StructKeyExists(result.STRUCT, 'groupName')) {
					instance.groupName = result.STRUCT['groupName'];
				} else {
					instance.groupName = '';
				}
				if (StructKeyExists(result.STRUCT, 'groupDescription')) {
					instance.groupDescription = result.STRUCT['groupDescription'];
				} else {
					instance.groupDescription = '';
				}
				if (StructKeyExists(result.STRUCT, 'rolesID')) {
					instance.rolesID = result.STRUCT['rolesID'];
				} else {
					instance.rolesID = '';
				}
				if (StructKeyExists(result.STRUCT, 'groupStatus')) {
					instance.groupStatus = result.STRUCT['groupStatus'];
				} else {
					instance.groupStatus = '';
				}
			}
		}
		// --- обработчик формы---
	}

	function updateGroupForm( groupid ){

		rbacAPI = factoryService.getService( 'rbacAPI' );
		qGroup = rbacAPI.getGroup( arguments.groupid , 'query' );

		param name='form.group_id' default='#qGroup.group_id#';
		param name='form.group_name' default='#qGroup.group_name#';
		param name='form.group_description' default='#qGroup.group_description#';
		param name='form.roles_id' default='#qGroup.roles_id#';
		param name='form.group_status' default='#qGroup.group_status#';

		var view = '';
		view &= '
			<form name="" id="" action="#request.CRequest.updateURL(false,"/?page=rbac&section=group&action=edite&groupid=#arguments.groupid#")#" method="post">
			<div class="grid_8"><div class="signin-box">
				<a class="g-button g-button-submit" href="#request.CRequest.updateURL(false,"/?page=rbac")#">Назад</a><br><br>
				<h2>Редактирование пользовательской группы</h2>
				<div>
					<label for="group_id"><b>ID группы:</b></label>
					<input disabled type="text" name="_group_id" value="#form.group_id#" size = "2" maxlength = "2">
					<input type="hidden" name="group_id" value="#form.group_id#" size = "2" maxlength = "2">
				</div>
				<div>
					<label for="group_name"><b>Имя группы:</b></label> 
					<input type="text" name="group_name" value="#form.group_name#" size = "50" maxlength = "50">';

			if (instance.groupName is not ''){
			view &= '		<label for="group_name" class="error" generated="0">#instance.groupName#</label>';
			}

			view &= '
				</div>
				<div>
					<label for="group_description"><b>Описание:</b></label>
					<textarea name = "group_description" rows="6" cols="47" >#form.group_description#</textarea>';
			if (instance.groupDescription is not ''){
			view &= '		<label for="group_description" class="error" generated="0">#instance.groupDescription#</label>';
			}

			view &= '
				</div>
				<div>
					<label for="roles_id"><b>Пользовательские роли:</b></label> ';

			roleList = factoryService.getService('rbacAPI').getRoleList();
			for (var x=1; x<=roleList.recordcount; x++){
				view &= '
					<input type="checkbox" name="roles_id" value="#roleList.role_id[x]#" ';
					if ( ListFind( form.roles_id , roleList.role_id[x] ) ) {
						view &= 'checked';
					} 
				view &= '/> #roleList.role_name[x]# <br>';

			}

			view &= '</div>
				<div>
					<label for="group_status"><b>Статус:</b></label> 
					<input type="radio" name="group_status" value="1" #checkedRadio("1", form.group_status)# /> Включена <br>
					<input type="radio" name="group_status" value="0" #checkedRadio("0", form.group_status)# /> Выключена <br>
				</div>
				<div>
					<input disabled class="g-button g-button-submit" type="submit" name="escape" value="Отмена">
					<input class="g-button g-button-submit" type="submit" name="updateGroup" value="Сохранить">
				</div>';

			if (instance.message is not ''){
				view &= '<div id="mes" style="color:red;">#instance.message#</div>';
			}

			view &= '
			</div></div>';
		return view;
	}

	// обработчик формы если ява выключена
	private function addRoleFormHandler(){
		// --- обработчик формы---
		if ( isdefined('form.addRole') ){
		  if ( !isDefined('form.prms_ids') ){
			form.prms_ids = '';
		  }
		  rbacAPI = factoryService.getService('rbacAPI');
		      result = rbacAPI.addRole( #form.role_name# , #form.role_description#, #form.role_child#, #form.role_parent#, #form.prms_ids#, #form.role_status# );
			//writeDump(form);
			//result.RETVAL = 1;
			if ( result.RETVAL is 1 ){
				factoryService.getService('redirector').redirect('/?page=rbac');
			}else{
				// --- пробная версия
				if (StructKeyExists(result, 'RETDESC')) {
					instance.message = result['RETDESC'];
				} else {
					instance.message = '';
				}

				if (StructKeyExists(result.STRUCT, 'roleName')) {
					instance.roleName = result.STRUCT['roleName'];
				} else {
					instance.roleName = '';
				}
				if (StructKeyExists(result.STRUCT, 'roleDescription')) {
					instance.roleDescription = result.STRUCT['roleDescription'];
				} else {
					instance.roleDescription = '';
				}
				if (StructKeyExists(result.STRUCT, 'roleChild')) {
					instance.roleChild = result.STRUCT['roleChild'];
				} else {
					instance.roleChild = '';
				}
				if (StructKeyExists(result.STRUCT, 'roleParent')) {
					instance.roleParent = result.STRUCT['roleParent'];
				} else {
					instance.roleParent = '';
				}
				if (StructKeyExists(result.STRUCT, 'prmsIDs')) {
					instance.prmsIDs = result.STRUCT['prmsIDs'];
				} else {
					instance.rolesID = '';
				}
				if (StructKeyExists(result.STRUCT, 'roleStatus')) {
					instance.roleStatus = result.STRUCT['roleStatus'];
				} else {
					instance.roleStatus = '';
				}

			}
		}
		// --- обработчик формы---
	}

	function addRoleForm(){

		param name='form.role_name' default='';
		param name='form.role_description' default='';
		param name='form.role_child' default='';
		param name='form.role_parent' default='';
		param name='form.prms_ids' default='';
		param name='form.role_status' default='1'; // включено

		var view = '';
		view &= '
			<form name="" id="" action="#request.CRequest.updateURL(false,"/?page=rbac&section=role&action=add")#" method="post">
			<div class="grid_8"><div class="signin-box">
				<a class="g-button g-button-submit" href="#request.CRequest.updateURL(false,"/?page=rbac")#">Назад</a><br><br>
				<h2>Добавление пользовательской роли</h2>
				<div>
					<label for="role_name"><b>Имя роли:</b></label> 
					<input type="text" name="role_name" value="#form.role_name#" size = "50" maxlength = "50">';
			if (instance.roleName is not ''){
			view &= '		<label for="role_name" class="error" generated="0">#instance.roleName#</label>';
			}
			view &= '
				</div>
				<div>
					<label for="role_description"><b>Описание:</b></label>
					<textarea name = "role_description" rows="6" cols="47" >#form.role_description#</textarea>';
			if (instance.roleDescription is not ''){
			view &= '		<label for="role_description" class="error" generated="0">#instance.roleDescription#</label>';
			}

			view &= '
				</div>
				<div>
					<label for="role_child"><b>Роль потомок:</b></label>
					<input type="radio" name="role_child" value="" #checkedRadio("", form.role_child)# /> None <br> ';

				roleList = factoryService.getService('rbacAPI').getRoleList();
				for (var x=1; x<=roleList.recordcount; x++){
					view &= '
						<input type="radio" name="role_child" value="#roleList.role_id[x]#" #checkedRadio("#roleList.role_id[x]#", form.role_child)#/> #roleList.role_name[x]# <br>';
                		}
			if (instance.roleChild is not ''){
			view &= '		<label for="role_child" class="error" generated="0">#instance.roleChild#</label>';

			}

			view &= '
				</div>
				<div>
					<label for="roles_parent"><b>Роль предок:</b></label>
					<input type="radio" name="role_parent" value="" #checkedRadio("", form.role_parent)# /> None <br>';
				//roleList = factoryService.getService('rbacAPI').getRoleList();
				for (var x=1; x<=roleList.recordcount; x++){
					view &= '
						<input type="radio" name="role_parent" value="#roleList.role_id[x]#" #checkedRadio("#roleList.role_id[x]#", form.role_parent)#/> #roleList.role_name[x]# <br>';
                		}
			if (instance.roleParent is not ''){
			view &= '		<label for="role_parent" class="error" generated="0">#instance.roleParent#</label>';

			}

			view &= '
				</div>
				<div>
					<label for="prms_ids"><b>Пользовательские разрешения:</b></label> ';

				permissionList = factoryService.getService('rbacAPI').getPermissionList();
				for (var x=1; x<=permissionList.recordcount; x++){
					view &= '
						<input type="checkbox" name="prms_ids" value="#permissionList.prms_id[x]#" ';
						if ( ListFind( form.prms_ids , permissionList.prms_id[x] ) ) {
							view &= 'checked';
						} 
					view &= '/> #permissionList.prms_name[x]# <br>';
                		}
			if (instance.prmsIDs is not ''){
			view &= '		<label for="prms_ids" class="error" generated="0">#instance.prmsIDs#</label>';
			}

			view &= '</div>
				<div>
					<label for="role_status"><b>Статус:</b></label> 
					<input type="radio" name="role_status" value="1" #checkedRadio("1", form.role_status)# /> Включена <br>
					<input type="radio" name="role_status" value="0" #checkedRadio("0", form.role_status)#/> Выключена <br>
				</div>';

			if (instance.roleStatus is not ''){
			view &= '		<label for="role_status" class="error" generated="0">#instance.roleStatus#</label>';
			}

			view &= '
				<div>
					<input disabled class="g-button g-button-submit" type="submit" name="escape" value="Отмена">
					<input class="g-button g-button-submit" type="submit" name="addRole" value="Сохранить">
				</div>';

			if (instance.message is not ''){
				view &= '<div id="mes" style="color:red;">#instance.message#</div>';
			}

			view &= '
			</div></div>';

			//writeDump( request.CRequest.getAllForm() );
			//writeDump( request.CRequest.getForm( 'status' ) );

		return view;
	}

	// обработчик формы если ява выключена
	private function updateRoleFormHandler(){
		// --- обработчик формы---
		if ( isdefined('form.updateRole') ){
		  if ( !isDefined('form.prms_ids') ){
			form.prms_ids = '';
		  }
		  rbacAPI = factoryService.getService('rbacAPI');
		      result = rbacAPI.editeRole( #form.role_id#, #form.role_name# , #form.role_description#, #form.role_child#, #form.role_parent#, #form.prms_ids#, #form.role_status# );
			//writeDump(form);
			//result.RETVAL = 1;
			if ( result.RETVAL is 1 ){
				//factoryService.getService('redirector').redirect('/?page=rbac');
				if (StructKeyExists(result, 'RETDESC')) {
					instance.message = result['RETDESC'];
				} else {
					instance.message = '';
				}
			}else{
				// --- пробная версия
				if (StructKeyExists(result, 'RETDESC')) {
					instance.message = result['RETDESC'];
				} else {
					instance.message = '';
				}
				if (StructKeyExists(result.STRUCT, 'roleName')) {
					instance.roleName = result.STRUCT['roleName'];
				} else {
					instance.roleName = '';
				}
				if (StructKeyExists(result.STRUCT, 'roleDescription')) {
					instance.roleDescription = result.STRUCT['roleDescription'];
				} else {
					instance.roleDescription = '';
				}
				if (StructKeyExists(result.STRUCT, 'roleChild')) {
					instance.roleChild = result.STRUCT['roleChild'];
				} else {
					instance.roleChild = '';
				}
				if (StructKeyExists(result.STRUCT, 'roleParent')) {
					instance.roleParent = result.STRUCT['roleParent'];
				} else {
					instance.roleParent = '';
				}
				if (StructKeyExists(result.STRUCT, 'prmsIDs')) {
					instance.prmsIDs = result.STRUCT['prmsIDs'];
				} else {
					instance.prmsIDs = '';
				}
				if (StructKeyExists(result.STRUCT, 'roleStatus')) {
					instance.roleStatus = result.STRUCT['roleStatus'];
				} else {
					instance.roleStatus = '';
				}

			}
		}
		// --- обработчик формы---
	}

	function updateRoleForm(roleid){

		rbacAPI = factoryService.getService( 'rbacAPI' );
		qRole = rbacAPI.getRoles( #arguments.roleid# , 'query' );

		param name='form.role_id' default='#qRole.role_id#';
		param name='form.role_name' default='#qRole.role_name#';
		param name='form.role_description' default='#qRole.role_description#';
		param name='form.role_child' default='#qRole.role_child#';
		param name='form.role_parent' default='#qRole.role_parent#';
		param name='form.prms_ids' default='#qRole.prms_ids#';
		param name='form.role_status' default='#qRole.role_status#'; // включено

		var view = '';
		view &= '
			<form name="" id="" action="#request.CRequest.updateURL(false,"/?page=rbac&section=role&action=edite&roleid=#arguments.roleid#")#" method="post">
			<div class="grid_8"><div class="signin-box">
				<a class="g-button g-button-submit" href="#request.CRequest.updateURL(false,"/?page=rbac")#">Назад</a><br><br>
				<h2>Редактирование пользовательской роли</h2>
				<div>
					<label for="role_id"><b>ID роли:</b></label>
					<input disabled type="text" name="_role_id" value="#form.role_id#" size = "2" maxlength = "2">
					<input type="hidden" name="role_id" value="#form.role_id#" size = "2" maxlength = "2">
				</div>
				<div>
					<label for="role_name"><b>Имя роли:</b></label> 
					<input type="text" name="role_name" value="#form.role_name#" size = "50" maxlength = "50">';
			if (instance.roleName is not ''){
			view &= '		<label for="role_name" class="error" generated="0">#instance.roleName#</label>';
			}
			view &= '
				</div>
				<div>
					<label for="role_description"><b>Описание:</b></label>
					<textarea name = "role_description" rows="6" cols="47" >#form.role_description#</textarea>';
			if (instance.roleDescription is not ''){
			view &= '		<label for="role_description" class="error" generated="0">#instance.roleDescription#</label>';
			}

			view &= '
				</div>
				<div>
					<label for="role_child"><b>Роль потомок:</b></label>
					<input type="radio" name="role_child" value="" #checkedRadio("", form.role_child)# /> None <br> ';

				roleList = factoryService.getService('rbacAPI').getRoleList();
				for (var x=1; x<=roleList.recordcount; x++){
					view &= '
						<input type="radio" name="role_child" value="#roleList.role_id[x]#" #checkedRadio("#roleList.role_id[x]#", form.role_child)#/> #roleList.role_name[x]# <br>';
                		}
			if (instance.roleChild is not ''){
			view &= '		<label for="role_child" class="error" generated="0">#instance.roleChild#</label>';

			}

			view &= '
				</div>
				<div>
					<label for="role_parent"><b>Роль предок:</b></label>
					<input type="radio" name="role_parent" value="" #checkedRadio("", form.role_parent)# /> None <br>';
				//roleList = factoryService.getService('rbacAPI').getRoleList();
				for (var x=1; x<=roleList.recordcount; x++){
					view &= '
						<input type="radio" name="role_parent" value="#roleList.role_id[x]#" #checkedRadio("#roleList.role_id[x]#", form.role_parent)#/> #roleList.role_name[x]# <br>';
                		}
			if (instance.roleParent is not ''){
			view &= '		<label for="role_parent" class="error" generated="0">#instance.roleParent#</label>';

			}

			view &= '
				</div>
				<div>
					<label for="prms_ids"><b>Пользовательские разрешения:</b></label> ';

				permissionList = factoryService.getService('rbacAPI').getPermissionList();
				for (var x=1; x<=permissionList.recordcount; x++){
					view &= '
						<input type="checkbox" name="prms_ids" value="#permissionList.prms_id[x]#" ';
						if ( ListFind( form.prms_ids , permissionList.prms_id[x] ) ) {
							view &= 'checked';
						} 
					view &= '/> #permissionList.prms_name[x]# <br>';
                		}
			if (instance.prmsIDs is not ''){
			view &= '		<label for="prms_ids" class="error" generated="0">#instance.prmsIDs#</label>';
			}

			view &= '</div>
				<div>
					<label for="role_status"><b>Статус:</b></label> 
					<input type="radio" name="role_status" value="1" #checkedRadio("1", form.role_status)# /> Включена <br>
					<input type="radio" name="role_status" value="0" #checkedRadio("0", form.role_status)#/> Выключена <br>
				</div>';

			if (instance.roleStatus is not ''){
			view &= '		<label for="role_status" class="error" generated="0">#instance.roleStatus#</label>';
			}

			view &= '
				<div>
					<input disabled class="g-button g-button-submit" type="submit" name="escape" value="Отмена">
					<input class="g-button g-button-submit" type="submit" name="updateRole" value="Сохранить">
				</div>';

			if (instance.message is not ''){
				view &= '<div id="mes" style="color:red;">#instance.message#</div>';
			}

			view &= '
			</div></div>';

		return view;
	}

	// обработчик формы если ява выключена
	private function addPermissionFormHandler(){
		// --- обработчик формы---
		if ( isdefined('form.addPermission') ){
		  if ( !isDefined('form.obs_id') ){
			form.obs_id = '';
		  }
		  if ( !isDefined('form.ops_id') ){
			form.ops_id = '';
		  }
		  rbacAPI = factoryService.getService('rbacAPI');
		      result = rbacAPI.addPermission( #form.prms_name# , #form.prms_description#, #form.obs_id#, #form.ops_id#, #form.prms_status# );
			writeDump(form);
			//result.RETVAL = 1;
			if ( result.RETVAL is 1 ){
				factoryService.getService('redirector').redirect('/?page=rbac');
			}else{
				// --- пробная версия
				if (StructKeyExists(result, 'RETDESC')) {
					instance.message = result['RETDESC'];
				} else {
					instance.message = '';
				}

				if (StructKeyExists(result.STRUCT, 'prmsName')) {
					instance.prmsName = result.STRUCT['prmsName'];
				} else {
					instance.prmsName = '';
				}
				if (StructKeyExists(result.STRUCT, 'prmsDescription')) {
					instance.prmsDescription = result.STRUCT['prmsDescription'];
				} else {
					instance.prmsDescription = '';
				}
				if (StructKeyExists(result.STRUCT, 'obsID')) {
					instance.obsID = result.STRUCT['obsID'];
				} else {
					instance.obsID = '';
				}
				if (StructKeyExists(result.STRUCT, 'opsID')) {
					instance.opsID = result.STRUCT['opsID'];
				} else {
					instance.opsID = '';
				}
				if (StructKeyExists(result.STRUCT, 'prmsStatus')) {
					instance.prmsStatus = result.STRUCT['prmsStatus'];
				} else {
					instance.prmsStatus = '';
				}

			}
		}
		// --- обработчик формы---
	}

	function addPermissionForm(){

		param name='form.prms_name' default='';
		param name='form.prms_description' default='';
		param name='form.obs_id' default='';
		param name='form.ops_id' default='';
		param name='form.prms_status' default='1'; // включено

		var view = '';
		view &= '
			<form name="" id="" action="#request.CRequest.updateURL(false,"/?page=rbac&section=permission&action=add")#" method="post">
			<div class="grid_8"><div class="signin-box">
				<a class="g-button g-button-submit" href="#request.CRequest.updateURL(false,"/?page=rbac")#">Назад</a><br><br>
				<h2>Добавление разрешения</h2>
				<div>
					<label for="prms_name"><b>Имя разрешения:</b></label> 
					<input type="text" name="prms_name" value="#form.prms_name#" size = "50" maxlength = "50">';

			if (instance.prmsName is not ''){
			view &= '		<label for="prms_name" class="error" generated="0">#instance.prmsName#</label>';
			}
			view &= '
				</div>
				<div>
					<label for="prms_description"><b>Описание:</b></label>
					<textarea name = "prms_description" rows="6" cols="47" >#form.prms_description#</textarea>';
			if (instance.prmsDescription is not ''){
			view &= '		<label for="prms_description" class="error" generated="0">#instance.prmsDescription#</label>';
			}

			view &= '
				</div>
				<div>
					<label for="obs_id"><b>Объект:</b></label>';

				objectList = factoryService.getService('rbacAPI').getObjectList();
				for (var x=1; x<=objectList.recordcount; x++){
					view &= '
						<input type="radio" name="obs_id" value="#objectList.obs_id[x]#" #checkedRadio("#objectList.obs_id[x]#", form.obs_id)#/> #objectList.obs_name[x]# <br>';
                		}
			if (instance.obsID is not ''){
			view &= '		<label for="obs_id" class="error" generated="0">#instance.obsID#</label>';

			}

			view &= '
				</div>
				<div>
					<label for="ops_id"><b>Операция:</b></label>';
				operationList = factoryService.getService('rbacAPI').getOperationList();
				for (var x=1; x<=operationList.recordcount; x++){
					view &= '
						<input type="radio" name="ops_id" value="#operationList.ops_id[x]#" #checkedRadio("#operationList.ops_id[x]#", form.ops_id)#/> #operationList.ops_name[x]# <br>';
                		}
			if (instance.opsID is not ''){
			view &= '		<label for="ops_id" class="error" generated="0">#instance.opsID#</label>';

			}

			view &= '</div>
				<div>
					<label for="prms_status"><b>Статус:</b></label> 
					<input type="radio" name="prms_status" value="1" #checkedRadio("1", form.prms_status)# /> Включена <br>
					<input type="radio" name="prms_status" value="0" #checkedRadio("0", form.prms_status)#/> Выключена <br>
				</div>';

			if (instance.prmsStatus is not ''){
			view &= '		<label for="prms_status" class="error" generated="0">#instance.prmsStatus#</label>';
			}

			view &= '
				<div>
					<input disabled class="g-button g-button-submit" type="submit" name="escape" value="Отмена">
					<input class="g-button g-button-submit" type="submit" name="addPermission" value="Сохранить">
				</div>';

			if (instance.message is not ''){
				view &= '<div id="mes" style="color:red;">#instance.message#</div>';
			}

			view &= '
			</div></div>';

			//writeDump( request.CRequest.getAllForm() );
			//writeDump( request.CRequest.getForm( 'status' ) );

		return view;
	}

	// обработчик формы если ява выключена
	private function updatePermissionFormHandler(){
		// --- обработчик формы---
		if ( isdefined('form.updatePermission') ){
		  rbacAPI = factoryService.getService('rbacAPI');
		      result = rbacAPI.editePermission( #form.prms_id#, #form.prms_name# , #form.prms_description#, #form.obs_id#, #form.ops_id#, #form.prms_status# );
			//writeDump(form);
			//result.RETVAL = 1;
			if ( result.RETVAL is 1 ){
				//factoryService.getService('redirector').redirect('/?page=rbac');
				if (StructKeyExists(result, 'RETDESC')) {
					instance.message = result['RETDESC'];
				} else {
					instance.message = '';
				}
			}else{
				// --- пробная версия
				if (StructKeyExists(result, 'RETDESC')) {
					instance.message = result['RETDESC'];
				} else {
					instance.message = '';
				}
				if (StructKeyExists(result.STRUCT, 'prmsName')) {
					instance.prmsName = result.STRUCT['prmsName'];
				} else {
					instance.prmsName = '';
				}
				if (StructKeyExists(result.STRUCT, 'prmsDescription')) {
					instance.prmsDescription = result.STRUCT['prmsDescription'];
				} else {
					instance.prmsDescription = '';
				}
				if (StructKeyExists(result.STRUCT, 'obsID')) {
					instance.obsID = result.STRUCT['obsID'];
				} else {
					instance.obsID = '';
				}
				if (StructKeyExists(result.STRUCT, 'opsID')) {
					instance.opsID = result.STRUCT['opsID'];
				} else {
					instance.opsID = '';
				}
				if (StructKeyExists(result.STRUCT, 'prmsStatus')) {
					instance.prmsStatus = result.STRUCT['prmsStatus'];
				} else {
					instance.prmsStatus = '';
				}

			}
		}
		// --- обработчик формы---
	}

	function updatePermissionForm(prmsid){

		rbacAPI = factoryService.getService( 'rbacAPI' );
		qPermission = rbacAPI.getPermissions( #arguments.prmsid# , 'query' );

		param name='form.prms_id' default='#qPermission.prms_id#';
		param name='form.prms_name' default='#qPermission.prms_name#';
		param name='form.prms_description' default='#qPermission.prms_description#';
		param name='form.obs_id' default='#qPermission.obs_id#';
		param name='form.ops_id' default='#qPermission.ops_id#';
		param name='form.prms_status' default='#qPermission.prms_status#'; // включено

		var view = '';
		view &= '
			<form name="" id="" action="#request.CRequest.updateURL(false,"/?page=rbac&section=permission&action=edite&prmsid=#arguments.prmsid#")#" method="post">
			<div class="grid_8"><div class="signin-box">
				<a class="g-button g-button-submit" href="#request.CRequest.updateURL(false,"/?page=rbac")#">Назад</a><br><br>
				<h2>Редактирование разрешения</h2>
				<div>
					<label for="prms_id"><b>ID разрешения:</b></label>
					<input disabled type="text" name="_prms_id" value="#form.prms_id#" size = "2" maxlength = "2">
					<input type="hidden" name="prms_id" value="#form.prms_id#" size = "2" maxlength = "2">
				</div>
				<div>
					<label for="prms_name"><b>Имя разрешения:</b></label> 
					<input type="text" name="prms_name" value="#form.prms_name#" size = "50" maxlength = "50">';
			if (instance.prmsName is not ''){
			view &= '		<label for="prms_name" class="error" generated="0">#instance.prmsName#</label>';
			}
			view &= '
				</div>
				<div>
					<label for="prms_description"><b>Описание:</b></label>
					<textarea name = "prms_description" rows="6" cols="47" >#form.prms_description#</textarea>';
			if (instance.prmsDescription is not ''){
			view &= '		<label for="prms_description" class="error" generated="0">#instance.prmsDescription#</label>';
			}

			view &= '
				</div>
				<div>
					<label for="obs_id"><b>Объект:</b></label>';
				objectList = factoryService.getService('rbacAPI').getObjectList();
				for (var x=1; x<=objectList.recordcount; x++){
					view &= '
						<input type="radio" name="obs_id" value="#objectList.obs_id[x]#" #checkedRadio("#objectList.obs_id[x]#", form.obs_id)#/> #objectList.obs_name[x]# <br>';
                		}
			if (instance.obsID is not ''){
			view &= '		<label for="obs_id" class="error" generated="0">#instance.obsID#</label>';

			}

			view &= '
				</div>
				<div>
					<label for="ops_id"><b>Операция:</b></label>';
				operationList = factoryService.getService('rbacAPI').getOperationList();
				for (var x=1; x<=operationList.recordcount; x++){
					view &= '
						<input type="radio" name="ops_id" value="#operationList.ops_id[x]#" #checkedRadio("#operationList.ops_id[x]#", form.ops_id)#/> #operationList.ops_name[x]# <br>';
                		}
			if (instance.opsID is not ''){
			view &= '		<label for="ops_id" class="error" generated="0">#instance.opsID#</label>';

			}

			view &= '</div>
				<div>
					<label for="prms_status"><b>Статус:</b></label> 
					<input type="radio" name="prms_status" value="1" #checkedRadio("1", form.prms_status)# /> Включена <br>
					<input type="radio" name="prms_status" value="0" #checkedRadio("0", form.prms_status)#/> Выключена <br>
				</div>';

			if (instance.prmsStatus is not ''){
			view &= '		<label for="prms_status" class="error" generated="0">#instance.prmsStatus#</label>';
			}

			view &= '
				<div>
					<input disabled class="g-button g-button-submit" type="submit" name="escape" value="Отмена">
					<input class="g-button g-button-submit" type="submit" name="updatePermission" value="Сохранить">
				</div>';

			if (instance.message is not ''){
				view &= '<div id="mes" style="color:red;">#instance.message#</div>';
			}

			view &= '
			</div></div>';

		return view;
	}

	// обработчик формы если ява выключена
	private function addObjectFormHandler(){
		// --- обработчик формы---
		if ( isdefined('form.addObject') ){
		  rbacAPI = factoryService.getService('rbacAPI');
		      result = rbacAPI.addObject( #form.obs_name# , #form.obs_type#, #form.obs_description#,  #form.obs_status# );
			//writeDump(form);
			//result.RETVAL = 1;
			if ( result.RETVAL is 1 ){
				factoryService.getService('redirector').redirect('/?page=rbac');
			}else{
				// --- пробная версия
				if (StructKeyExists(result, 'RETDESC')) {
					instance.message = result['RETDESC'];
				} else {
					instance.message = '';
				}

				if (StructKeyExists(result.STRUCT, 'obsName')) {
					instance.obsName = result.STRUCT['obsName'];
				} else {
					instance.obsName = '';
				}
				if (StructKeyExists(result.STRUCT, 'obsType')) {
					instance.obsType = result.STRUCT['obsType'];
				} else {
					instance.obsType = '';
				}
				if (StructKeyExists(result.STRUCT, 'obsDescription')) {
					instance.obsDescription = result.STRUCT['obsDescription'];
				} else {
					instance.obsDescription = '';
				}

				if (StructKeyExists(result.STRUCT, 'obsStatus')) {
					instance.obsStatus = result.STRUCT['obsStatus'];
				} else {
					instance.obsStatus = '';
				}

			}
		}
		// --- обработчик формы---
	}

	function addObjectForm(){

		param name='form.obs_name' default='';
		param name='form.obs_type' default='';
		param name='form.obs_description' default='';
		param name='form.obs_status' default='1'; // включено

		var view = '';
		view &= '
			<form name="" id="" action="#request.CRequest.updateURL(false,"/?page=rbac&section=object&action=add")#" method="post">
			<div class="grid_8"><div class="signin-box">
				<a class="g-button g-button-submit" href="#request.CRequest.updateURL(false,"/?page=rbac")#">Назад</a><br><br>
				<h2>Добавление объекта</h2>
				<div>
					<label for="obs_name"><b>Имя объекта:</b></label> 
					<input type="text" name="obs_name" value="#form.obs_name#" size = "50" maxlength = "50">';

			if (instance.obsName is not ''){
			view &= '		<label for="obs_name" class="error" generated="0">#instance.obsName#</label>';
			}

			view &= '
				</div>
				<div>
					<label for="obs_type"><b>Тип объекта:</b></label>
					<input type="text" name = "obs_type" value="#form.obs_type#" size = "50" maxlength = "50" >';
			if (instance.obsType is not ''){
			view &= '		<label for="obs_type" class="error" generated="0">#instance.obsType#</label>';
			}

			view &= '
				</div>
				<div>
					<label for="obs_description"><b>Описание:</b></label>
					<textarea name = "obs_description" rows="6" cols="47" >#form.obs_description#</textarea>';
			if (instance.obsDescription is not ''){
			view &= '		<label for="obs_description" class="error" generated="0">#instance.obsDescription#</label>';
			}

			view &= '</div>
				<div>
					<label for="obs_status"><b>Статус:</b></label> 
					<input type="radio" name="obs_status" value="1" #checkedRadio("1", form.obs_status)# /> Включена <br>
					<input type="radio" name="obs_status" value="0" #checkedRadio("0", form.obs_status)#/> Выключена <br>
				</div>';

			if (instance.obsStatus is not ''){
			view &= '		<label for="obs_status" class="error" generated="0">#instance.obsStatus#</label>';
			}

			view &= '
				<div>
					<input disabled class="g-button g-button-submit" type="submit" name="escape" value="Отмена">
					<input class="g-button g-button-submit" type="submit" name="addObject" value="Сохранить">
				</div>';

			if (instance.message is not ''){
				view &= '<div id="mes" style="color:red;">#instance.message#</div>';
			}

			view &= '
			</div></div>';

			//writeDump( request.CRequest.getAllForm() );
			//writeDump( request.CRequest.getForm( 'status' ) );

		return view;
	}

	// обработчик формы если ява выключена
	private function updateObjectFormHandler(){
		// --- обработчик формы---
		if ( isdefined('form.updateObject') ){
		  rbacAPI = factoryService.getService('rbacAPI');
		      result = rbacAPI.editeObject( #form.obs_id#, #form.obs_name# , #form.obs_type#, #form.obs_description#, #form.obs_status# );
			//writeDump(form);
			//result.RETVAL = 1;
			if ( result.RETVAL is 1 ){
				//factoryService.getService('redirector').redirect('/?page=rbac');
				if (StructKeyExists(result, 'RETDESC')) {
					instance.message = result['RETDESC'];
				} else {
					instance.message = '';
				}
			}else{
				// --- пробная версия
				if (StructKeyExists(result, 'RETDESC')) {
					instance.message = result['RETDESC'];
				} else {
					instance.message = '';
				}
				if (StructKeyExists(result.STRUCT, 'obsName')) {
					instance.obsName = result.STRUCT['obsName'];
				} else {
					instance.obsName = '';
				}
				if (StructKeyExists(result.STRUCT, 'obsType')) {
					instance.obsType = result.STRUCT['obsType'];
				} else {
					instance.obsType = '';
				}
				if (StructKeyExists(result.STRUCT, 'obsDescription')) {
					instance.obsDescription = result.STRUCT['obsDescription'];
				} else {
					instance.obsDescription = '';
				}

				if (StructKeyExists(result.STRUCT, 'obsStatus')) {
					instance.obsStatus = result.STRUCT['obsStatus'];
				} else {
					instance.obsStatus = '';
				}

			}
		}
		// --- обработчик формы---
	}

	function updateObjectForm(obsid){

		rbacAPI = factoryService.getService( 'rbacAPI' );
		qObject = rbacAPI.getObject( #arguments.obsid# );

		param name='form.obs_id' default='#qObject.obs_id#';
		param name='form.obs_name' default='#qObject.obs_name#';
		param name='form.obs_type' default='#qObject.obs_type#';
		param name='form.obs_description' default='#qObject.obs_description#';
		param name='form.obs_status' default='#qObject.obs_status#'; // включено

		var view = '';
		view &= '
			<form name="" id="" action="#request.CRequest.updateURL(false,"/?page=rbac&section=object&action=edite&obsid=#arguments.obsid#")#" method="post">
			<div class="grid_8"><div class="signin-box">
				<a class="g-button g-button-submit" href="#request.CRequest.updateURL(false,"/?page=rbac")#">Назад</a><br><br>
				<h2>Редактирование объекта</h2>
				<div>
					<label for="obs_id"><b>ID объекта:</b></label>
					<input disabled type="text" name="_obs_id" value="#form.obs_id#" size = "2" maxlength = "2">
					<input type="hidden" name="obs_id" value="#form.obs_id#" size = "2" maxlength = "2">
				</div>
				<div>
					<label for="obs_name"><b>Имя объекта:</b></label> 
					<input type="text" name="obs_name" value="#form.obs_name#" size = "50" maxlength = "50">';
			if (instance.obsName is not ''){
			view &= '		<label for="obs_name" class="error" generated="0">#instance.obsName#</label>';
			}
			view &= '
				</div>
				<div>
					<label for="obs_type"><b>Тип объекта (нужен список):</b></label>
					<input type="text" name="obs_type" value="#form.obs_type#" size = "50" maxlength = "50">';
			if (instance.obsType is not ''){
			view &= '		<label for="obs_type" class="error" generated="0">#instance.obsType#</label>';
			}
			view &= '
				</div>
				<div>
					<label for="obs_description"><b>Описание:</b></label>
					<textarea name = "obs_description" rows="6" cols="47" >#form.obs_description#</textarea>';
			if (instance.obsDescription is not ''){
			view &= '		<label for="obs_description" class="error" generated="0">#instance.obsDescription#</label>';
			}

			view &= '</div>
				<div>
					<label for="obs_status"><b>Статус:</b></label> 
					<input type="radio" name="obs_status" value="1" #checkedRadio("1", form.obs_status)# /> Включена <br>
					<input type="radio" name="obs_status" value="0" #checkedRadio("0", form.obs_status)#/> Выключена <br>
				</div>';

			if (instance.obsStatus is not ''){
			view &= '		<label for="obs_status" class="error" generated="0">#instance.obsStatus#</label>';
			}

			view &= '
				<div>
					<input disabled class="g-button g-button-submit" type="submit" name="escape" value="Отмена">
					<input class="g-button g-button-submit" type="submit" name="updateObject" value="Сохранить">
				</div>';

			if (instance.message is not ''){
				view &= '<div id="mes" style="color:red;">#instance.message#</div>';
			}

			view &= '
			</div></div>';

		return view;
	}

	// обработчик формы если ява выключена
	private function addOperationFormHandler(){
		// --- обработчик формы---
		if ( isdefined('form.addOperation') ){
		  rbacAPI = factoryService.getService('rbacAPI');
		      result = rbacAPI.addOperation( #form.ops_name# , #form.ops_type#, #form.ops_description#,  #form.ops_status# );
			//writeDump(form);
			//result.RETVAL = 1;
			if ( result.RETVAL is 1 ){
				factoryService.getService('redirector').redirect('/?page=rbac');
			}else{
				// --- пробная версия
				if (StructKeyExists(result, 'RETDESC')) {
					instance.message = result['RETDESC'];
				} else {
					instance.message = '';
				}

				if (StructKeyExists(result.STRUCT, 'opsName')) {
					instance.opsName = result.STRUCT['opsName'];
				} else {
					instance.opsName = '';
				}
				if (StructKeyExists(result.STRUCT, 'opsType')) {
					instance.opsType = result.STRUCT['opsType'];
				} else {
					instance.opsType = '';
				}
				if (StructKeyExists(result.STRUCT, 'opsDescription')) {
					instance.opsDescription = result.STRUCT['opsDescription'];
				} else {
					instance.opsDescription = '';
				}

				if (StructKeyExists(result.STRUCT, 'opsStatus')) {
					instance.opsStatus = result.STRUCT['opsStatus'];
				} else {
					instance.opsStatus = '';
				}

			}
		}
		// --- обработчик формы---
	}

	function addOperationForm(){

		param name='form.ops_name' default='';
		param name='form.ops_type' default='';
		param name='form.ops_description' default='';
		param name='form.ops_status' default='1'; // включено

		var view = '';
		view &= '
			<form name="" id="" action="#request.CRequest.updateURL(false,"/?page=rbac&section=operation&action=add")#" method="post">
			<div class="grid_8"><div class="signin-box">
				<a class="g-button g-button-submit" href="#request.CRequest.updateURL(false,"/?page=rbac")#">Назад</a><br><br>
				<h2>Добавление объекта</h2>
				<div>
					<label for="ops_name"><b>Имя операции:</b></label> 
					<input type="text" name="ops_name" value="#form.ops_name#" size = "50" maxlength = "50">';

			if (instance.opsName is not ''){
			view &= '		<label for="ops_name" class="error" generated="0">#instance.opsName#</label>';
			}

			view &= '
				</div>
				<div>
					<label for="ops_type"><b>Тип операции:</b></label>
					<input type="text" name = "ops_type" value="#form.ops_type#" size = "50" maxlength = "50" >';
			if (instance.opsType is not ''){
			view &= '		<label for="ops_type" class="error" generated="0">#instance.opsType#</label>';
			}

			view &= '
				</div>
				<div>
					<label for="ops_description"><b>Описание:</b></label>
					<textarea name = "ops_description" rows="6" cols="47" >#form.ops_description#</textarea>';
			if (instance.opsDescription is not ''){
			view &= '		<label for="ops_description" class="error" generated="0">#instance.opsDescription#</label>';
			}

			view &= '</div>
				<div>
					<label for="ops_status"><b>Статус:</b></label> 
					<input type="radio" name="ops_status" value="1" #checkedRadio("1", form.ops_status)# /> Включена <br>
					<input type="radio" name="ops_status" value="0" #checkedRadio("0", form.ops_status)#/> Выключена <br>
				</div>';

			if (instance.opsStatus is not ''){
			view &= '		<label for="ops_status" class="error" generated="0">#instance.opsStatus#</label>';
			}

			view &= '
				<div>
					<input disabled class="g-button g-button-submit" type="submit" name="escape" value="Отмена">
					<input class="g-button g-button-submit" type="submit" name="addOperation" value="Сохранить">
				</div>';

			if (instance.message is not ''){
				view &= '<div id="mes" style="color:red;">#instance.message#</div>';
			}

			view &= '
			</div></div>';

			//writeDump( request.CRequest.getAllForm() );
			//writeDump( request.CRequest.getForm( 'status' ) );

		return view;
	}

	// обработчик формы если ява выключена
	private function updateOperationFormHandler(){
		// --- обработчик формы---
		if ( isdefined('form.updateOperation') ){
		  rbacAPI = factoryService.getService('rbacAPI');
		      result = rbacAPI.editeOperation( #form.ops_id#, #form.ops_name# , #form.ops_type#, #form.ops_description#, #form.ops_status# );
			//writeDump(form);
			//result.RETVAL = 1;
			if ( result.RETVAL is 1 ){
				//factoryService.getService('redirector').redirect('/?page=rbac');
				if (StructKeyExists(result, 'RETDESC')) {
					instance.message = result['RETDESC'];
				} else {
					instance.message = '';
				}
			}else{
				// --- пробная версия
				if (StructKeyExists(result, 'RETDESC')) {
					instance.message = result['RETDESC'];
				} else {
					instance.message = '';
				}
				if (StructKeyExists(result.STRUCT, 'opsName')) {
					instance.opsName = result.STRUCT['opsName'];
				} else {
					instance.opsName = '';
				}
				if (StructKeyExists(result.STRUCT, 'opsType')) {
					instance.opsType = result.STRUCT['opsType'];
				} else {
					instance.opsType = '';
				}
				if (StructKeyExists(result.STRUCT, 'opsDescription')) {
					instance.opsDescription = result.STRUCT['opsDescription'];
				} else {
					instance.opsDescription = '';
				}

				if (StructKeyExists(result.STRUCT, 'opsStatus')) {
					instance.opsStatus = result.STRUCT['opsStatus'];
				} else {
					instance.opsStatus = '';
				}

			}
		}
		// --- обработчик формы---
	}

	function updateOperationForm(opsid){

		rbacAPI = factoryService.getService( 'rbacAPI' );
		qOperation = rbacAPI.getOperation( #arguments.opsid# );

		param name='form.ops_id' default='#qOperation.ops_id#';
		param name='form.ops_name' default='#qOperation.ops_name#';
		param name='form.ops_type' default='#qOperation.ops_type#';
		param name='form.ops_description' default='#qOperation.ops_description#';
		param name='form.ops_status' default='#qOperation.ops_status#'; // включено

		var view = '';
		view &= '
			<form name="" id="" action="#request.CRequest.updateURL(false,"/?page=rbac&section=operation&action=edite&opsid=#arguments.opsid#")#" method="post">
			<div class="grid_8"><div class="signin-box">
				<a class="g-button g-button-submit" href="#request.CRequest.updateURL(false,"/?page=rbac")#">Назад</a><br><br>
				<h2>Редактирование операции</h2>
				<div>
					<label for="ops_id"><b>ID операции:</b></label>
					<input disabled type="text" name="_ops_id" value="#form.ops_id#" size = "2" maxlength = "2">
					<input type="hidden" name="ops_id" value="#form.ops_id#" size = "2" maxlength = "2">
				</div>
				<div>
					<label for="ops_name"><b>Имя операции:</b></label> 
					<input type="text" name="ops_name" value="#form.ops_name#" size = "50" maxlength = "50">';
			if (instance.opsName is not ''){
			view &= '		<label for="ops_name" class="error" generated="0">#instance.opsName#</label>';
			}
			view &= '
				</div>
				<div>
					<label for="ops_type"><b>Тип операции (нужен список):</b></label>
					<input type="text" name="ops_type" value="#form.ops_type#" size = "50" maxlength = "50">';
			if (instance.opsType is not ''){
			view &= '		<label for="ops_type" class="error" generated="0">#instance.opsType#</label>';
			}
			view &= '
				</div>
				<div>
					<label for="ops_description"><b>Описание:</b></label>
					<textarea name = "ops_description" rows="6" cols="47" >#form.ops_description#</textarea>';
			if (instance.opsDescription is not ''){
			view &= '		<label for="ops_description" class="error" generated="0">#instance.opsDescription#</label>';
			}

			view &= '</div>
				<div>
					<label for="ops_status"><b>Статус:</b></label> 
					<input type="radio" name="ops_status" value="1" #checkedRadio("1", form.ops_status)# /> Включена <br>
					<input type="radio" name="ops_status" value="0" #checkedRadio("0", form.ops_status)#/> Выключена <br>
				</div>';

			if (instance.opsStatus is not ''){
			view &= '		<label for="ops_status" class="error" generated="0">#instance.opsStatus#</label>';
			}

			view &= '
				<div>
					<input disabled class="g-button g-button-submit" type="submit" name="escape" value="Отмена">
					<input class="g-button g-button-submit" type="submit" name="updateOperation" value="Сохранить">
				</div>';

			if (instance.message is not ''){
				view &= '<div id="mes" style="color:red;">#instance.message#</div>';
			}

			view &= '
			</div></div>';

		return view;
	}

	function groupListForm(){
		groupList = factoryService.getService('rbacAPI').getGroupList();
		var view = '';
		view &= '<div class="grid_16"><div class="signin-box"><h2>Пользовательские группы:</h2>';
			view &= '<table width="100%">
						<tr style="color:grey;">
						<td>ID группы</td> 
						<td>Имя группы</td> 
						<td>Описание</td> 
						<td>Назначенные роли</td> 
						<td>Статус</td>
						<td> --- </td>
						</tr>';

			for (var x=1; x<=groupList.recordcount; x++){
						var class = IIF(x MOD 2, DE('tr_hover'), DE('tr_hover1'));
						view &= '<tr class="block #class#">
						<td>#groupList.group_id[x]#</td> 
						<td>#groupList.group_name[x]#</td> 
						<td>#groupList.group_description[x]#</td> 
						<td>#groupList.roles_id[x]#</td> 
						<td>#groupList.group_status[x]#</td>
						<td><a href="/?page=rbac&section=group&action=edite&groupid=#groupList.group_id[x]#">Редактировать</a> | 
							<a href="/?page=rbac&section=group&action=delete&groupid=#groupList.group_id[x]#">Удалить</a></td>
						</tr>';
			}

			view &= '<tr><td style="text-align:left;" colspan="6"><a href="/?page=rbac&section=group&action=add"><br>+Добавить пользовательскую группу</a></td></tr>';

			view &= '</table>';
		view &= '</div></div>';

		return view;
	}

	function roleListForm(){
		roleList = factoryService.getService('rbacAPI').getRoleList();
		var view = '';
		view &= '<div class="grid_16"><div class="signin-box"><h2>Пользовательские роли:</h2>';
			view &= '<table width="100%">
						<tr style="color:grey;">
						<td>ID роли</td> 
						<td>Имя роли</td> 
						<td>Описание</td>
						<td>Роль потомок</td>
						<td>Роль предок</td>
						<td>Назначенные разрешения</td> 
						<td>Статус</td>
						<td> --- </td>
						</tr>';
			for (var x=1; x<=roleList.recordcount; x++){
						var class = IIF(x MOD 2, DE('tr_hover'), DE('tr_hover1'));
						view &= '<tr class="block #class#">
						<td>#roleList.role_id[x]#</td> 
						<td>#roleList.role_name[x]#</td> 
						<td>#roleList.role_description[x]#</td>
						<td>#roleList.role_child[x]#</td> 
						<td>#roleList.role_parent[x]#</td>
						<td>#roleList.prms_ids[x]#</td> 
						<td>#roleList.role_status[x]#</td>
						<td nowrap> <a href="/?page=rbac&section=role&action=edite&roleid=#roleList.role_id[x]#">Редактировать</a> | <a href="/?page=rbac&section=role&action=delete&roleid=#roleList.role_id[x]#">Удалить</a>&nbsp;</td>
						</tr>';
			}
			view &= '<tr><td style="text-align:left;" colspan="6"><a href="/?page=rbac&section=role&action=add"><br>+Добавить пользовательскую роль</a></td></tr>';

			view &= '</table>';
		view &= '</div></div>';

		return view;
	}

	function permissionListForm(){
		permissionList = factoryService.getService('rbacAPI').getPermissionList();
		var view = '';
		view &= '<div class="grid_16"><div class="signin-box"><h2>Пользовательские разрешения:</h2>';
			view &= '<table width="100%">
						<tr style="color:grey;">
						<td>ID разрешения</td> 
						<td>Имя разрешения</td> 
						<td>Описание</td>
						<td>ID Объекта</td>
						<td>ID Операции</td>
						<td>Статус</td>
						<td> --- </td>
						</tr>';
			for (var x=1; x<=permissionList.recordcount; x++){
						var class = IIF(x MOD 2, DE('tr_hover'), DE('tr_hover1'));
						view &= '<tr class="block #class#">
						<td>#permissionList.prms_id[x]#</td> 
						<td>#permissionList.prms_name[x]#</td> 
						<td>#permissionList.prms_description[x]#</td>
						<td>#permissionList.obs_id[x]#</td> 
						<td>#permissionList.ops_id[x]#</td>
						<td>#permissionList.prms_status[x]#</td>
						<td><a href="/?page=rbac&section=permission&action=edite&prmsid=#permissionList.prms_id[x]#">Редактировать</a> | <a href="/?page=rbac&section=permission&action=delete&prmsid=#permissionList.prms_id[x]#">Удалить</a></td>
						</tr>';
			}
			view &= '<tr><td style="text-align:left;" colspan="7"><a href="/?page=rbac&section=permission&action=add"><br>+Добавить разрешение</a></td></tr>';

			view &= '</table>';
		view &= '</div></div>';

		return view;
	}

	function objectListForm(){
		objectList = factoryService.getService('rbacAPI').getObjectList();
		var view = '';
		view &= '<div class="grid_16"><div class="signin-box"><h2>Объекты:</h2>';
			view &= '<table width="100%">
						<tr style="color:grey;">
						<td>ID объекта</td> 
						<td>Имя объекта</td>
						<td>Тип объекта</td> 
						<td>Описание</td>
						<td>Статус</td>
						<td> --- </td>
						</tr>';
			for (var x=1; x<=objectList.recordcount; x++){
						var class = IIF(x MOD 2, DE('tr_hover'), DE('tr_hover1'));
						view &= '<tr class="block #class#">
						<td>#objectList.obs_id[x]#</td> 
						<td>#objectList.obs_name[x]#</td>
						<td>#objectList.obs_type[x]#</td>
						<td>#objectList.obs_description[x]#</td>
						<td>#objectList.obs_status[x]#</td> 
						<td><a href="/?page=rbac&section=object&action=edite&obsid=#objectList.obs_id[x]#">Редактировать</a> | <a href="/?page=rbac&section=object&action=delete&obsid=#objectList.obs_id[x]#">Удалить</a></td>
						</tr>';
			}
			view &= '<tr><td style="text-align:left;" colspan="6"><a href="/?page=rbac&section=object&action=add"><br>+Добавить объект</a></td></tr>';

			view &= '</table>';
		view &= '</div></div>';

		return view;
	}

	function operationListForm(){
		operationList = factoryService.getService('rbacAPI').getOperationList();
		var view = '';
		view &= '<div class="grid_16"><div class="signin-box"><h2>Операции:</h2>';
			view &= '<table width="100%">
						<tr style="color:grey;">
						<td>ID оерации</td> 
						<td>Имя операции</td>
						<td>Тип операции</td> 
						<td>Описание</td>
						<td>Статус</td>
						<td> --- </td>
						</tr>';
			for (var x=1; x<=operationList.recordcount; x++){
						var class = IIF(x MOD 2, DE('tr_hover'), DE('tr_hover1'));
						view &= '<tr class="block #class#">
						<td>#operationList.ops_id[x]#</td> 
						<td>#operationList.ops_name[x]#</td>
						<td>#operationList.ops_type[x]#</td>
						<td>#operationList.ops_description[x]#</td>
						<td>#operationList.ops_status[x]#</td> 
						<td><a href="/?page=rbac&section=operation&action=edite&opsid=#operationList.ops_id[x]#">Редактировать</a> | <a href="/?page=rbac&section=operation&action=delete&opsid=#operationList.ops_id[x]#">Удалить</a></td>
						</tr>';
			}
			view &= '<tr><td style="text-align:left;" colspan="6"><a href="/?page=rbac&section=operation&action=add"><br>+Добавить операцию</a></td></tr>';

			view &= '</table>';
		view &= '</div></div>';

		return view;
	}


	function View() {
		return instance.view;
  	}

}