/* 
	Виджет список пользователей --
*/

component attributeName='userlist' output='false'{
	// псевдо конструктор
	factoryService = request.factoryService;

	instance.view = '';

	instance.userName = '';
	instance.userPass = '';
	instance.userPass1 = '';
	instance.userStatus = '';
	instance.userGroups = '';
	instance.empType = '';
	instance.empFamily = '';
	instance.empFirstname = '';
	instance.empLastname = '';
	instance.empDescription = '';

	instance.message = '';


	function Init(string section, string action) {
		section = arguments.section;
		action = arguments.action;

		if (section == 'false'){
			instance.view = userListForm();

		}else if( section == 'user' ){
			if( action == 'add' ){
				addUserFormHandler();
				instance.view = addUserForm();

			}else if( action == 'edite' ){
				userid = request.CRequest.getUrl('userid');
				updateUserFormHandler(); 
				instance.view = updateUserForm(userid);

			}else if( action == 'delete'){
				instance.view = 'delete group';

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

	private function addUserFormHandler(){

		// --- обработчик формы---
		if ( isdefined('form.addUser') ){
		  if ( !isDefined('form.user_groups') ){
			form.user_groups = '';
		  }
		  if ( !isDefined('form.emp_type') ){
			form.emp_type = '';
		  }
		var authorization = factoryService.getService('authorization');
		  result = authorization.registrationUser( #form.user_name#, #form.user_pass#, #form.user_pass1#, #form.user_status#, #form.user_groups#, #form.emp_type#, #form.emp_family#, #form.emp_firstname#, #form.emp_lastname#, #form.emp_description# );
			//writeDump(form);
			//result.RETVAL = 1;
			if ( result.RETVAL is 1 ){
				factoryService.getService('redirector').redirect('#request.CRequest.updateURL(false,"/?page=users")#');
			}else{
				// --- пробная версия
				if ( result.RETDESC is '') {
					instance.message = '';
				} else {
					instance.message = '#result.RETDESC#';
				}


				if (StructKeyExists(result.STRUCT, 'userName')) {
					instance.userName = result.STRUCT['userName'];
				} else {
					instance.userName = '';
				}
				if (StructKeyExists(result.STRUCT, 'userPass')) {
					instance.userPass = result.STRUCT['userPass'];
				} else {
					instance.userPass = '';
				}
				if (StructKeyExists(result.STRUCT, 'userPass1')) {
					instance.userPass1 = result.STRUCT['userPass1'];
				} else {
					instance.userPass1 = '';
				}

				if (StructKeyExists(result.STRUCT, 'userStatus')) {
					instance.userStatus = result.STRUCT['userStatus'];
				} else {
					instance.userStatus = '';
				}
				if (StructKeyExists(result.STRUCT, 'userGroups')) {
					instance.userGroups = result.STRUCT['userGroups'];
				} else {
					instance.userGroups = '';
				}
				if (StructKeyExists(result.STRUCT, 'empType')) {
					instance.empType = result.STRUCT['empType'];
				} else {
					instance.empType = '';
				}

				if (StructKeyExists(result.STRUCT, 'empFamily')) {
					instance.empFamily = result.STRUCT['empFamily'];
				} else {
					instance.empFamily = '';
				}

				if (StructKeyExists(result.STRUCT, 'empFirstname')) {
					instance.empFirstname = result.STRUCT['empFirstname'];
				} else {
					instance.empFirstname = '';
				}
				if (StructKeyExists(result.STRUCT, 'empLastname')) {
					instance.empLastname = result.STRUCT['empLastname'];
				} else {
					instance.empLastname = '';
				}
				if (StructKeyExists(result.STRUCT, 'empDescription')) {
					instance.empDescription = result.STRUCT['empDescription'];
				} else {
					instance.empDescription = '';
				}                           


			}
		}
		// --- обработчик формы---
	}

	function addUserForm(){
		param name='form.user_name' default='';
		param name='form.user_pass' default='';
		param name='form.user_pass1' default='';
		param name='form.user_status' default='0';
		param name='form.user_groups' default='';
		param name='form.emp_type' default='';

		param name='form.emp_family' default='';
		param name='form.emp_firstname' default='';
		param name='form.emp_lastname' default='';
		param name='form.emp_description' default='';

		// ---------------------------------------------------------- форма ---------------------------------------------------------------
		action = '#request.CRequest.updateURL(false,"/?page=users&section=user&action=add")#';

		view = '';
		view &= '<div class="grid_8">
			<div class="signin-box">
			<a class="g-button g-button-submit" href="#request.CRequest.updateURL(false,"/?page=users")#">Назад</a><br><br>
			<h2>Добавление учётной записи:</h2>
			<form id="registration" name="registration" action="#action#" method="post">
				<div>
					<label for="userName"><strong class="username-label">Логин</strong></label>
					<input type="text" id="username" name="user_name" value="#form.user_name#" maxlength="20" size="20">';

		if (instance.userName is not ''){
		view &= '		<label for="userName" class="error" generated="0">#instance.userName#</label>';
		}

		view &= '	</div>
				<div>
					<label><strong class="passwd-label">Пароль</strong></label>
					<input type="password" id="password" name="user_pass" value="#form.user_pass#" maxlength="20">';
   		if (instance.userPass is not ''){
		view &= '		<label for="userPass" class="error" generated="1">#instance.userPass#</label>';
		}

		view &= '	</div>
				<div>
					<label>Повторите пароль:</label>
					<input type="password" id="userpass1" name="user_pass1" value="#form.user_pass1#" maxlength="20">';
   		if (instance.userPass1 is not ''){
		view &= '		<label for="userPass1" class="error" generated="2">#instance.userPass1#</label>';
		}

		view &= '	</div>
				<div>
					<hr>
					<label>Фамилия:</label>
					<input type="text" id="family" name="emp_family" value="#form.emp_family#" maxlength="20">';

   		if (instance.empFamily is not ''){
		view &= '		<label for="family" class="error" generated="3">#instance.empFamily#</label>';
		}

		view &= '	</div>
				<div>
					<label>Имя:</label>
					<input type="text" name="emp_firstname" value="#form.emp_firstname#" maxlength="20" >';

   		if (instance.empFirstname is not ''){
		view &='		<label for="firstname" class="error" generated="4">#instance.empFirstname#</label>';
		}

		view &='	</div>
				<div>
					<label>Отчество:</label>
					<input type="text" name="emp_lastname" value="#form.emp_lastname#" maxlength="20" >';

   		if (instance.empLastname is not ''){
		view &='		<label for="lastname" class="error" generated="5">#instance.empLastname#</label>';
		}

		view &= '	</div>
				<div>
					<label>Описание:</label>
					<textarea name = "emp_description" rows="6" cols="48" >#form.emp_description#</textarea>';

   		if (instance.empDescription is not ''){
		view &= '		<label for="description" class="error" generated="3">#instance.empDescription#</label>';
		}

		view &= '	</div>
				<div>
					<label><b>Пользовательские группы:</b></label>';

				groupList = factoryService.getService('rbacAPI').getGroupList();
				for (var x=1; x<=groupList.recordcount; x++){
					view &= '
						<input type="radio" name="user_groups" value="#groupList.group_id[x]#" #checkedRadio("#groupList.group_id[x]#", form.user_groups)#/> #groupList.group_name[x]# <br>';
                		}

   		if (instance.userGroups is not ''){
		view &= '		<label for="user_groups" class="error" generated="3">#instance.userGroups#</label>';
		}

			view &= '
				</div>
				<div>
					<label for="emp_type"><b>Типы служащих:</b></label> ';

				employeesList = factoryService.getService('employeesAPI').getEmployeesList();
				for (var x=1; x<=employeesList.recordcount; x++){
					view &= '
						<input type="checkbox" name="emp_type" value="#employeesList.empt_id[x]#" ';
						if ( ListFind( form.emp_type , employeesList.empt_id[x] ) ) {
							view &= 'checked';
						} 
					view &= '/> #employeesList.empt_name[x]# <br>';
                		}
			if (instance.empType is not ''){
			view &= '		<label for="emp_type" class="error" generated="0">#instance.empType#</label>';
			}

			view &= '</div>
				<div>
					<label for="user_status"><b>Статус:</b></label> 
					<input type="radio" name="user_status" value="1" #checkedRadio("1", form.user_status)# /> Включена <br>
					<input type="radio" name="user_status" value="0" #checkedRadio("0", form.user_status)#/> Выключена <br>
				';

			if (instance.userStatus is not ''){
			view &= '		<label for="user_status" class="error" generated="0">#instance.userStatus#</label>';
			}


			view &= '
				</div>
				<div>
					<input disabled class="g-button g-button-submit" type="submit" name="escape" value="Отмена">
					<input class="g-button g-button-submit" type="submit" name="addUser" value="Сохранить"> ';

			if (instance.message is not ''){
				view &= '<div id="mes" style="color:red;">#instance.message#</div>';
			}

		view &='</div></form>
			</div></div>';

			// ------------------------------------------------ форма ---------------------------------------------------------------
		return view;
	}

	private function updateUserFormHandler(){

		// --- обработчик формы---
		if ( isdefined('form.updateUser') ){
		  if ( !isDefined('form.user_groups') ){
			form.user_groups = '';
		  }
		  if ( !isDefined('form.emp_type') ){
			form.emp_type = '';
		  }
		var authorization = factoryService.getService('authorization');
		  result = authorization.editeUser( #form.user_id#, #form.user_name#, #form.user_pass#, #form.user_pass1#, #form.user_status#, #form.user_groups#, #form.emp_type#, #form.emp_family#, #form.emp_firstname#, #form.emp_lastname#, #form.emp_description# );
			//writeDump(form);
			//result.RETVAL = 1;
			if ( result.RETVAL is 1 ){
				if (StructKeyExists(result, 'RETDESC')) {
					instance.message = result['RETDESC'];
				} else {
					instance.message = '';
				}
			}else{
				// --- пробная версия
				if ( result.RETDESC is '') {
					instance.message = '';
				} else {
					instance.message = '#result.RETDESC#';
				}


				if (StructKeyExists(result.STRUCT, 'userName')) {
					instance.userName = result.STRUCT['userName'];
				} else {
					instance.userName = '';
				}
				if (StructKeyExists(result.STRUCT, 'userPass')) {
					instance.userPass = result.STRUCT['userPass'];
				} else {
					instance.userPass = '';
				}
				if (StructKeyExists(result.STRUCT, 'userPass1')) {
					instance.userPass1 = result.STRUCT['userPass1'];
				} else {
					instance.userPass1 = '';
				}

				if (StructKeyExists(result.STRUCT, 'userStatus')) {
					instance.userStatus = result.STRUCT['userStatus'];
				} else {
					instance.userStatus = '';
				}
				if (StructKeyExists(result.STRUCT, 'userGroups')) {
					instance.userGroups = result.STRUCT['userGroups'];
				} else {
					instance.userGroups = '';
				}
				if (StructKeyExists(result.STRUCT, 'empType')) {
					instance.empType = result.STRUCT['empType'];
				} else {
					instance.empType = '';
				}

				if (StructKeyExists(result.STRUCT, 'empFamily')) {
					instance.empFamily = result.STRUCT['empFamily'];
				} else {
					instance.empFamily = '';
				}

				if (StructKeyExists(result.STRUCT, 'empFirstname')) {
					instance.empFirstname = result.STRUCT['empFirstname'];
				} else {
					instance.empFirstname = '';
				}
				if (StructKeyExists(result.STRUCT, 'empLastname')) {
					instance.empLastname = result.STRUCT['empLastname'];
				} else {
					instance.empLastname = '';
				}
				if (StructKeyExists(result.STRUCT, 'empDescription')) {
					instance.empDescription = result.STRUCT['empDescription'];
				} else {
					instance.empDescription = '';
				}                           


			}
		}
		// --- обработчик формы---
	}

	function updateUserForm( userid){

		authorization = factoryService.getService( 'authorization' );
		qUser = authorization.getUser( arguments.userid );

		param name='form.user_id' default='#qUser.user_id#';
		param name='form.user_name' default='#qUser.user_name#';
		param name='form.user_pass' default='#qUser.user_pass#';
		param name='form.user_pass1' default='#qUser.user_pass#';
		param name='form.user_status' default='#qUser.user_status#';
		param name='form.user_groups' default='#qUser.user_groups#';
		param name='form.emp_type' default='#qUser.emp_type#';

		param name='form.emp_family' default='#qUser.emp_family#';
		param name='form.emp_firstname' default='#qUser.emp_firstname#';
		param name='form.emp_lastname' default='#qUser.emp_lastname#';
		param name='form.emp_description' default='#qUser.emp_description#';

		// ---------------------------------------------------------- форма ---------------------------------------------------------------
		action = '#request.CRequest.updateURL(false,"/?page=users&section=user&action=edite&userid=#qUser.user_id#")#';

		view = '';
		view &= '<div class="grid_8">
			<div class="signin-box">
			<a class="g-button g-button-submit" href="#request.CRequest.updateURL(false,"/?page=users")#">Назад</a><br><br>
			<h2>Редактирование учётной записи:</h2>
			<form id="registration" name="registration" action="#action#" method="post">
				<div>
					<label for="user_id"><b>ID пользователя:</b></label>
					<input disabled type="text" name="_user_id" value="#form.user_id#" size = "2" maxlength = "2">
					<input type="hidden" name="user_id" value="#form.user_id#" size = "2" maxlength = "2">
				</div>
				<div>
					<label for="userName"><strong class="username-label">Логин</strong></label>
					<input type="text" id="username" name="user_name" value="#form.user_name#" maxlength="20" size="20">';

		if (instance.userName is not ''){
		view &= '		<label for="userName" class="error" generated="0">#instance.userName#</label>';
		}

		view &= '	</div>
				<div>
					<label><strong class="passwd-label">Пароль</strong></label>
					<input type="password" id="password" name="user_pass" value="#form.user_pass#" maxlength="20">';
   		if (instance.userPass is not ''){
		view &= '		<label for="userPass" class="error" generated="1">#instance.userPass#</label>';
		}

		view &= '	</div>
				<div>
					<label>Повторите пароль:</label>
					<input type="password" id="userpass1" name="user_pass1" value="#form.user_pass1#" maxlength="20">';
   		if (instance.userPass1 is not ''){
		view &= '		<label for="userPass1" class="error" generated="2">#instance.userPass1#</label>';
		}

		view &= '	</div>
				<div>
					<hr>
					<label>Фамилия:</label>
					<input type="text" id="family" name="emp_family" value="#form.emp_family#" maxlength="20">';

   		if (instance.empFamily is not ''){
		view &= '		<label for="family" class="error" generated="3">#instance.empFamily#</label>';
		}

		view &= '	</div>
				<div>
					<label>Имя:</label>
					<input type="text" name="emp_firstname" value="#form.emp_firstname#" maxlength="20" >';

   		if (instance.empFirstname is not ''){
		view &='		<label for="firstname" class="error" generated="4">#instance.empFirstname#</label>';
		}

		view &='	</div>
				<div>
					<label>Отчество:</label>
					<input type="text" name="emp_lastname" value="#form.emp_lastname#" maxlength="20" >';

   		if (instance.empLastname is not ''){
		view &='		<label for="lastname" class="error" generated="5">#instance.empLastname#</label>';
		}

		view &= '	</div>
				<div>
					<label>Описание:</label>
					<textarea name = "emp_description" rows="6" cols="48" >#form.emp_description#</textarea>';

   		if (instance.empDescription is not ''){
		view &= '		<label for="description" class="error" generated="3">#instance.empDescription#</label>';
		}

		view &= '	</div>
				<div>
					<label><b>Пользовательские группы:</b></label>';

				groupList = factoryService.getService('rbacAPI').getGroupList();
				for (var x=1; x<=groupList.recordcount; x++){
					view &= '
						<input type="radio" name="user_groups" value="#groupList.group_id[x]#" #checkedRadio("#groupList.group_id[x]#", form.user_groups)#/> #groupList.group_name[x]# <br>';
                		}

   		if (instance.userGroups is not ''){
		view &= '		<label for="user_groups" class="error" generated="3">#instance.userGroups#</label>';
		}

			view &= '
				</div>
				<div>
					<label for="emp_type"><b>Типы служащих:</b></label> ';

				employeesList = factoryService.getService('employeesAPI').getEmployeesList();
				for (var x=1; x<=employeesList.recordcount; x++){
					view &= '
						<input type="checkbox" name="emp_type" value="#employeesList.empt_id[x]#" ';
						if ( ListFind( form.emp_type , employeesList.empt_id[x] ) ) {
							view &= 'checked';
						} 
					view &= '/> #employeesList.empt_name[x]# <br>';
                		}
			if (instance.empType is not ''){
			view &= '		<label for="emp_type" class="error" generated="0">#instance.empType#</label>';
			}

			view &= '</div>
				<div>
					<label for="user_status"><b>Статус:</b></label> 
					<input type="radio" name="user_status" value="1" #checkedRadio("1", form.user_status)# /> Включена <br>
					<input type="radio" name="user_status" value="0" #checkedRadio("0", form.user_status)#/> Выключена <br>
				';

			if (instance.userStatus is not ''){
			view &= '		<label for="user_status" class="error" generated="0">#instance.userStatus#</label>';
			}


			view &= '
				</div>
				<div>
					<input disabled class="g-button g-button-submit" type="submit" name="escape" value="Отмена">
					<input class="g-button g-button-submit" type="submit" name="updateUser" value="Сохранить"> ';

			if (instance.message is not ''){
				view &= '<div id="mes" style="color:red;">#instance.message#</div>';
			}

		view &='</div></form>
			</div></div>';

			// ------------------------------------------------ форма ---------------------------------------------------------------
		return view;
	}


	function userListForm(){
		userList = factoryService.getService('usersAPI').getAllUserList();
		var view = '';
		view &= '<div class="grid_16"><div class="signin-box"><h2>Учётные записи:</h2>';
			view &= '<table width="100%">
						<tr style="color:grey;">
						<td>id</td> 
						<td>Логин</td> 
						<td>Пароль</td> 
						<td>Группы</td> 
						<td>Статус</td>
						<td>Тип служащего</td>
						<td>Фамилия</td>
						<td>Имя</td>
						<td>Отчество</td>
						<!--- <td>Описание</td> --->
						<td> --- </td>
						</tr>';
			//writeDump(userList);
			//		<td>userList.empt_name[x]</td>
			for (var x=1; x<=userList.recordcount; x++){
				var class = IIF(x MOD 2, DE('tr_hover'), DE('tr_hover1'));
				view &= '<tr class="block #class#">
					<td>#userList.user_id[x]#</td> 
					<td>#userList.user_name[x]#</td> 
					<td>#userList.user_pass[x]#</td> 
					<td>#userList.user_groups[x]#</td> 
					<td>#userList.user_status[x]#</td>
					<td>#userList.emp_type[x]#</td> 
					<td>#userList.emp_family[x]#</td>
					<td>#userList.emp_firstname[x]#</td>
					<td>#userList.emp_lastname[x]#</td>
					<!--- <td>#userList.emp_description[x]#</td> --->
					<td> <a href="/?page=users&section=user&action=edite&userid=#userList.user_id[x]#">Редактировать</a> | <a href="/?page=users&section=user&action=delete&userid=#userList.user_id[x]#">Удалить</a> </td>
					</tr>';
			}

			view &= '<tr><td style="text-align:left;" colspan="10"><a href="/?page=users&section=user&action=add"><br>+Добавить пользователя</a></td></tr>';

			view &= '</table>';
		view &= '</div></div>';

		return view;
	}

	// ///////////////////



	function View() {
		return instance.view;
  	}

}