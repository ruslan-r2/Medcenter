/* 
	Виджет список типов услуг --
*/

component attributeName='serviceTypelist' output='false'{
	// псевдо конструктор
	factoryService = request.factoryService;

	instance.view = '';
	instance.stName = '';
	instance.stDescription = '';
	instance.stStatus = '';
	instance.message = '';

	function Init(string section, string action) {
		section = arguments.section;
		action = arguments.action;

		if (section == 'false'){
			instance.view = servicesTypeListForm();

		}else if( section == 'serviceType' ){
			if( action == 'add' ){
				addServiceTypeFormHandler();
				instance.view = addServiceTypeForm();

			}else if( action == 'edite' ){
				stid = request.CRequest.getUrl('stid');
				updateServiceTypeFormHandler(); 
				instance.view = updateServiceTypeForm(stid);

			}else if( action == 'delete'){
				instance.view = 'delete services type';

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
	private function addServiceTypeFormHandler(){
		// --- обработчик формы---
		if ( isdefined('form.addServiceType') ){
		  servicesTypeAPI = factoryService.getService('servicesTypeAPI');
		      result = servicesTypeAPI.addServiceType( #form.st_name# , #form.st_description#, #form.st_status# );
			if ( result.RETVAL is 1 ){
				factoryService.getService('redirector').redirect('/?page=servicesType');
			}else{
				// --- пробная версия
				if (StructKeyExists(result, 'RETDESC')) {
					instance.message = result['RETDESC'];
				} else {
					instance.message = '';
				}

				if (StructKeyExists(result.STRUCT, 'stName')) {
					instance.stName = result.STRUCT['stName'];
				} else {
					instance.stName = '';
				}
				if (StructKeyExists(result.STRUCT, 'stDescription')) {
					instance.stDescription = result.STRUCT['stDescription'];
				} else {
					instance.stDescription = '';
				}
				if (StructKeyExists(result.STRUCT, 'stStatus')) {
					instance.stStatus = result.STRUCT['stStatus'];
				} else {
					instance.stStatus = '';
				}
			}
		}
		// --- обработчик формы---
	}

	function addServiceTypeForm(){

		param name='form.st_name' default='';
		param name='form.st_description' default='';
		param name='form.st_status' default='1';

		var view = '';
		view &= '
			<form name="" id="" action="#request.CRequest.updateURL(false,"/?page=servicesType&section=serviceType&action=add")#" method="post">
			<div class="grid_8"><div class="signin-box">
				<a class="g-button g-button-submit" href="#request.CRequest.updateURL(false,"/?page=servicesType")#">Назад</a><br><br>
				<h2>Добавление типа услуги</h2>
				<div>
					<label for="st_name"><b>Наименование типа услуги:</b></label> 
					<input type="text" name="st_name" value="#form.st_name#" size = "50" maxlength = "50">';

			if (instance.stName is not ''){
			view &= '		<label for="st_name" class="error" generated="0">#instance.stName#</label>';
			}

			view &= '
				</div>
				<div>
					<label for="st_description"><b>Описание:</b></label>
					<textarea name = "st_description" rows="6" cols="47" >#form.st_description#</textarea>';

			if (instance.stDescription is not ''){
			view &= '		<label for="st_description" class="error" generated="0">#instance.stDescription#</label>';
			}

			view &= '</div>
				<div>
					<label for="st_status"><b>Статус:</b></label> 
					<input type="radio" name="st_status" value="1" #checkedRadio("1", form.st_status)# /> Включена <br>
					<input type="radio" name="st_status" value="0" #checkedRadio("0", form.st_status)#/> Выключена <br>
				</div>';

			if (instance.stStatus is not ''){
			view &= '		<label for="st_status" class="error" generated="0">#instance.stStatus#</label>';
			}

			view &= '
				<div>
					<input disabled class="g-button g-button-submit" type="submit" name="escape" value="Отмена">
					<input class="g-button g-button-submit" type="submit" name="addServiceType" value="Сохранить">
				</div>';

			if (instance.message is not ''){
				view &= '<div id="mes" style="color:red;">#instance.message#</div>';
			}

			view &= '
			</div></div>';

		return view;
	}
	private function updateServiceTypeFormHandler(){
		// --- обработчик формы---
		if ( isdefined('form.updateServiceType') ){
		//writeDump(form);
		  servicesTypeAPI = factoryService.getService('servicesTypeAPI');
		      result = servicesTypeAPI.editeServiceType( #form.st_id#, #form.st_name# , #form.st_description#, #form.st_status# );
			if ( result.RETVAL is 1 ){
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

				if (StructKeyExists(result.STRUCT, 'stName')) {
					instance.stName = result.STRUCT['stName'];
				} else {
					instance.stName = '';
				}
				if (StructKeyExists(result.STRUCT, 'stDescription')) {
					instance.stDescription = result.STRUCT['stDescription'];
				} else {
					instance.stDescription = '';
				}
				if (StructKeyExists(result.STRUCT, 'stStatus')) {
					instance.stStatus = result.STRUCT['stStatus'];
				} else {
					instance.stStatus = '';
				}
			}
		}
		// --- обработчик формы---
	}

	function updateServiceTypeForm( stid ){

		servicesTypeAPI = factoryService.getService( 'servicesTypeAPI' );
		qServiceType = servicesTypeAPI.getServiceType( arguments.stid );
		var view = '';

		param name='form.st_id' default='#qServiceType.st_id#';
		param name='form.st_name' default='#qServiceType.st_name#';
		param name='form.st_description' default='#qServiceType.st_description#';
		param name='form.st_status' default='#qServiceType.st_status#';

		var view = '';
		view &= '
			<form name="" id="" action="#request.CRequest.updateURL(false,"/?page=servicesType&section=serviceType&action=edite&stid=#arguments.stid#")#" method="post">
			<div class="grid_8"><div class="signin-box">
				<a class="g-button g-button-submit" href="#request.CRequest.updateURL(false,"/?page=servicesType")#">Назад</a><br><br>
				<h2>Редактирование типа услуги</h2>
				<div>
					<label for="st_id"><b>ID типа услуги:</b></label>
					<input disabled type="text" name="_st_id" value="#form.st_id#" size = "2" maxlength = "2">
					<input type="hidden" name="st_id" value="#form.st_id#" size = "2" maxlength = "2">
				</div>
				<div>
					<label for="st_name"><b>Наименование типа услуги:</b></label> 
					<input type="text" name="st_name" value="#form.st_name#" size = "50" maxlength = "50">';

			if (instance.stName is not ''){
			view &= '		<label for="st_name" class="error" generated="0">#instance.stName#</label>';
			}

			view &= '
				</div>
				<div>
					<label for="st_description"><b>Описание:</b></label>
					<textarea name = "st_description" rows="6" cols="47" >#form.st_description#</textarea>';
			if (instance.stDescription is not ''){
			view &= '		<label for="st_description" class="error" generated="0">#instance.stDescription#</label>';
			}

			view &= '</div>
				<div>
					<label for="st_status"><b>Статус:</b></label> 
					<input type="radio" name="st_status" value="1" #checkedRadio("1", form.st_status)# /> Включена <br>
					<input type="radio" name="st_status" value="0" #checkedRadio("0", form.st_status)#/> Выключена <br>
				';

			if (instance.stStatus is not ''){
			view &= '		<label for="st_status" class="error" generated="0">#instance.stStatus#</label>';
			}

			view &= '</div>
				<div>
					<input disabled class="g-button g-button-submit" type="submit" name="escape" value="Отмена">
					<input class="g-button g-button-submit" type="submit" name="updateServiceType" value="Сохранить">
				</div>';

			if (instance.message is not ''){
				view &= '<div id="mes" style="color:red;">#instance.message#</div>';
			}

			view &= '
			</div></div>';
		return view;
	}

	function servicesTypeListForm(){
		servicesTypeList = factoryService.getService('servicesTypeAPI').getServicesTypeList();
		var view = '';
		view &= '<div class="grid_16"><div class="signin-box"><h2>Список услуг:</h2>';
			view &= '<table width="100%">
						<tr style="color:grey;">
						<td>ID</td> 
						<td>Наименование</td>
						<td>Описание</td>
						<td>Статус</td>
						<td> --- </td>
						</tr>';
			for (var x=1; x<=servicesTypeList.recordcount; x++){
						var class = IIF(x MOD 2, DE('tr_hover'), DE('tr_hover1'));
						view &= '<tr class="block #class#">
						<td>#servicesTypeList.st_id[x]#</td> 
						<td>#servicesTypeList.st_name[x]#</td>
						<td>#servicesTypeList.st_description[x]#</td>
						<td>#servicesTypeList.st_status[x]#</td>
						<td nowrap><a href="/?page=servicesType&section=serviceType&action=edite&stid=#servicesTypeList.st_id[x]#">Редактировать</a> | 
							<a href="/?page=servicesType&section=serviceType&action=delete&stid=#servicesTypeList.st_id[x]#">Удалить</a></td>
						</tr>';
			}
			view &= '<tr><td style="text-align:left;" colspan="5"><a href="/?page=servicesType&section=serviceType&action=add"><br>+Добавить тип услуги</a></td></tr>';

			view &= '</table>';
		view &= '</div></div>';

		return view;
	}

	function View() {
		return instance.view;
  	}

}