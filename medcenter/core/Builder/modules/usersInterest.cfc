/* 
	Виджет % от услуг--
*/

component attributeName='usersInterest' output='false'{
	// псевдо конструктор
	factoryService = request.factoryService;
	instance.view = '';

	instance.uiType = '';
	instance.uiValue = '';
	instance.uiStatus = '';

	instance.message = '';


	function Init(string section, string action) {
		section = arguments.section;
		action = arguments.action;

		if (section == 'false'){
			instance.view = usersInterestListForm();

		}else if( section == 'userInterest' ){
			if( action == 'view' ){
				userid = request.CRequest.getUrl('userid');
				instance.view = userInterestListForm(userid);

			}else if( action == 'add'){
				userid = request.CRequest.getUrl('userid');
				stid = request.CRequest.getUrl('stid');
				addUserInterestFormHandler(userid);
				instance.view = addUserInterestForm(userid,stid);

			}else if( action == 'edite' ){
				userid = request.CRequest.getUrl('userid');
				stid = request.CRequest.getUrl('stid');
				updateUserInterestFormHandler(); 
				instance.view = updateUserInterestForm(userid,stid);


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

	private function addUserInterestFormHandler(userID){

		// --- обработчик формы---
		if ( isdefined('form.addUserInterest') ){
		  if ( !isDefined('form.ui_value') ){
			form.ui_value = '';
		  }
		var userInterest = factoryService.getService('usersInterestAPI');
		  result = userInterest.addUserInterest( #form.user_id#, #form.st_id#, #form.ui_type#, #form.ui_value#, #form.ui_status# );
			//writeDump(form);
			//result.RETVAL = 1;
			if ( result.RETVAL is 1 ){
				factoryService.getService('redirector').redirect('#request.CRequest.updateURL(false,"/?page=usersInterest&section=userInterest&action=view&userid=#arguments.userID#")#');
			}else{
				// --- пробная версия
				if ( result.RETDESC is '') {
					instance.message = '';
				} else {
					instance.message = '#result.RETDESC#';
				}


				if (StructKeyExists(result.STRUCT, 'uiType')) {
					instance.uiType = result.STRUCT['uiType'];
				} else {
					instance.uiType = '';
				}
				if (StructKeyExists(result.STRUCT, 'uiValue')) {
					instance.uiValue = result.STRUCT['uiValue'];
				} else {
					instance.uiValue = '';
				}
				if (StructKeyExists(result.STRUCT, 'uiStatus')) {
					instance.uiStatus = result.STRUCT['uiStatus'];
				} else {
					instance.uiStatus = '';
				}

			}
		}
		// --- обработчик формы---
	}

	function addUserInterestForm(userID,stID){

		param name='form.user_id' default='#arguments.userID#';
		param name='form.st_id' default='#arguments.stID#';
		param name='form.ui_type' default='1';
		param name='form.ui_value' default='';
		param name='form.ui_status' default='1';

		// ---------------------------------------------------------- форма ---------------------------------------------------------------
		view = '';
		view &= '<div class="grid_8">
			<div class="signin-box">
			<a class="g-button g-button-submit" href="#request.CRequest.updateURL(false,"/?page=usersInterest&section=userInterest&action=view&userid=#arguments.userID#")#">Назад</a><br><br>
			<h2>Добавление % по типу услуг:</h2>
			<form name="" action="#request.CRequest.updateURL(false,"/?page=usersInterest&section=userInterest&action=add&userid=#arguments.userID#&stid=#arguments.stID#")#" method="post">
				<div>
					<label for="user_id"><b>ID пользователя:</b></label>
					<input disabled type="text" name="_user_id" value="#form.user_id#" size = "2" maxlength = "2">
					<input type="hidden" name="user_id" value="#form.user_id#" size = "2" maxlength = "2">
				</div>
				<div>
					<label for="st_id"><b>ID типа услуги:</b></label>
					<input disabled type="text" name="_st_id" value="#form.st_id#" size = "2" maxlength = "2">
					<input type="hidden" name="st_id" value="#form.st_id#" size = "2" maxlength = "2">
				</div>';


			view &= '
				<div>
					<label for="ui_type"><b>Тип значения:</b></label> 
					<input type="radio" name="ui_type" value="1" #checkedRadio("1", form.ui_type)# /> %  <br>
					<input type="radio" name="ui_type" value="0" #checkedRadio("0", form.ui_type)#/> Руб. <br>
				';

			if (instance.uiType is not ''){
			view &= '		<label for="ui_type" class="error" generated="0">#instance.uiType#</label>';
			}

			view &= '</div>
				<div>
					<hr>
					<label>Значение:</label>
					<input type="text" name="ui_value" value="#form.ui_value#" size="2" maxlength="2">';

   		if (instance.uiValue is not ''){
		view &= '		<label for="ui_value" class="error" generated="3">#instance.uiValue#</label>';
		}

			view &= '</div>
				<div>
					<label for="ui_status"><b>Статус:</b></label> 
					<input type="radio" name="ui_status" value="1" #checkedRadio("1", form.ui_status)# /> Включена <br>
					<input type="radio" name="ui_status" value="0" #checkedRadio("0", form.ui_status)#/> Выключена <br>
				';

			if (instance.uiStatus is not ''){
			view &= '		<label for="ui_status" class="error" generated="0">#instance.uiStatus#</label>';
			}


			view &= '
				</div>
				<div>
					<input disabled class="g-button g-button-submit" type="submit" name="escape" value="Отмена">
					<input class="g-button g-button-submit" type="submit" name="addUserInterest" value="Сохранить"> ';

			if (instance.message is not ''){
				view &= '<div id="mes" style="color:red;">#instance.message#</div>';
			}

		view &='</div></form>
			</div></div>';

			// ------------------------------------------------ форма ---------------------------------------------------------------
		return view;
	}

//
	private function updateUserInterestFormHandler(){

		// --- обработчик формы---
		if ( isdefined('form.updateUserInterest') ){
		var userInterest = factoryService.getService('usersInterestAPI');
		  result = userInterest.editeUserInterest( #form.ui_id#, #form.user_id#, #form.st_id#, #form.ui_type#, #form.ui_value#, #form.ui_status# );
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


				if (StructKeyExists(result.STRUCT, 'uiType')) {
					instance.uiType = result.STRUCT['uiType'];
				} else {
					instance.uiType = '';
				}
				if (StructKeyExists(result.STRUCT, 'uiValue')) {
					instance.uiValue = result.STRUCT['uiValue'];
				} else {
					instance.uiValue = '';
				}
				if (StructKeyExists(result.STRUCT, 'uiStatus')) {
					instance.uiStatus = result.STRUCT['uiStatus'];
				} else {
					instance.uiStatus = '';
				}

			}
		}
		// --- обработчик формы---
	}
//

	function updateUserInterestForm(userID,stID){
		usersInterest = factoryService.getService('usersInterestAPI');
                userInterest = usersInterest.getUserInterest( arguments.userID, arguments.stID );

		param name='form.ui_id' default='#userInterest.ui_id#';
		param name='form.user_id' default='#userInterest.user_id#';
		param name='form.st_id' default='#userInterest.st_id#';
		param name='form.ui_type' default='#userInterest.ui_type#';
		param name='form.ui_value' default='#userInterest.ui_value#';
		param name='form.ui_status' default='#userInterest.ui_status#';

		// ---------------------------------------------------------- форма ---------------------------------------------------------------
		view = '';
		view &= '<div class="grid_8">
			<div class="signin-box">
			<a class="g-button g-button-submit" href="#request.CRequest.updateURL(false,"/?page=usersInterest&section=userInterest&action=view&userid=#arguments.userID#")#">Назад</a><br><br>
			<h2>Редактирование % по типу услуг:</h2>
			<form name="" action="#request.CRequest.updateURL(false,"/?page=usersInterest&section=userInterest&action=edite&userid=#arguments.userID#&stid=#arguments.stID#")#" method="post">
				<div>
					<label for="ui_id"><b>ID:</b></label>
					<input disabled type="text" name="_ui_id" value="#form.ui_id#" size = "2" maxlength = "2">
					<input type="hidden" name="ui_id" value="#form.ui_id#" size = "2" maxlength = "2">
				</div>
				<div>
					<label for="user_id"><b>ID пользователя:</b></label>
					<input disabled type="text" name="_user_id" value="#form.user_id#" size = "2" maxlength = "2">
					<input type="hidden" name="user_id" value="#form.user_id#" size = "2" maxlength = "2">
				</div>
				<div>
					<label for="st_id"><b>ID типа услуги:</b></label>
					<input disabled type="text" name="_st_id" value="#form.st_id#" size = "2" maxlength = "2">
					<input type="hidden" name="st_id" value="#form.st_id#" size = "2" maxlength = "2">
				</div>';


			view &= '
				<div>
					<label for="ui_type"><b>Тип значения:</b></label> 
					<input type="radio" name="ui_type" value="1" #checkedRadio("1", form.ui_type)# /> %  <br>
					<input type="radio" name="ui_type" value="0" #checkedRadio("0", form.ui_type)#/> Руб. <br>
				';

			if (instance.uiType is not ''){
			view &= '		<label for="ui_type" class="error" generated="0">#instance.uiType#</label>';
			}

			view &= '</div>
				<div>
					<hr>
					<label>Значение:</label>
					<input type="text" name="ui_value" value="#form.ui_value#" size="2" maxlength="2">';

   		if (instance.uiValue is not ''){
		view &= '		<label for="ui_value" class="error" generated="3">#instance.uiValue#</label>';
		}

			view &= '</div>
				<div>
					<label for="ui_status"><b>Статус:</b></label> 
					<input type="radio" name="ui_status" value="1" #checkedRadio("1", form.ui_status)# /> Включена <br>
					<input type="radio" name="ui_status" value="0" #checkedRadio("0", form.ui_status)#/> Выключена <br>
				';

			if (instance.uiStatus is not ''){
			view &= '		<label for="ui_status" class="error" generated="0">#instance.uiStatus#</label>';
			}


			view &= '
				</div>
				<div>
					<input disabled class="g-button g-button-submit" type="submit" name="escape" value="Отмена">
					<input class="g-button g-button-submit" type="submit" name="updateUserInterest" value="Сохранить"> ';

			if (instance.message is not ''){
				view &= '<div id="mes" style="color:red;">#instance.message#</div>';
			}

		view &='</div></form>
			</div></div>';

			// ------------------------------------------------ форма ---------------------------------------------------------------
		return view;
	}

	function userInterestListForm(userID){
		qUser = authorization = factoryService.getService( 'authorization' ).getUser( arguments.userid );
		servicesTypeList = factoryService.getService('servicesTypeAPI').getServicesTypeList();
		usersInterest = factoryService.getService('usersInterestAPI');

		var view = '';
		view &= '<div class="grid_16"><div class="signin-box">
			<a class="g-button g-button-submit" href="#request.CRequest.updateURL(false,"/?page=usersInterest")#">Назад</a><br><br>
			<h2>#qUser.emp_family# #qUser.emp_firstname# #qUser.emp_lastname# % от услуг:</h2><hr>';

			view &= '<table width="100%">
						<tr style="color:grey;">
						<td>Наименование</td> 
						<td>Тип</td> 
						<td>Значение</td>
						<td>Статус</td>
						<td> --- </td>
						</tr>';

        	for ( var y=1; y<=servicesTypeList.recordcount; y++){ 
                        UI = usersInterest.getUserInterest( qUser.user_id, servicesTypeList.st_id[y] );
			view &= '<tr class="block">';
				if (UI.recordcount == 0){
					view &= '<td style="text-align:left;color:grey;" colspan="4">&nbsp#servicesTypeList.st_name[y]# - услуги отключены</td>
						<td><a href="/?page=usersInterest&section=userInterest&action=add&userid=#qUser.user_id#&stid=#servicesTypeList.st_id[y]#">Добавить</a></td>';
				}else{
					view &= '<td style="text-align:left;">&nbsp#servicesTypeList.st_name[y]#</td> 
					<td>#UI.ui_type#</td> 
					<td>#UI.ui_value#</td>
					<td>#UI.ui_status#</td>
					<td><a href="/?page=usersInterest&section=userInterest&action=edite&userid=#qUser.user_id#&stid=#UI.st_id#">Редактировать</a></td>';
				}
			view &= '</tr>';

		}

		view &= '</table>';

		view &= '</div></div>';

		return view;
	}

	function usersInterestListForm(){
		userList = factoryService.getService('usersAPI').getUserList();
		servicesTypeList = factoryService.getService('servicesTypeAPI').getServicesTypeList();

		usersInterest = factoryService.getService('usersInterestAPI');
				
		var view = '';

		view &= '<div class="grid_16"><div class="signin-box"><h2>Список врачей и пречитающиеся %:</h2>';
			view &= '<table width="100%">
						<tr style="color:grey;">
						<td>Пользователь</td>';
						for ( var y=1; y<=servicesTypeList.recordcount; y++){ 
							view &= '<td>#servicesTypeList.st_name[y]#</td>';
						} 
						view &= '<td> --- </td>
						</tr>';

			for (var x=1; x<=userList.recordcount; x++){
						var class = IIF(x MOD 2, DE('tr_hover'), DE('tr_hover1'));
						view &= '<tr class="block #class#">
						<td style="text-align:left;">&nbsp#userList.user_id[x]#. <b>#userList.emp_family[x]# #Left(userList.emp_firstname[x],1)#.#Left(userList.emp_lastname[x],1)#.</b> <font color="grey">#userList.emp_type[x]#</font></td>';
						for ( var y=1; y<=servicesTypeList.recordcount; y++){
							UI = usersInterest.getUserInterest( userList.user_id[x], servicesTypeList.st_id[y] );
							if (UI.recordcount == 0){
								value = '<font color="red"> - </font>';
							}else{
								value = '<font color="green">#UI.ui_value#</font>';
							}
							view &= '<td>#value#</td>';
						}
						view &= '<td> <a href="/?page=usersInterest&section=userInterest&action=view&userid=#userList.user_id[x]#">Редактировать</a> </td>
						</tr>';
			}


			view &= '</table>';
		view &= '</div></div>';
		return view;
	}

	function View() {
		return instance.view;
  	}

}