/*
	Виджет типы служащих --
*/

component attributeName='employees' output='false'{
	// псевдо конструктор
	factoryService = request.factoryService;
	//authorization = factoryService.getService('authorization');

	instance.view = '';

	instance.emptName = '';
	instance.emptDescription = '';
	instance.emptParent = '';
	instance.emptChild = '';
	instance.emptStatus = '';

	instance.message = '';

	function Init(string section, string action) {
		section = arguments.section;
		action = arguments.action;

		if (section == 'false'){
			instance.view = employeeListForm();

		}else if( section == 'employees' ){
			if( action == 'add' ){
				addEmployeeFormHandler();
				instance.view = addEmployeeForm();

			}else if( action == 'edite' ){
				emptid = request.CRequest.getUrl('emptid');
				updateEmployeeFormHandler(); 
				instance.view = updateEmployeeForm(emptid);

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

	// обработчик формы если ява выключена
	private function addEmployeeFormHandler(){
		// --- обработчик формы---
		if ( isdefined('form.addEmployee') ){
		  if ( !isDefined('form.empt_parent') ){
			form.empt_parent = '';
		  }
		  if ( !isDefined('form.empt_child') ){
			form.empt_child = '';
		  }
		  employeesAPI = factoryService.getService('employeesAPI');
		      result = employeesAPI.addEmployee( #form.empt_name# , #form.empt_description#, #form.empt_parent#, #form.empt_child#, #form.empt_status# );
			//writeDump(form);
			//result.RETVAL = 1;
			if ( result.RETVAL is 1 ){
				factoryService.getService('redirector').redirect('/?page=typeEmployees');
			}else{
				// --- пробная версия
				if (StructKeyExists(result, 'RETDESC')) {
					instance.message = result['RETDESC'];
				} else {
					instance.message = '';
				}

				if (StructKeyExists(result.STRUCT, 'emptName')) {
					instance.emptName = result.STRUCT['emptName'];
				} else {
					instance.emptName = '';
				}
				if (StructKeyExists(result.STRUCT, 'emptDescription')) {
					instance.emptDescription = result.STRUCT['emptDescription'];
				} else {
					instance.emptDescription = '';
				}
				if (StructKeyExists(result.STRUCT, 'emptParent')) {
					instance.emptParent = result.STRUCT['emptParent'];
				} else {
					instance.emptParent = '';
				}
				if (StructKeyExists(result.STRUCT, 'emptChild')) {
					instance.emptChild = result.STRUCT['emptChild'];
				} else {
					instance.emptChild = '';
				}
				if (StructKeyExists(result.STRUCT, 'emptStatus')) {
					instance.emptStatus = result.STRUCT['emptStatus'];
				} else {
					instance.emptStatus = '';
				}

			}
		}
		// --- обработчик формы---
	}

	function addEmployeeForm(){

		param name='form.empt_name' default='';
		param name='form.empt_description' default='';
		param name='form.empt_parent' default='';
		param name='form.empt_child' default='';
		param name='form.empt_status' default='1'; // включено

		var view = '';
		view &= '
			<form name="" id="" action="#request.CRequest.updateURL(false,"/?page=typeEmployees&section=employees&action=add")#" method="post">
			<div class="grid_8"><div class="signin-box">
				<a class="g-button g-button-submit" href="#request.CRequest.updateURL(false,"/?page=typeEmployees")#">Назад</a><br><br>
				<h2>Добавление типа служащего</h2>
				<div>
					<label for="empt_name"><b>Наименование:</b></label> 
					<input type="text" name="empt_name" value="#form.empt_name#" size = "50" maxlength = "50">';

			if (instance.emptName is not ''){
			view &= '		<label for="empt_name" class="error" generated="0">#instance.emptName#</label>';
			}

			view &= '
				</div>
				<div>
					<label for="empt_description"><b>Описание:</b></label>
					<textarea name = "empt_description" rows="6" cols="47" >#form.empt_description#</textarea>';

			if (instance.emptDescription is not ''){
			view &= '		<label for="empt_description" class="error" generated="0">#instance.emptDescription#</label>';
			}

			view &= '
				</div>
				<div>
					<label for="empt_parent"><b>Родительский тип:</b></label>
					<input type="radio" name="empt_parent" value="" #checkedRadio("", form.empt_parent)# /> None <br> ';

				employeesList = factoryService.getService('employeesAPI').getEmployeesList();
				for (var x=1; x<=employeesList.recordcount; x++){
					view &= '
						<input type="radio" name="empt_parent" value="#employeesList.empt_id[x]#" #checkedRadio("#employeesList.empt_id[x]#", form.empt_parent)#/> #employeesList.empt_name[x]# <br>';
                		}
			if (instance.emptParent is not ''){
			view &= '		<label for="empt_parent" class="error" generated="0">#instance.emptParent#</label>';
			}

			view &= '</div>
				<div>
					<label for="empt_status"><b>Статус:</b></label> 
					<input type="radio" name="empt_status" value="1" #checkedRadio("1", form.empt_status)# /> Включена <br>
					<input type="radio" name="empt_status" value="0" #checkedRadio("0", form.empt_status)#/> Выключена <br>
				</div>';

			if (instance.emptStatus is not ''){
			view &= '		<label for="empt_status" class="error" generated="0">#instance.emptStatus#</label>';
			}

			view &= '
				<div>
					<input disabled class="g-button g-button-submit" type="submit" name="escape" value="Отмена">
					<input class="g-button g-button-submit" type="submit" name="addEmployee" value="Сохранить">
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

	private function updateEmployeeFormHandler(){
		// --- обработчик формы---
		if ( isdefined('form.updateEmployee') ){
		  if ( !isDefined('form.empt_parent') ){
			form.empt_parent = '';
		  }
		  if ( !isDefined('form.empt_child') ){
			form.empt_child = '';
		  }
		  employeesAPI = factoryService.getService('employeesAPI');
		      result = employeesAPI.editeEmployee( #form.empt_id#, #form.empt_name# , #form.empt_description#, #form.empt_parent#, #form.empt_child#, #form.empt_status# );
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

				if (StructKeyExists(result.STRUCT, 'emptName')) {
					instance.emptName = result.STRUCT['emptName'];
				} else {
					instance.emptName = '';
				}
				if (StructKeyExists(result.STRUCT, 'emptDescription')) {
					instance.emptDescription = result.STRUCT['emptDescription'];
				} else {
					instance.emptDescription = '';
				}
				if (StructKeyExists(result.STRUCT, 'emptParent')) {
					instance.emptParent = result.STRUCT['emptParent'];
				} else {
					instance.emptParent = '';
				}
				if (StructKeyExists(result.STRUCT, 'emptChild')) {
					instance.emptChild = result.STRUCT['emptChild'];
				} else {
					instance.emptChild = '';
				}
				if (StructKeyExists(result.STRUCT, 'emptStatus')) {
					instance.emptStatus = result.STRUCT['emptStatus'];
				} else {
					instance.emptStatus = '';
				}
			}
		}
		// --- обработчик формы---
	}

	function updateEmployeeForm( emptid ){

		employeesAPI = factoryService.getService( 'employeesAPI' );
		qEmployee = employeesAPI.getEmployee( arguments.emptid );
		var view = '';

		param name='form.empt_id' default='#qEmployee.empt_id#';
		param name='form.empt_name' default='#qEmployee.empt_name#';
		param name='form.empt_description' default='#qEmployee.empt_description#';
		param name='form.empt_parent' default='#qEmployee.empt_parent#';
		param name='form.empt_child' default='#qEmployee.empt_child#';
		param name='form.empt_status' default='#qEmployee.empt_status#';

		var view = '';
		view &= '
			<form name="" id="" action="#request.CRequest.updateURL(false,"/?page=typeEmployees&section=employees&action=edite&emptid=#arguments.emptid#")#" method="post">
			<div class="grid_8"><div class="signin-box">
				<a class="g-button g-button-submit" href="#request.CRequest.updateURL(false,"/?page=typeEmployees")#">Назад</a><br><br>
				<h2>Редактирование типа служащего</h2>
				<div>
					<label for="empt_id"><b>ID типа:</b></label>
					<input disabled type="text" name="_empt_id" value="#form.empt_id#" size = "2" maxlength = "2">
					<input type="hidden" name="empt_id" value="#form.empt_id#" size = "2" maxlength = "2">
				</div>
				<div>
					<label for="empt_name"><b>Наименование типа:</b></label> 
					<input type="text" name="empt_name" value="#form.empt_name#" size = "50" maxlength = "50">';

			if (instance.emptName is not ''){
			view &= '		<label for="empt_name" class="error" generated="0">#instance.emptName#</label>';
			}

			view &= '
				</div>
				<div>
					<label for="empt_description"><b>Описание:</b></label>
					<textarea name = "empt_description" rows="6" cols="47" >#form.empt_description#</textarea>';
			if (instance.emptDescription is not ''){
			view &= '		<label for="empt_description" class="error" generated="0">#instance.emptDescription#</label>';
			}

			view &= '
				</div>
				<div>
					<label for="empt_parent"><b>Родительский тип:</b></label>
					<input type="radio" name="empt_parent" value="" #checkedRadio("", form.empt_parent)# /> None <br> ';

			// нужен не полный список а только разделы
			employeesList = factoryService.getService('employeesAPI').getEmployeesList();
			for (var x=1; x<=employeesList.recordcount; x++){
				view &= '
					<input type="radio" name="empt_parent" value="#employeesList.empt_id[x]#" #checkedRadio("#employeesList.empt_id[x]#", form.empt_parent)#/> #employeesList.empt_name[x]# <br>';

			}

			view &= '</div>
				<div>
					<label for="empt_status"><b>Статус:</b></label> 
					<input type="radio" name="empt_status" value="1" #checkedRadio("1", form.empt_status)# /> Включена <br>
					<input type="radio" name="empt_status" value="0" #checkedRadio("0", form.empt_status)# /> Выключена <br>
				</div>
				<div>
					<input disabled class="g-button g-button-submit" type="submit" name="escape" value="Отмена">
					<input class="g-button g-button-submit" type="submit" name="updateEmployee" value="Сохранить">
				</div>';

			if (instance.message is not ''){
				view &= '<div id="mes" style="color:red;">#instance.message#</div>';
			}

			view &= '
			</div></div>';
		return view;
	}


	function employeeListForm(){
		employeesList = factoryService.getService('employeesAPI').getEmployeesList();
		var view = '';
		view &= '<div class="grid_16"><div class="signin-box"><h2>Типы служащих:</h2>';
			view &= '<table width="100%">
						<tr style="color:grey;">
						<td>ID</td> 
						<td>Наименование</td>
						<td>Описание</td>
						<td>Предок</td>
						<td>Потомок</td>
						<td>Статус</td>
						<td> --- </td>
						</tr>';
			for (var x=1; x<=employeesList.recordcount; x++){
						var class = IIF(x MOD 2, DE('tr_hover'), DE('tr_hover1'));
						view &= '<tr class="block #class#">
						<td>#employeesList.empt_id[x]#</td> 
						<td>#employeesList.empt_name[x]#</td>
						<td>#employeesList.empt_description[x]#</td>
						<td>#employeesList.empt_parent[x]#</td>
						<td>#employeesList.empt_child[x]#</td>
						<td>#employeesList.empt_status[x]#</td> 
						<td><a href="/?page=typeEmployees&section=employees&action=edite&emptid=#employeesList.empt_id[x]#">Редактировать</a> | 
							<a href="/?page=typeEmployees&section=employees&action=delete&emptid=#employeesList.empt_id[x]#">Удалить</a></td>
						</tr>';
			}
			view &= '<tr><td style="text-align:left;" colspan="6"><a href="/?page=typeEmployees&section=employees&action=add"><br>+Добавить тип служащего</a></td></tr>';

			view &= '</table>';
		view &= '</div></div>';

		return view;
	}

	function View() {
		return instance.view;
  	}

}