/* 
	Виджет список услуг --
*/

component attributeName='servicelist' output='false'{
	// псевдо конструктор
	factoryService = request.factoryService;

	instance.view = '';
	instance.plsName = '';
	instance.plsDescription = '';
	instance.plsPriceOt = '';
	instance.plsPriceDo = '';
	instance.plsCost = '';
	instance.emptID = '';
	instance.stID = '';
	instance.plsStatus = '';
	instance.plsTime = '';
	instance.plsShablon = '';
	instance.message = '';
	instance.RBAC = '';

	function Init(string section, string action) {
		section = arguments.section;
		action = arguments.action;

		if (section == 'false'){
			sortBy = request.CRequest.getUrl('sortBy');
			servicesListFormHandler();
			instance.view = servicesListForm(sortby);

		}else if( section == 'service' ){
			if( action == 'add' ){
				addServiceFormHandler();
				instance.view = addServiceForm();

			}else if( action == 'edite' ){
				plsid = request.CRequest.getUrl('plsid');
				updateServiceFormHandler(); 
				instance.view = updateServiceForm(plsid);

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
	private function addServiceFormHandler(){
		// --- обработчик формы---
		if ( isdefined('form.addService') ){
		  if ( !isDefined('form.empt_id') ){
			form.empt_id = '';
		  }
		  if ( !isDefined('form.st_id') ){
			form.st_id = '';
		  }
		  servicesAPI = factoryService.getService('servicesAPI');
		      result = servicesAPI.addService( #form.pls_name# , #form.pls_description#, #form.pls_shablon#, #form.pls_price_ot#, #form.pls_price_do#, #form.pls_cost#, #form.empt_id#, #form.st_id#, #form.pls_status#, #form.pls_time# );
			if ( result.RETVAL is 1 ){
				factoryService.getService('redirector').redirect('/?page=services');
			}else{
				// --- пробная версия
				if (StructKeyExists(result, 'RETDESC')) {
					instance.message = result['RETDESC'];
				} else {
					instance.message = '';
				}

				if (StructKeyExists(result.STRUCT, 'plsName')) {
					instance.plsName = result.STRUCT['plsName'];
				} else {
					instance.plsName = '';
				}
				if (StructKeyExists(result.STRUCT, 'plsDescription')) {
					instance.plsDescription = result.STRUCT['plsDescription'];
				} else {
					instance.plsDescription = '';
				}
				if (StructKeyExists(result.STRUCT, 'plsShablon')) {
					instance.plsShablon = result.STRUCT['plsShablon'];
				} else {
					instance.plsShablon = '';
				}
				if (StructKeyExists(result.STRUCT, 'plsPriceOt')) {
					instance.plsPriceOt = result.STRUCT['plsPriceOt'];
				} else {
					instance.plsPriceOt = '';
				}
				if (StructKeyExists(result.STRUCT, 'plsPriceDo')) {
					instance.plsPriceDo = result.STRUCT['plsPriceDo'];
				} else {
					instance.plsPriceDo = '';
				}
				if (StructKeyExists(result.STRUCT, 'plsCost')) {
					instance.plsCost = result.STRUCT['plsCost'];
				} else {
					instance.plsCost = '';
				}
				if (StructKeyExists(result.STRUCT, 'emptID')) {
					instance.emptID = result.STRUCT['emptID'];
				} else {
					instance.emptID = '';
				}
				if (StructKeyExists(result.STRUCT, 'stID')) {
					instance.stID = result.STRUCT['stID'];
				} else {
					instance.stID = '';
				}
				if (StructKeyExists(result.STRUCT, 'plsStatus')) {
					instance.plsStatus = result.STRUCT['plsStatus'];
				} else {
					instance.plsStatus = '';
				}
				if (StructKeyExists(result.STRUCT, 'plsTime')) {
					instance.plsTime = result.STRUCT['plsTime'];
				} else {
					instance.plsTime = '';
				}
				if (StructKeyExists(result.STRUCT, 'RBAC')) {
					instance.RBAC = result.STRUCT['RBAC'];
				} else {
					instance.RBAC = '';
				}

			}
		}
		// --- обработчик формы---
	}

	function addServiceForm(){

		param name='form.pls_name' default='';
		param name='form.pls_description' default='';
		param name='form.pls_shablon' default='';
		param name='form.pls_price_ot' default='';
		param name='form.pls_price_do' default='';
		param name='form.pls_cost' default='0';
		param name='form.empt_id' default='';
		param name='form.st_id' default='';
		param name='form.pls_status' default='1';
		param name='form.pls_time' default='5';

		var view = '';
		view &= '
			<form name="" id="" action="#request.CRequest.updateURL(false,"/?page=services&section=service&action=add")#" method="post">
			<div class="grid_8"><div class="signin-box">
				<a class="g-button g-button-submit" href="#request.CRequest.updateURL(false,"/?page=services")#">Назад</a><br><br>
				<h2>Добавление услуги</h2>
				<div>
					<label for="pls_name"><b>Наименование услуги:</b></label> 
					<input type="text" name="pls_name" value="#form.pls_name#" size = "50" maxlength = "250">';

			if (instance.plsName is not ''){
			view &= '		<label for="pls_name" class="error" generated="0">#instance.plsName#</label>';
			}

			view &= '
				</div>
				<div>
					<label for="pls_description"><b>Описание:</b></label>
					<textarea name = "pls_description" rows="6" cols="47" >#form.pls_description#</textarea>';

			if (instance.plsDescription is not ''){
			view &= '		<label for="pls_description" class="error" generated="0">#instance.plsDescription#</label>';
			}

			view &= '
				</div>
				<div>
					<label for="pls_shablon"><b>Шаблон:</b></label>
					<textarea name = "pls_shablon" rows="6" cols="47" >#form.pls_shablon#</textarea>';

			if (instance.plsShablon is not ''){
			view &= '		<label for="pls_shablon" class="error" generated="0">#instance.plsShablon#</label>';
			}

			view &= '
				</div>
				<div>
					<label for="pls_price_ot"><b>Цена услуги от:</b></label>
					<input type="text" name="pls_price_ot" value="#form.pls_price_ot#" size="10" maxlength="10"/>';

			if (instance.plsPriceOt is not ''){
			view &= '		<label for="pls_price_ot" class="error" generated="0">#instance.plsPriceOt#</label>';
			}

			view &= '
				</div>
				<div>
					<label for="pls_price_do"><b>Цена услуги до:</b></label>
					<input type="text" name="pls_price_do" value="#form.pls_price_do#" size="10" maxlength="10"/>';

			if (instance.plsPriceDo is not ''){
			view &= '		<label for="pls_price_do" class="error" generated="0">#instance.plsPriceDo#</label>';
			}

			view &= '
				</div>
				<div>
					<label for="pls_cost"><b>Себестоимость услуги:</b></label>
					<input type="text" name="pls_cost" value="#form.pls_cost#" size="10" maxlength="10"/>';

			if (instance.plsCost is not ''){
			view &= '		<label for="pls_cost" class="error" generated="0">#instance.plsCost#</label>';
			}

			view &= '
				</div>
				<div>
					<label for="pls_time"><b>Требуемое время:</b></label>
					<input type="text" name="pls_time" value="#form.pls_time#" size="10" maxlength="10"/>';

			if (instance.plsTime is not ''){
			view &= '		<label for="pls_time" class="error" generated="0">#instance.plsTime#</label>';
			}

			view &= '
				</div>
				<div>
					<label for="empt_id"><b>Тип служащего:</b></label>';

				employeesList = factoryService.getService('employeesAPI').getEmployeesList();
				for (var x=1; x<=employeesList.recordcount; x++){
					view &= '
						<input type="radio" name="empt_id" value="#employeesList.empt_id[x]#" #checkedRadio("#employeesList.empt_id[x]#", form.empt_id)#/> #employeesList.empt_name[x]# <br>';
                		}
			if (instance.emptID is not ''){
			view &= '		<label for="empt_id" class="error" generated="0">#instance.emptID#</label>';
			}

			view &= '
				</div>
				<div>
					<label for="st_id"><b>Тип услуги:</b></label>';

				servicesTypeList = factoryService.getService('servicesTypeAPI').getServicesTypeList();
				for (var x=1; x<=servicesTypeList.recordcount; x++){
					view &= '
						<input type="radio" name="st_id" value="#servicesTypeList.st_id[x]#" #checkedRadio("#servicesTypeList.st_id[x]#", form.st_id)#/> #servicesTypeList.st_name[x]# <br>';
                		}
			if (instance.stID is not ''){
			view &= '		<label for="st_id" class="error" generated="0">#instance.stID#</label>';
			}

			view &= '</div>
				<div>
					<label for="pls_status"><b>Статус:</b></label> 
					<input type="radio" name="pls_status" value="1" #checkedRadio("1", form.pls_status)# /> Включена <br>
					<input type="radio" name="pls_status" value="0" #checkedRadio("0", form.pls_status)#/> Выключена <br>
				</div>';

			if (instance.plsStatus is not ''){
			view &= '		<label for="pls_status" class="error" generated="0">#instance.plsStatus#</label>';
			}

			view &= '
				<div>
					<input disabled class="g-button g-button-submit" type="submit" name="escape" value="Отмена">
					<input class="g-button g-button-submit" type="submit" name="addService" value="Сохранить">
				</div>';

			if (instance.message is not ''){
				view &= '<div id="mes" style="color:red;">#instance.message#</div>';
			}
			if (instance.RBAC is not ''){
				view &= '<div id="RBAC" style="color:red;">#instance.RBAC#</div>';
			}

			view &= '
			</div></div>';

		return view;
	}

	private function updateServiceFormHandler(){
		// --- обработчик формы---
		if ( isdefined('form.updateService') ){
		  if ( !isDefined('form.empt_id') ){
			form.empt_id = '';
		  }
		//writeDump(form);
		  servicesAPI = factoryService.getService('servicesAPI');
		      result = servicesAPI.editeService( #form.pls_id#, #form.pls_name# , #form.pls_description#, #form.pls_shablon#, #form.pls_price_ot#, #form.pls_price_do#, #form.pls_cost#, #form.empt_id#, #form.st_id#, #form.pls_status#, #form.pls_time# );
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

				if (StructKeyExists(result.STRUCT, 'plsName')) {
					instance.plsName = result.STRUCT['plsName'];
				} else {
					instance.plsName = '';
				}
				if (StructKeyExists(result.STRUCT, 'plsDescription')) {
					instance.plsDescription = result.STRUCT['plsDescription'];
				} else {
					instance.plsDescription = '';
				}
				if (StructKeyExists(result.STRUCT, 'plsShablon')) {
					instance.plsShablon = result.STRUCT['plsShablon'];
				} else {
					instance.plsShablon = '';
				}
				if (StructKeyExists(result.STRUCT, 'plsPriceOt')) {
					instance.plsPriceOt = result.STRUCT['plsPriceOt'];
				} else {
					instance.plsPriceOt = '';
				}
				if (StructKeyExists(result.STRUCT, 'plsPriceDo')) {
					instance.plsPriceDo = result.STRUCT['plsPriceDo'];
				} else {
					instance.plsPriceDo = '';
				}
				if (StructKeyExists(result.STRUCT, 'plsCost')) {
					instance.plsCost = result.STRUCT['plsCost'];
				} else {
					instance.plsCost = '';
				}
				if (StructKeyExists(result.STRUCT, 'emptID')) {
					instance.emptID = result.STRUCT['emptID'];
				} else {
					instance.emptID = '';
				}
				if (StructKeyExists(result.STRUCT, 'stID')) {
					instance.stID = result.STRUCT['stID'];
				} else {
					instance.stID = '';
				}
				if (StructKeyExists(result.STRUCT, 'plsStatus')) {
					instance.plsStatus = result.STRUCT['plsStatus'];
				} else {
					instance.plsStatus = '';
				}
				if (StructKeyExists(result.STRUCT, 'plsTime')) {
					instance.plsTime = result.STRUCT['plsTime'];
				} else {
					instance.plsTime = '';
				}
				if (StructKeyExists(result.STRUCT, 'RBAC')) {
					instance.RBAC = result.STRUCT['RBAC'];
				} else {
					instance.RBAC = '';
				}

			}
		}
		// --- обработчик формы---
	}

	function updateServiceForm( plsid ){

		servicesAPI = factoryService.getService( 'servicesAPI' );
		qService = servicesAPI.getService( arguments.plsid );

		param name='form.pls_id' default='#qService.pls_id#';
		param name='form.pls_name' default='#qService.pls_name#';
		param name='form.pls_description' default='#qService.pls_description#';
		param name='form.pls_price_ot' default='#qService.pls_price_ot#';
		param name='form.pls_price_do' default='#qService.pls_price_do#';
		param name='form.pls_cost' default='#qService.pls_cost#';
		param name='form.empt_id' default='#qService.empt_id#';
		param name='form.st_id' default='#qService.st_id#';
		param name='form.pls_status' default='#qService.pls_status#';
		param name='form.pls_time' default='#qService.pls_time#';
		param name='form.pls_shablon' default='#qService.pls_shablon#';

		var view = '';
		view &= '
			<form name="" id="" action="#request.CRequest.updateURL(false,"/?page=services&section=service&action=edite&plsid=#arguments.plsid#")#" method="post">
			<div class="grid_8"><div class="signin-box">
				<a class="g-button g-button-submit" href="#request.CRequest.updateURL(false,"/?page=services")#">Назад</a><br><br>
				<h2>Редактирование услуги</h2>
				<div>
					<label for="pls_id"><b>ID услуги:</b></label>
					<input disabled type="text" name="_pls_id" value="#form.pls_id#" size = "2" maxlength = "2">
					<input type="hidden" name="pls_id" value="#form.pls_id#" size = "2" maxlength = "2">
				</div>
				<div>
					<label for="pls_name"><b>Наименование услуги:</b></label> 
					<input type="text" name="pls_name" value="#form.pls_name#" size = "50" maxlength = "250">';

			if (instance.plsName is not ''){
			view &= '		<label for="pls_name" class="error" generated="0">#instance.plsName#</label>';
			}

			view &= '
				</div>
				<div>
					<label for="pls_description"><b>Описание:</b></label>
					<textarea name = "pls_description" rows="6" cols="47" >#form.pls_description#</textarea>';
			if (instance.plsDescription is not ''){
			view &= '		<label for="pls_description" class="error" generated="0">#instance.plsDescription#</label>';
			}

			view &= '
				</div>
				<div>
					<label for="pls_shablon"><b>Шаблон:</b></label>
					<textarea name = "pls_shablon" rows="6" cols="47" >#form.pls_shablon#</textarea>';
			if (instance.plsShablon is not ''){
			view &= '		<label for="pls_shablon" class="error" generated="0">#instance.plsShablon#</label>';
			}

			view &= '
				</div>
				<div>
					<label for="pls_price_ot"><b>Цена услуги от:</b></label>
					<input type="text" name="pls_price_ot" value="#form.pls_price_ot#" size="10" maxlength="10"/>';

			if (instance.plsPriceOt is not ''){
			view &= '		<label for="pls_price_ot" class="error" generated="0">#instance.plsPriceOt#</label>';
			}

			view &= '
				</div>
				<div>
					<label for="pls_price_do"><b>Цена услуги до:</b></label>
					<input type="text" name="pls_price_do" value="#form.pls_price_do#" size="10" maxlength="10"/>';

			if (instance.plsPriceDo is not ''){
			view &= '		<label for="pls_price_do" class="error" generated="0">#instance.plsPriceDo#</label>';
			}

			view &= '
				</div>
				<div>
					<label for="pls_cost"><b>Себестоимость услуги:</b></label>
					<input type="text" name="pls_cost" value="#form.pls_cost#" size="10" maxlength="10"/>';

			if (instance.plsCost is not ''){
			view &= '		<label for="pls_cost" class="error" generated="0">#instance.plsCost#</label>';
			}

			view &= '
				</div>
				<div>
					<label for="pls_time"><b>Требуемое время:</b></label>
					<input type="text" name="pls_time" value="#form.pls_time#" size="10" maxlength="10"/>';

			if (instance.plsTime is not ''){
			view &= '		<label for="pls_time" class="error" generated="0">#instance.plsTime#</label>';
			}

			view &= '
				</div>
				<div>
					<label for="empt_id"><b>Тип служащего:</b></label>';

				employeesList = factoryService.getService('employeesAPI').getEmployeesList();
				for (var x=1; x<=employeesList.recordcount; x++){
					view &= '
						<input type="radio" name="empt_id" value="#employeesList.empt_id[x]#" #checkedRadio("#employeesList.empt_id[x]#", form.empt_id)#/> #employeesList.empt_name[x]# <br>';
                		}
			if (instance.emptID is not ''){
			view &= '		<label for="empt_id" class="error" generated="0">#instance.emptID#</label>';
			}

			view &= '
				</div>
				<div>
					<label for="st_id"><b>Тип услуги:</b></label>';

				servicesTypeList = factoryService.getService('servicesTypeAPI').getServicesTypeList();
				for (var x=1; x<=servicesTypeList.recordcount; x++){
					view &= '
						<input type="radio" name="st_id" value="#servicesTypeList.st_id[x]#" #checkedRadio("#servicesTypeList.st_id[x]#", form.st_id)#/> #servicesTypeList.st_name[x]# <br>';
                		}
			if (instance.stID is not ''){
			view &= '		<label for="st_id" class="error" generated="0">#instance.stID#</label>';
			}

			view &= '</div>
				<div>
					<label for="pls_status"><b>Статус:</b></label> 
					<input type="radio" name="pls_status" value="1" #checkedRadio("1", form.pls_status)# /> Включена <br>
					<input type="radio" name="pls_status" value="0" #checkedRadio("0", form.pls_status)#/> Выключена <br>
				';

			if (instance.plsStatus is not ''){
			view &= '		<label for="pls_status" class="error" generated="0">#instance.plsStatus#</label>';
			}

			view &= '</div>
				<div>
					<input disabled class="g-button g-button-submit" type="submit" name="escape" value="Отмена">
					<input class="g-button g-button-submit" type="submit" name="updateService" value="Сохранить">
				</div>';

			if (instance.message is not ''){
				view &= '<div id="mes" style="color:red;">#instance.message#</div>';
			}
			if (instance.RBAC is not ''){
				view &= '<div id="RBAC" style="color:red;">#instance.RBAC#</div>';
			}

			view &= '
			</div></div>';
		return view;
	}

	function servicesListFormHandler(){
		//
		if ( isdefined('form.SORT') ){
			client.emptID = form.emptID;
			client.stID = form.stID;
		}
	}

	function servicesListForm(sortBy){

		// сюда нужно поместить сортировки из клиентских переменных и может быть форму
		// если будет форма, тогда нужно сделать обработчик
		//sortBy = client['sortby'];
		sortBy = arguments.sortBy;
		emptID = client.emptID;
		stID = client.stID;

		servicesTypeList = factoryService.getService('servicesTypeAPI').getServicesTypeList();
		//writeDump(servicesTypeList);
		employeesList = factoryService.getService('employeesAPI').getEmployeesList();
		//employeesList.sort(employeesList.findColumn("empt_id"),TRUE);
		//writeDump(employeesList);
		//writeDump(client);

		// создать обработчик есть ли такая клиентская переменная если нет то назначить, если есть то
		// использовать ее

		servicesList = factoryService.getService('servicesAPI').getServicesList(sortBy,emptID,stID);
		//writeDump(servicesList);
		var view = '';
		view &= '<div class="grid_16"><div class="signin-box"><h2>Список услуг:</h2>';
			view &= '<table class="td_head" width="100%">
						<tr><td style="text-align:right;" colspan="11"><a class="g-button g-button-submit" href="/?page=services&section=service&action=add">+Добавить услугу</a></td></tr>
						<tr><td style="text-align:left;" colspan="11">
							<form name="" action="#request.CRequest.updateURL(false,"/?page=services")#" method="post">
								Тип служащего: <select name="emptID" сlass="select">
									<option value="all" #iif( emptID is "all", DE("selected"), DE(""))#>Все</option>';
									for (var x=1; x<=employeesList.recordcount; x++){
										if (employeesList.empt_parent[x] == 4){
											view &= '<option value="#employeesList.empt_id[x]#" #iif( employeesList.empt_id[x] is emptID, DE("selected"), DE(""))#>#employeesList.empt_name[x]#</option>';
										}
									}

							view &= '</select>
								&nbsp;&nbsp;Тип услуги: <select name="stID" сlass="select">
									<option value="all" #iif( stID is "all", DE("selected"), DE(""))#>Все</option>';
									for (var x=1; x<=servicesTypeList.recordcount; x++){
										view &= '<option value="#servicesTypeList.st_id[x]#" #iif( servicesTypeList.st_id[x] is stID, DE("selected"), DE(""))#>#servicesTypeList.st_name[x]#</option>';
									}
							view &= '</select>
								<input class="g-button g-button-submit" type="submit" name="SORT" value="Применить">
							</form>
						</td></tr>

						<tr>
						<th><a href="#request.CRequest.updateURL(false,"/?page=services&sortby=id")#">id</a></th>
						<th>Наименование</th>
						<th title="Описание">-</th>
						<th>Цена</th>
						<th title="Себестоимость">-</th>
						<th>Тип служащего</th>
						<th>Тип услуги</th>
						<th title="Шаблон">-</th>
						<th title="Статус услуги">Ст</th>
						<th title="Требуемое время">ТВ</th>
						<th> --- </th>
						</tr>';

			for (var x=1; x<=servicesList.recordcount; x++){
						if (servicesList.pls_description[x] != ''){
							desc = '<img src="img/noutbook.gif" class="tooltip" title="#servicesList.pls_description[x]#">';
						}else{
							desc = '-';
						}
						if (servicesList.pls_shablon[x] != ''){
							shablon = '<img src="img/checkmark.png">';
						}else{
							shablon = '-';
						}
						var class = IIF(x MOD 2, DE('tr_hover'), DE('tr_hover1'));
						view &= '<tr class="#class#">
						<td>#servicesList.pls_id[x]#&nbsp;</td> 
						<td style="text-align:left;">#servicesList.pls_name[x]#</td>
						<td>#desc#</td>
						<td nowrap>';

						if ( servicesList.pls_price_do[x] == '' ){
							view &= '#LSCurrencyFormat(servicesList.pls_price_ot[x])#';
						}else{
							view &= 'от #LSCurrencyFormat(servicesList.pls_price_ot[x])# - до #LSCurrencyFormat(servicesList.pls_price_do[x])#';
						}

						view &= '</td>
						<td nowrap>#LSCurrencyFormat(servicesList.pls_cost[x])#</td>
						<td nowrap>#servicesList.empt_name[x]#</td>
						<td>#servicesList.st_name[x]#</td>
						<td>#shablon#</td>
						<td>#IIF(servicesList.pls_status[x] is 0, DE('<font color="red">выкл</font>'), DE('<font color="green">вкл</font>'))#</td>
						<td>#servicesList.pls_time[x]#</td> 
						<td nowrap><a href="/?page=services&section=service&action=edite&plsid=#servicesList.pls_id[x]#">Ред.</a> | 
							<a href="/?page=services&section=service&action=delete&plsid=#servicesList.pls_id[x]#">Удл.</a></td>
						</tr>';
			}
			view &= '<tr><td style="text-align:right;" colspan="11"><a class="g-button g-button-submit" href="/?page=services&section=service&action=add">+Добавить услугу</a></td></tr>';

			view &= '</tbody></table>';
		view &= '</div></div>';

		return view;
	}

	function View() {
		return instance.view;
  	}

}