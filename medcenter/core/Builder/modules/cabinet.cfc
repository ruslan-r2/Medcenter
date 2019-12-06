/* 
	Виджет текущий график врачей + запись пациентов --
*/

component attributeName='usersGraphicsReception' output='false'{
	// псевдо конструктор
	factoryService = request.factoryService;

	instance.user = session.sessionStorage.getObject('user'); // сесионный Объект

	instance.view = '';

	instance.userID = '';
	instance.rpStartTime ='';
	instance._rpStartTime ='';
	instance.rpEndTime ='';
	instance._rpEndTime ='';
	instance.Time ='';
	instance.rpDescription ='';
	instance.rpStatus ='';
	instance.plsID ='';

	instance.RBAC = '';

	instance.message = '';

	instance.svPrice = '';
	instance.svStatus = '';


	function Init(string section, string action) {
		section = arguments.section;
		action = arguments.action;


		//if (section == 'false'){
			//Date = request.CRequest.getUrl('date');
			//instance.view = usersGraphicsReceptionListForm(date);

		if( section == 'false' ){

			userid = instance.user.getUserId();
			Date = request.CRequest.getUrl('date');
			instance.view = userGraphicsReceptionListForm(userid,Date);

		}else if( section == 'reception'){
			if( action == 'view' ){
				rpid = request.CRequest.getUrl('rpid');
				viewReceptionFormHandler();
				instance.view = viewReceptionForm(rpid);

			}else if( action == 'edite' ){
				rpid = request.CRequest.getUrl('rpid');
				editeUserReceptionFormHandler();
				instance.view = editeUserReceptionForm(rpid);

			}else if( action == 'add'){
				userid = instance.user.getUserId();
				date = request.CRequest.getUrl('date');
				starttime = request.CRequest.getUrl('starttime');
				endtime = request.CRequest.getUrl('endtime');
				addUserReceptionFormHandler(userid);
				instance.view = addUserReceptionForm(userid,date,starttime,endtime);

			}else if( action == 'addPatient' ){
				rpid = request.CRequest.getUrl('rpid');
				addPatientFormHandler(); 
				instance.view = addPatientForm(rpID);

			}else if( action == 'editeDocumentService' ){
				rpid = request.CRequest.getUrl('rpid');
				svid = request.CRequest.getUrl('svid');
				editeDocumentServiceHandler(rpid,svid);
				instance.view = editeDocumentService(rpid,svid);

			}else if( action == 'delete'){
				//instance.view = 'delete group';
			}

		}else if(section == 'service'){
			//
			if( action == 'edite' ){
				svid = request.CRequest.getUrl('svid');
				editeReceptionServiceHandler(svid);
				instance.view = editeReceptionService(svid);
			}

		}else if(section == 'document'){
			svid = request.CRequest.getUrl('svid');
			instance.view = document(svid);

		}else if (section == 'document1'){
			svid = request.CRequest.getUrl('svid');
			instance.view = document1(svid);
		}

		return this;

	}

	function checkedSelect( value, status ){
		if (arguments.value == arguments.status){
			return 'selected';
		}else{
			return '';
		}
	}

	private function addPatientFormHandler(){

		if ( isdefined('form.search') ){
			var qSearch = factoryService.getService('patientsAPI').searchPatients(form.emp_family);
			patientsList = qSearch;
			//writeDump(qSearch);
			//
		}

		if( isdefined('form.addPt') ){
			var userReception = factoryService.getService('userReceptionAPI');
			result = userReception.editeUserReception(form.rp_id, form.pt_id);
				//result.RETVAL = 1;
				if ( result.RETVAL is 1 ){
					// сюда нужно вернуть rp_id и перенаправить на форму редактирования
					// где можно будет добавлять услуги и пациента !!!!!!!!!!!!!!!!!
					factoryService.getService('redirector').redirect('#request.CRequest.updateURL(false,"/?page=cabinet&section=reception&action=view&rpid=#form.rp_id#")#');

				}else{
					// --- пробная версия
					if ( result.RETDESC is '') {
						instance.message = '';
					} else {
						instance.message = '#result.RETDESC#';
					}

					if (StructKeyExists(result.STRUCT, 'rpID')) {
						instance.rpID = result.STRUCT['rpID'];
					} else {
						instance.rpID = '';
					}
					if (StructKeyExists(result.STRUCT, 'ptID')) {
						instance.ptID = result.STRUCT['ptID'];
					} else {
						instance.ptID = '';
					}
					if (StructKeyExists(result.STRUCT, 'rpStatus')) {
						instance.rpStatus = result.STRUCT['rpStatus'];
					} else {
						instance.rpStatus = '';
					}
				}
			// --- обработчик формы---
		}
	}

	private function addPatientForm( rpID ){

		param name='form.emp_family' default='';
		rpID = arguments.rpID;

		var view = '';
		view &= '
			<form name="" action="#request.CRequest.updateURL(false,"/?page=cabinet&section=reception&action=addPatient&rpid=#rpID#")#" method="post">
				<div class="grid_16"><div class="signin-box"><h2>Пациенты:</h2>
				Фамилия: <input type="text" name="emp_family" value="#form.emp_family#" size="20" maxlength="20">
				<input class="g-button g-button-submit" type="submit" name="Search" value="Найти">
			</form>';

		view &= '<table width="100%">
				<tr style="color:grey;">
					<td>id</td> 
					<td>Ф.И.О</td>
					<td>Пол</td>
					<td>Дата рождения</td>
					<td> Контакты </td>
					<td> --- </td>
				</tr>';
				if ( isDefined('patientsList') ){

				  if ( patientsList.recordcount ){

				    for (var x=1; x<=patientsList.recordcount; x++){
					factoryService.getService('patientsAPI').setPatientContacts(patientsList.pt_id[x]);
					patient_cnt = factoryService.getService('patientsAPI').getPatientContacts();
					view &= '
					<form name="" action="#request.CRequest.updateURL(false,"/?page=cabinet&section=reception&action=addPatient&rpid=#rpID#")#" method="post">
					<tr class="block">
						<td>#patientsList.pt_id[x]#</td>
						<td style="text-align:left;">
							#patientsList.pt_family[x]# #patientsList.pt_firstname[x]# #patientsList.pt_lastname[x]# 
							<a href="/?page=patients&section=patient&action=view&patientid=#patientsList.pt_id[x]#" title="Перейти в картотеку"><img src="img/users.png" border="0"></a>
						</td>
						<td>#patientsList.pt_gender[x]#</td>
						<td>#_DateFormate(patientsList.pt_dob[x])#</td>
						<td>';
						for(var y=1; y<=patient_cnt.recordcount; y++){
							view&= '#patient_cnt.ptc_data[y]#&nbsp;';
						}
						view &='</td>
						<td><input class="g-button g-button-submit" type="submit" name="addPt" value="Добавить">
						<input type="hidden" name="pt_id" value="#patientsList.pt_id[x]#" size="20" maxlength="20">
						<input type="hidden" name="rp_id" value="#rpID#" size="20" maxlength="20"></td>
					</tr>
					</form>';
				    }

				  }else{
					view &= '<tr class="block1">
							<td colspan="6">Ничего не нашёл! #now()#</td>
						</tr>';
				  }

				}

			view &= '<tr><td style="text-align:left;" colspan="6"><a href="/?page=patients&section=patient&action=add"><br>+Добавить пациента</a></td></tr>';

			view &= '</table>';

			if (instance.rpStatus is not ''){
				view &= '
					<div id="rpStatus" style="color:red;"> <a class="g-button g-button-submit" href="#request.CRequest.updateURL(false,"/?page=cabinet&section=reception&action=view&rpid=#form.rp_id#")#">Назад</a> #instance.rpStatus#</div>';
			}

		view &= '</div></div>';

		return view;
	}

	private function viewReceptionFormHandler(){

		if ( isdefined('form.addService') ){

		  if (form.plsID is not ''){

			var qReception = factoryService.getService('userReceptionAPI').getReception(form.rp_id);
			var qUser = factoryService.getService( 'authorization' ).getUser( qReception.user_id );
			var qService = factoryService.getService('servicesAPI').getService(form.plsID);
			usersInterest = factoryService.getService('usersInterestAPI');
			UI = usersInterest.getUserInterest( qUser.user_id, qService.st_id );
			if ( UI.recordcount ){
				if ( UI.ui_type == 1 ){
					userInterest = round(qService.pls_price_ot/100 * UI.ui_value);
				}else if( UI.ui_type == 0 ){
					userInterest = UI.ui_value;
				}
			}else{
				userInterest = 0;
			}
			//
			var userServices = factoryService.getService('userServicesAPI');
			result = userServices.addReceptionService( #form.rp_id#, #form.plsID#, #qService.pls_price_ot#, #qService.pls_cost#, #qService.pls_name#, #qService.pls_time#, #qService.pls_description#, 1, #qService.st_id#, #qService.pls_shablon#, userInterest );
		  }else{
			result.RETVAL = 0;
			result.RETDESC = "";
			result.STRUCT = structNew(); // для валидации полей
			structInsert(result.struct, 'plsID','Вы не указали услугу, выберите услугу!!!');
		  }
			if ( result.RETVAL is 1 ){
				factoryService.getService('redirector').redirect('#request.CRequest.updateURL(false,"/?page=cabinet&section=reception&action=view&rpid=#form.rp_id#")#');
			}else{
				if ( result.RETDESC is '') {
					instance.message = '';
				} else {
					instance.message = '#result.RETDESC#';
				}
				if (StructKeyExists(result.STRUCT, 'plsID')) {
					instance.plsID = result.STRUCT['plsID'];
				} else {
					instance.plsID = '';
				}
				if (StructKeyExists(result.STRUCT, 'rpStatus')) {
					instance.rpStatus = result.STRUCT['rpStatus'];
				} else {
					instance.rpStatus = '';
				}
				if (StructKeyExists(result.STRUCT, 'RBAC')) {
					instance.RBAC = result.STRUCT['RBAC'];
				} else {
					instance.RBAC = '';
				}
			}
		}

		if ( isdefined('form.deleteService') ){
			var userServices = factoryService.getService('userServicesAPI');
			  result = userServices.deleteReceptionService( #form.rp_id#, #form.sv_id# );

			if ( result.RETVAL is 1 ){
				factoryService.getService('redirector').redirect('#request.CRequest.updateURL(false,"/?page=cabinet&section=reception&action=view&rpid=#form.rp_id#")#');
			}else{
				if ( result.RETDESC is '') {
					instance.message = '';
				} else {
					instance.message = '#result.RETDESC#';
				}
				if (StructKeyExists(result.STRUCT, 'rpStatus')) {
					instance.rpStatus = result.STRUCT['rpStatus'];
				} else {
					instance.rpStatus = '';
				}
				if (StructKeyExists(result.STRUCT, 'RBAC')) {
					instance.RBAC = result.STRUCT['RBAC'];
				} else {
					instance.RBAC = '';
				}
			}
		}

		if ( isdefined('form.deleteReception') ){
			var userReception = factoryService.getService('userReceptionAPI');
			result = userReception.deleteUserReception( #form.rp_id# );
			if ( result.RETVAL is 1 ){
				factoryService.getService('redirector').redirect('#request.CRequest.updateURL(false,"/?page=cabinet")#');

			}else{
				if ( result.RETDESC is '') {
					instance.message = '';
				} else {
					instance.message = '#result.RETDESC#';
				}
				if (StructKeyExists(result.STRUCT, 'RBAC')) {
					instance.RBAC = result.STRUCT['RBAC'];
				} else {
					instance.RBAC = '';
				}

			}
		}

		if ( isdefined('form.startReception') ){
			var userReception = factoryService.getService('userReceptionAPI');
			result = userReception.startEndUserReception( #form.rp_id#, 2, #form.user_id1#, #form.user_id2# );
			if ( result.RETVAL is 1 ){
				//factoryService.getService('redirector').redirect('#request.CRequest.updateURL(false,"/?page=cabinet")#');
			}else{
				if ( result.RETDESC is '') {
					instance.message = '';
				} else {
					instance.message = '#result.RETDESC#';
				}

				if (StructKeyExists(result.STRUCT, 'RBAC')) {
					instance.RBAC = result.STRUCT['RBAC'];
				} else {
					instance.RBAC = '';
				}
			}
		}

		if ( isdefined('form.endReception') ){
			var userReception = factoryService.getService('userReceptionAPI');
			result = userReception.startEndUserReception( #form.rp_id#, 3, #form.user_id1#, #form.user_id2# );
			if ( result.RETVAL is 1 ){
				//factoryService.getService('redirector').redirect('#request.CRequest.updateURL(false,"/?page=cabinet")#');
			}else{
				if ( result.RETDESC is '') {
					instance.message = '';
				} else {
					instance.message = '#result.RETDESC#';
				}

				if (StructKeyExists(result.STRUCT, 'RBAC')) {
					instance.RBAC = result.STRUCT['RBAC'];
				} else {
					instance.RBAC = '';
				}
			}
		}

	}

	function _DateFormate(date){
		date = arguments.date;

		myYear = Year(date);
		myMonth = MonthAsString(Month(date));
		myDay = Day(date);

		return '#myDay# #myMonth# #myYear#';

	}

	private function viewReceptionForm(rpID){

		var qReception = factoryService.getService('userReceptionAPI').getReception(arguments.rpID);
		//writeDump(DateAdd("d", +7, qReception.rp_date));
		//writeDump(now());

		//writeDump( DateCompare(DateAdd("d", +7, qReception.rp_date), now(),"d") );

		var qUser = factoryService.getService( 'authorization' ).getUser( qReception.user_id );
		var qUser_reg = factoryService.getService( 'authorization' ).getUser( qReception.rp_useridadd );

		param name='form.rp_id' default='#arguments.rpID#';
		param name='form.user_id1' default='#instance.user.getUserId()#';
		param name='form.user_id2' default='#qReception.user_id#';
		// ------------------------------------------------ форма ---------------------------------------------------------------
		view = '';
		view &= '<div class="grid_8">
			<div class="signin-box">
			<a class="g-button g-button-submit" href="#request.CRequest.updateURL(false,"/?page=cabinet")#">Назад к общему расписанию.</a>
			<br><br>
			<h2>Запись пациента на приём:</h2>
			<hr>';
			view &= '<div>Статус: #status(qReception.rp_status)#<br>';
			view &= 'Врач: <b>#qUser.emp_family# #qUser.EMP_FIRSTNAME# #qUser.EMP_LASTNAME#</b><br>';
			view &= 'Дата: <b><font color="green">#_DateFormate(qReception.rp_date)#</font></b><br>';
			view &= 'Начало приёма у врача: <b><font color="green">#TimeFormat(qReception.rp_starttime_default, "HH:mm")#</font></b><br>';
			view &= 'Окончание приёма у врача: <b><font color="green">#TimeFormat(dateAdd("s", +1, qReception.rp_endtime_default), "HH:mm")#</font></b><br>';
			view &= 'Регистратор: #qUser_reg.emp_family# #qUser_reg.EMP_FIRSTNAME# #qUser_reg.EMP_LASTNAME#<br>';
			if ( qReception.user_id == instance.user.getUserId() ){
				if (qReception.rp_status >= 1 AND DateCompare(DateAdd("d", +7, qReception.rp_date), now(),"d") >= 0){
					view &= '<a href="#request.CRequest.updateURL(false,"/?page=cabinet&section=reception&action=edite&rpid=#arguments.rpID#")#">Редактировать</a>';
				}
			}

			view &= '</div>';

			if ( qReception.pt_id is ''){
				view &= '<hr><div>Пациент: <font color="red">Пациент не выбран.</font>';
				if ( qReception.user_id == instance.user.getUserId() ){
					if (qReception.rp_status >= 1 AND DateCompare(DateAdd("d", +7, qReception.rp_date), now(),"d") >= 0){
						view &= '<a href="#request.CRequest.updateURL(false,"/?page=cabinet&section=reception&action=addPatient&rpid=#arguments.rpID#")#">+Добавить пациента.</a>';
					}
				}
				view &= '</div>';
			}else{
				//
				patientid = qReception.pt_id;
				factoryService.getService('patientsAPI').setPatient(patientid);
				patient = factoryService.getService('patientsAPI').getPatient();

				factoryService.getService('patientsAPI').setPatientContacts(patientid);
				patient_cnt = factoryService.getService('patientsAPI').getPatientContacts();
				patient_dms = factoryService.getService('patientsAPI').getPatientDMS('',patientid);
                                                                                  
				view &= '<hr><div>Пациент: <b>#patient.pt_family# #patient.pt_firstname# #patient.pt_lastname#</b> <a target="_blank" href="/?page=patients&section=patient&action=view&patientid=#patient.pt_id#" title="Перейти в картотеку"><img src="img/users.png" border="0"></a> #IIF( patient_dms.recordcount , DE("<img src='img/health-20.png' border='0' title='Страховой'>"), DE("") )#<br> 
					Дата рождения: <b>#_DateFormate(patient.pt_dob)#</b><br>';
				for(var y=1; y<=patient_cnt.recordcount; y++){
					view&= '#patient_cnt.cnt_type_description[y]#: <b>#patient_cnt.ptc_data[y]#</b> <br>';
				}

               			if ( qReception.user_id == instance.user.getUserId() ){
					if (qReception.rp_status >= 1 AND DateCompare(DateAdd("d", +7, qReception.rp_date), now(),"d") >= 0){
						view&='<a href="#request.CRequest.updateURL(false,"/?page=cabinet&section=reception&action=addPatient&rpid=#arguments.rpID#")#">Изменить.</a><br>';
					}
				}
				view &= '</div>';


				// место для БЛ
				/*
				проверяем есть ли в базе открытый больничный лист у данного пациента, если есть,
				то выводим данные по этому больничному листу кто открыл и когда (ссылка на приём),
				если у пациента нет открытого листа, то проверяем нет ли открытого листа в данной записи приёма,
				если есть выводим информацию, если нет выводим кнопку открытия больничного листа.
				*/

				qFindSL = factoryService.getService('sickListsAPI').findSickList( qReception.rp_id, qReception.user_id, qReception.pt_id, '2,3,4' );
				//writeDump(qFindSL);

				// только врач может открыть больничный
				//if ( qReception.user_id == instance.user.getUserId() ){
					if ( qReception.rp_id AND qReception.user_id AND qReception.pt_id != '' ){
						view &= '<div>Больничный лист - #qReception.rp_id# #qReception.user_id# #qReception.pt_id# </div>';

					}else{
						view &= '<div>Ошибка - #qReception.rp_id# #qReception.user_id# #qReception.pt_id# </div>';
					}
				//}
				// место для БЛ

			}

			view &= '<hr>
				<div>Примечание: #qReception.rp_description#<br>';
				if ( qReception.user_id == instance.user.getUserId() ){
					if (qReception.rp_status >= 1 AND DateCompare(DateAdd("d", +7, qReception.rp_date), now(),"d") >= 0){
						view &= '<a href="#request.CRequest.updateURL(false,"/?page=cabinet&section=reception&action=edite&rpid=#arguments.rpID#")#">Изменить.</a>';
					}
				}
				view &= '</div>';

			// выводим список услуг
			var qRServices = factoryService.getService('userServicesAPI').getReceptionServices(arguments.rpID);
			//writeDump(qRServices);
			view &= '<hr><div><table width="100%"><tr><td class="block">Список услуги:</td><td class="block">руб.</td><td class="block">-</td><td class="block">-</td>';
			if (qRServices.recordcount){
				var summ = 0;
				for(var x=1; x<=qRServices.recordcount; x++){
					summ += qRServices.sv_price[x];
					var _qService = factoryService.getService('servicesAPI').getService(qRServices.pls_id[x]);
					pls_price_ot = round(_qService.pls_price_ot);
					if (_qService.pls_price_do != ''){
						pls_price_do = round(_qService.pls_price_do);
					}else{
						pls_price_do = 0;
					}
					view &= '<tr><td class="block" style="text-align:left;" width="100%">
						<form name="" action="#request.CRequest.updateURL(false,"/?page=cabinet&section=reception&action=view&rpid=#arguments.rpID#")#" method="post">
						<b>#qRServices.sv_name[x]#</b></td><td class="block" nowrap>#round(qRServices.sv_price[x])# #iif( _qService.pls_price_do is '', DE("<img title='Фиксированная цена' src='img\arrow_up_disable.png'>"), DE("<a href='/?page=cabinet&section=service&action=edite&svid=#qRServices.sv_id[x]#'><img title='Диапазон цен от #pls_price_ot# до #pls_price_do#' src='img\arrow_up.png'></a>") )#</td><td class="block" nowrap>';

						if ( qRServices.pls_shablon[x] != ''){
							
							if ( qReception.rp_status >= 2 AND qReception.pt_id != '' AND DateCompare(DateAdd("d", +7, qReception.rp_date), now(),"d") >= 0 ){
			        				if ( qReception.user_id == instance.user.getUserId() ){
								view &= ' <a href="#request.CRequest.updateURL(false,"/?page=cabinet&section=reception&action=editeDocumentService&rpid=#form.rp_id#&svid=#qRServices.sv_id[x]#")#"><img src = "img/document_edit.png" align = "absmiddle"></a>';
								}
							}
							if( qReception.rp_status >= 2 AND qReception.pt_id != ''){
								view &= '<a href="/?page=cabinet&section=document&svid=#qRServices.sv_id[x]#" target="_blank"><img src = "img/pdf1.png" align = "absmiddle"></a>';
								if (qRServices.st_id[x] == 1){
									view &= ' <a href="/?page=cabinet&section=document1&svid=#qRServices.sv_id[x]#" target="_blank" title="Для пациента"><img src = "img/document.png" align = "absmiddle"></a>';
								}
							}else{
								view &= '<img src="/img/important.png" title="Выберите пациента и нажмите начать приём!">';
							}
						}else{
							view &= '<img src="/img/important.png" title="В данный момент у этой услуги нет шаблона. Если нужен шаблон, обратитесь к администратору!">';
						}

						view &= '</td>
						<input type="hidden" name="rp_id" value="#form.rp_id#" size="20" maxlength="20">
						<input type="hidden" name="sv_id" value="#qRServices.sv_id[x]#" size="20" maxlength="20">';
						if (qReception.rp_status >= 1 AND DateCompare(DateAdd("d", +7, qReception.rp_date), now(),"d") >= 0){
							if ( qRServices.sv_status[x] == 1 ){
								view &= '<td class="block"><input class="g-button g-button-submit" type="submit" #IIF(qReception.user_id is instance.user.getUserId(), DE(""), DE("disabled") )# name="deleteService" value="Удалить"></td>';
							}else{
								view &= '<td class="block"><img src="/img/important.png" title="Услуга оплачена, удалить нельзя!"></td>';
							}
						}else{
							view &= '<td class="block"><img src="/img/important.png" title="Архив!"></td>';
						}
						view &= '</form></tr>';
				}
				view &= '<tr><td class="block" style="text-align:right;"><b>Итого:</b></td><td class="block">#summ#</td></tr></table>';
				//view &= '</table>';
			}else{
				view &= '<tr><td class="block"><font color="red">Нет выбранных услуг!</font></td><td class="block">-</td><td class="block">-</td><td class="block">-</td></tr>';
			}
			view &= '</table>';

			// форма добавки услуги
			// строим выпадающий список услуг
	// если запись старше 7 дней то кнопка "УДАЛИТЬ ЗАПИСЬ" не работает
			if (qReception.rp_status >= 1 AND DateCompare(DateAdd("d", +7, qReception.rp_date), now(),"d") >= 0){
			view &= '<hr><b>Добавить услугу к данному приёму:</b>
			<form name="" action="#request.CRequest.updateURL(false,"/?page=cabinet&section=reception&action=view&rpid=#arguments.rpID#")#" method="post">
			<input type="hidden" name="rp_id" value="#form.rp_id#" size="20" maxlength="20">
			<input type="hidden" name="user_id1" value="#form.user_id1#" size="20" maxlength="20">
			<input type="hidden" name="user_id2" value="#form.user_id2#" size="20" maxlength="20">';

			//if (qReception.rp_status >= 1 AND DateCompare(DateAdd("d", +7, qReception.rp_date), now(),"d") >= 0){
			  var qEmpServices = factoryService.getService('userServicesAPI').getEmpServices(qUser.emp_type);
			  view &= '<div>
				<br><select name="plsID" class="select">
					<option value="">---</option>';
				
					empt_id = '';
					st_id = '';
					for(var x=1; x<=qEmpServices.recordcount; x++){
						if ( empt_id == '' and st_id == ''){
							var qEmpt = factoryService.getService('employeesAPI').getEmployee(qEmpServices.empt_id[x]);
							var qServicesType = factoryService.getService('servicesTypeAPI').getServiceType(qEmpServices.st_id[x]);
							view &= '<option value="#x#" disabled>#qEmpt.empt_name#</option>';
							view &= '<option value="#x#" disabled>#qServicesType.st_name#</option>';
							view &= '<option value="#qEmpServices.pls_id[x]#">#qEmpServices.pls_name[x]# - #iif(qEmpServices.pls_price_do[x] is '', DE("#LSCurrencyFormat(qEmpServices.pls_price_ot[x])#"), DE("от #LSCurrencyFormat(qEmpServices.pls_price_ot[x])# - до #LSCurrencyFormat(qEmpServices.pls_price_do[x])#") )#</option>';
							empt_id = qEmpServices.empt_id[x];
							st_id = qEmpServices.st_id[x];

						}else if(empt_id == qEmpServices.empt_id[x] and st_id == qEmpServices.st_id[x]){
							view &= '<option value="#qEmpServices.pls_id[x]#">#qEmpServices.pls_name[x]# - #iif(qEmpServices.pls_price_do[x] is '', DE("#LSCurrencyFormat(qEmpServices.pls_price_ot[x])#"), DE("от #LSCurrencyFormat(qEmpServices.pls_price_ot[x])# - до #LSCurrencyFormat(qEmpServices.pls_price_do[x])#") )#</option>';

						}else if(empt_id == qEmpServices.empt_id[x] and st_id != qEmpServices.st_id[x]){
							var qServicesType = factoryService.getService('servicesTypeAPI').getServiceType(qEmpServices.st_id[x]);
							view &= '<option value="#x#" disabled>#qServicesType.st_name#</option>';
							view &= '<option value="#qEmpServices.pls_id[x]#">#qEmpServices.pls_name[x]# - #iif(qEmpServices.pls_price_do[x] is '', DE("#LSCurrencyFormat(qEmpServices.pls_price_ot[x])#"), DE("от #LSCurrencyFormat(qEmpServices.pls_price_ot[x])# - до #LSCurrencyFormat(qEmpServices.pls_price_do[x])#") )#</option>';
							st_id = qEmpServices.st_id[x];

						}else if(empt_id != qEmpServices.empt_id[x]){
							var qEmpt = factoryService.getService('employeesAPI').getEmployee(qEmpServices.empt_id[x]);
							var qServicesType = factoryService.getService('servicesTypeAPI').getServiceType(qEmpServices.st_id[x]);
							view &= '<option value="#x#" disabled>#qEmpt.empt_name#</option>';
							view &= '<option value="#x#" disabled>#qServicesType.st_name#</option>';
							view &= '<option value="#qEmpServices.pls_id[x]#">#qEmpServices.pls_name[x]# - #iif(qEmpServices.pls_price_do[x] is '', DE("#LSCurrencyFormat(qEmpServices.pls_price_ot[x])#"), DE("от #LSCurrencyFormat(qEmpServices.pls_price_ot[x])# - до #LSCurrencyFormat(qEmpServices.pls_price_do[x])#") )#</option>';
							empt_id = qEmpServices.empt_id[x];
							st_id = qEmpServices.st_id[x];
						}
					}
					//writeDump(qEmpServices);

			  view &= '</select>';
			  //view &= '<a href="#request.CRequest.updateURL(false,"/?page=reception&section=reception&action=addService&rpid=#arguments.rpID#&emptype=#qUser.emp_type#")#">+Добавить услугу.</a></div>';
			  view &= ' <input class="g-button g-button-submit" type="submit" #IIF(qReception.user_id is instance.user.getUserId(), DE(""), DE("disabled") )# name="addService" value="Добавить"></div>';
			  if (instance.plsID is not ''){
				view &= '<div id="plsID" style="color:red;">#instance.plsID#</div>';
			  }
			}

       			if (instance.rpStatus is not ''){
				view &= '<div id="rpStatus" style="color:red;">#instance.rpStatus#</div>';
			}

			if (instance.message is not ''){
				view &= '<div id="mes" style="color:red;">#instance.message#</div>';
			}

                view &= '</div>';


		if (qReception.rp_status == 1){
			view &= '<hr><div><input class="g-button g-button-share" type="submit" #IIF(qReception.user_id is instance.user.getUserId(), DE(""), DE("disabled") )# name="startReception" value="Начать приём">';
			view &= '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input class="g-button g-button-red" type="submit" name="deleteReception" value="Удалить запись"></div>';
		}

		if (qReception.rp_status == 2){
			//view &= '<hr> <div>Документы</div>';
			view &= '<hr><div><input class="g-button g-button-share" type="submit" #IIF(qReception.user_id is instance.user.getUserId(), DE(""), DE("disabled") )# name="endReception" value="Закончить приём"></div>';
		}

		if (qReception.rp_status == 3){
			// эту запись в таком статусе может удалить только администратор.
			// можно потом добавить сюда этот функционал.
		}

		if (instance.RBAC is not ''){
			view &= '<div id="mes" style="color:red;">#instance.RBAC#</div>';
		}

		//view &= '';

		view &='</form>
			</div></div>';

		view &= '<div class="grid_8">
			<div class="signin-box">';

		view &= '	<fieldset>
					<legend>Записи пациента к врачам:</legend>';

		if ( qReception.pt_id is ''){
			view &= 'Пациент не выбран.';
		}else{
			patientid = qReception.pt_id;
			//factoryService.getService('patientsAPI').setPatient(patientid);
			//patient = factoryService.getService('patientsAPI').getPatient();
			patient_reception = factoryService.getService('patientsAPI').getPatientReception(patientid);
			for (var x=1; x<=patient_reception.recordcount; x++ ){
				var num = patient_reception.rp_status[x];
				if (num == 1){
					class = 'span1';
					title = 'Приём не начался.';
				}else if(num == 2){
					class = 'span2';
					title = 'Идёт приём у врача';
				}else if(num == 3){
					class = 'span3';
					title = 'Приём окончен.';
				}
				qUser = factoryService.getService( 'authorization' ).getUser( patient_reception.user_id[x] );
				rbac = request.RBAC;
				if ( rbac.CheckAccess('cabinet','access') ){
					view &= '<span class="#class#" title="#title#" style="width: 2%;">&nbsp;</span> <a  target="_blank" href="/?page=cabinet&section=reception&action=view&rpid=#patient_reception.rp_id[x]#">(#dateFormat(patient_reception.rp_date[x],"DD/MM/YYYY")# - #timeFormat(patient_reception.rp_starttime_default[x],"HH:MM")#) - #qUser.emp_family# #qUser.emp_firstname# #qUser.emp_lastname#</a><br>';
				}else if( rbac.CheckAccess('reception','access') ){
					view &= '<span class="#class#" title="#title#" style="width: 2%;">&nbsp;</span> <a  target="_blank" href="/?page=reception&section=reception&action=view&rpid=#patient_reception.rp_id[x]#">(#dateFormat(patient_reception.rp_date[x],"DD/MM/YYYY")# - #timeFormat(patient_reception.rp_starttime_default[x],"HH:MM")#) - #qUser.emp_family# #qUser.emp_firstname# #qUser.emp_lastname#</a><br>';				
				}else{
					view &= '<span class="#class#" title="#title#" style="width: 2%;">&nbsp;</span> (#dateFormat(patient_reception.rp_date[x],"DD/MM/YYYY")# - #timeFormat(patient_reception.rp_starttime_default[x],"HH:MM")#) - #qUser.emp_family# #qUser.emp_firstname# #qUser.emp_lastname#<br>';
				}
				_qRServices = factoryService.getService('userServicesAPI').getReceptionServices(patient_reception.rp_id[x]);
				//writeDump(_qRServices);
				if (_qRServices.recordcount){
					for(var y=1; y<=_qRServices.recordcount; y++){
						view &= '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- #_qRServices.sv_name[y]# ';
						if ( _qRServices.pls_shablon[y] != ''){
							if( patient_reception.rp_status[x] >= 2 AND patient_reception.pt_id[x] != ''){
								view &= '<a href="/?page=cabinet&section=document&svid=#_qRServices.sv_id[y]#" target="_blank"><img src = "img/pdf1.png" align = "absmiddle" title="Открыть документ"></a>';
							}
						}
						view &= '<br>';
					}
					view &= '<br>';
				}else{
					view &= '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Нет услуг!<br><br>';
				}
			}

			view &= '	</fieldset>';
		}

		view &=	'</div></div>';

			// ------------------------------------------------ форма ---------------------------------------------------------------
		return view;
	}
	
	private function addUserReceptionFormHandler(userID){
		// --- обработчик формы---
		//writeDump(form);
		if ( isdefined('form.addUserReception') ){
		form.rp_starttime_default = '#form.rpTimeHStart#:#form.rpTimeMStart#';
		form.rp_endtime_default = '#form.rpTimeHEnd#:#form.rpTimeMEnd#';
		form._rp_endtime_default = dateAdd('s', -1, form.rp_endtime_default);

		var userReception = factoryService.getService('userReceptionAPI');
		result = userReception.addUserReception( #form.user_id#, #form.rp_date#, #form.rp_starttime_default#, #form._rp_endtime_default#, #form.rp_status#, #form.gr_starttime#, #form.gr_endtime# );
			//result.RETVAL = 1;
			if ( result.RETVAL is 1 ){
				// сюда нужно вернуть rp_id и перенаправить на форму редактирования
				// где можно будет добавлять услуги и пациента !!!!!!!!!!!!!!!!!
				factoryService.getService('redirector').redirect('#request.CRequest.updateURL(false,"/?page=cabinet&section=reception&action=view&rpid=#result.RETDESC#")#');

			}else{
				// --- пробная версия
				if ( result.RETDESC is '') {
					instance.message = '';
				} else {
					instance.message = '#result.RETDESC#';
				}


				if (StructKeyExists(result.STRUCT, 'rpDate')) {
					instance.rpDate = result.STRUCT['rpDate'];
				} else {
					instance.rpDate = '';
				}
				if (StructKeyExists(result.STRUCT, 'rpStartTime')) {
					instance.rpStartTime = result.STRUCT['rpStartTime'];
				} else {
					instance.rpStartTime = '';
				}
				if (StructKeyExists(result.STRUCT, '_rpStartTime')) {
					instance._rpStartTime = result.STRUCT['_rpStartTime'];
				} else {
					instance._rpStartTime = '';
				}
				if (StructKeyExists(result.STRUCT, 'rpEndTime')) {
					instance.rpEndTime = result.STRUCT['rpEndTime'];
				} else {
					instance.rpEndTime = '';
				}
				if (StructKeyExists(result.STRUCT, '_rpEndTime')) {
					instance._rpEndTime = result.STRUCT['_rpEndTime'];
				} else {
					instance._rpEndTime = '';
				}
				if (StructKeyExists(result.STRUCT, 'Time')) {
					instance.Time = result.STRUCT['Time'];
				} else {
					instance.Time = '';
				}
				if (StructKeyExists(result.STRUCT, 'rpStatus')) {
					instance.rpStatus = result.STRUCT['rpStatus'];
				} else {
					instance.rpStatus = '';
				}

			}
		}
		// --- обработчик формы---
	}

	function addUserReceptionForm( userid, date, starttime, endtime ){

		if ( arguments.date == 'false' ){
			currentDate = createodbcdate(now()); //
		}else{
			date = arguments.date; //
			currentDate = createodbcdate(date);
		}

		//arguments.starttime
		if ( arguments.starttime == 'false' ){
			starttime = '08:00'; //
			endtime = '08:30';
		}else{
			starttime = arguments.starttime; //
			endtime = TimeFormat(dateAdd('n', +30, starttime), "HH:mm");
		}

		param name='form.user_id' default='#arguments.userID#';
		param name='form.rp_date' default='#currentDate#';
		param name='form.rp_starttime_default' default='#starttime#';
		param name='form.rpTimeHStart' default='00';
		param name='form.rpTimeMStart' default='00';
		param name='form.rp_endtime_default' default='#endtime#';
		param name='form.rpTimeHEnd' default='00';
		param name='form.rpTimeMEnd' default='00';

		param name='form.rp_status' default='1';

		qUser = factoryService.getService( 'authorization' ).getUser( arguments.userid );

		// set 
		_userGraphic = factoryService.getService('usersGraphicsAPI');
		_userGraphic.setUsersGraphicsList(arguments.userID , currentDate, currentDate);
		userGraphic = _userGraphic.getUserGraphics( arguments.userid, currentDate);
		param name='form.gr_starttime' default='#userGraphic.gr_starttime#';
		param name='form.gr_endtime' default='#userGraphic.gr_endtime#';
		//writeDump(qUser);
		//writeDump(userGraphic);

		// ---------------------------------------------------------- форма ---------------------------------------------------------------
		view = '';
		view &= '<div class="grid_8">
			<div class="signin-box">
			<a class="g-button g-button-submit" href="#request.CRequest.updateURL(false,"/?page=cabinet")#">Назад к общему расписанию</a><br><br>
			<h2>Записать пациента на приём:</h2>
			<hr>
			<form name="" action="#request.CRequest.updateURL(false,"/?page=cabinet&section=reception&action=add&userid=#arguments.userID#")#" method="post">';

			view &= '<div>Врач: <b>#qUser.emp_family# #qUser.EMP_FIRSTNAME# #qUser.EMP_LASTNAME#</b></div>';
			view &= '<div><input type="hidden" name="user_id" value="#form.user_id#" size="20" maxlength="20"></div>';
			view &= '<div><input type="hidden" name="gr_starttime" value="#form.gr_starttime#" size="20" maxlength="20"></div>';
			view &= '<div><input type="hidden" name="gr_endtime" value="#form.gr_endtime#" size="20" maxlength="20"></div>';

			view &= '<div>Дата: <b>#_DateFormate(form.rp_date)#</b><br>
				<input type="hidden" name="rp_date" value="#form.rp_date#" size="20" maxlength="20"></div>';

			view &= '<div>
					<label>Начало приёма у врача:</label>'; // если что, добавить <label>
				view &= ' <select name="rpTimeHStart">';
					    for ( var x=8; x<=20; x++){
					     view &= '<option value="#x#" #_DateCompare( x, form.rp_starttime_default, "HH")#>#numberformat(x,"09")#</option>';
					    }
				view &= ' </select>
					  <select name="rpTimeMStart">';
					    for ( var x=0; x<=59; x=x+5){
					    view &= '<option value="#x#" #_DateCompare( x, form.rp_starttime_default, "MM")#>#numberformat(x,"09")#</option>';
					    }
				view &= '  </select>';


	   		if (instance.rpStartTime is not ''){
				view &= '		<label for="rp_starttime" class="error" generated="3">#instance.rpStartTime#</label>';
			}

	   		if (instance._rpStartTime is not ''){
				view &= '		<label for="rp_starttime" class="error" generated="3">#instance._rpStartTime#</label>';
			}

			view &= '</div>
				<div>
					<label>Окончание приёма у врача:</label>';
				view &= ' <select name="rpTimeHEnd">';
					    for ( var x=8; x<=20; x++){
					     view &= '<option value="#x#" #_DateCompare( x, form.rp_endtime_default, "HH")#>#numberformat(x,"09")#</option>';
					    }
				view &= ' </select>
					  <select name="rpTimeMEnd">';
					    for ( var x=0; x<=59; x=x+5){
					    view &= '<option value="#x#" #_DateCompare( x, form.rp_endtime_default, "MM")#>#numberformat(x,"09")#</option>';
					    }
				view &= '  </select>';

	   		if (instance.rpEndTime is not ''){
				view &= '	<label for="rp_endtime" class="error" generated="3">#instance.rpEndTime#</label>';
			}
	   		if (instance._rpEndTime is not ''){
				view &= '	<label for="rp_endtime" class="error" generated="3">#instance._rpEndTime#</label>';
			}
	   		if (instance.Time is not ''){
				view &= '	<label for="rp_endtime" class="error" generated="3">#instance.Time#</label>';
			}

			view &= '<div><input type="hidden" name="rp_status" value="#form.rp_status#" size="20" maxlength="20"></div>';

			view &= '</div><div>
					<input disabled class="g-button g-button-submit" type="submit" name="escape" value="Отмена">
					<input class="g-button g-button-submit" type="submit" name="addUserReception" value="Сохранить"> ';

			if (instance.message is not ''){
				view &= '<div id="mes" style="color:red;">#instance.message#</div>';
			}

		view &='</div></form>
			</div></div>';

			// ------------------------------------------------ форма ---------------------------------------------------------------
		return view;
	}

	private function editeUserReceptionFormHandler(){
		// --- обработчик формы---

		if ( isdefined('form.editeUserReception') ){
		form.rp_starttime_default = '#form.rpTimeHStart#:#form.rpTimeMStart#';
		form.rp_endtime_default = '#form.rpTimeHEnd#:#form.rpTimeMEnd#';
		form._rp_endtime_default = dateAdd('s', -1, form.rp_endtime_default);

		var userReception = factoryService.getService('userReceptionAPI');
		result = userReception._editeUserReception( #form.rp_id#, #form.user_id#, #form.rp_date#, #form.rp_starttime_default#, #form._rp_endtime_default#, #form.rp_description#, #form.rp_status#, #form.gr_starttime#, #form.gr_endtime# );
			//result.RETVAL = 1;
			if ( result.RETVAL is 1 ){
				// сюда нужно вернуть rp_id и перенаправить на форму редактирования
				// где можно будет добавлять услуги и пациента !!!!!!!!!!!!!!!!!
				factoryService.getService('redirector').redirect('#request.CRequest.updateURL(false,"/?page=cabinet&section=reception&action=view&rpid=#form.rp_id#")#');

			}else{
				// --- пробная версия
				if ( result.RETDESC is '') {
					instance.message = '';
				} else {
					instance.message = '#result.RETDESC#';
				}


				if (StructKeyExists(result.STRUCT, 'rpDate')) {
					instance.rpDate = result.STRUCT['rpDate'];
				} else {
					instance.rpDate = '';
				}
				if (StructKeyExists(result.STRUCT, 'rpStartTime')) {
					instance.rpStartTime = result.STRUCT['rpStartTime'];
				} else {
					instance.rpStartTime = '';
				}
				if (StructKeyExists(result.STRUCT, '_rpStartTime')) {
					instance._rpStartTime = result.STRUCT['_rpStartTime'];
				} else {
					instance._rpStartTime = '';
				}
				if (StructKeyExists(result.STRUCT, 'rpEndTime')) {
					instance.rpEndTime = result.STRUCT['rpEndTime'];
				} else {
					instance.rpEndTime = '';
				}
				if (StructKeyExists(result.STRUCT, '_rpEndTime')) {
					instance._rpEndTime = result.STRUCT['_rpEndTime'];
				} else {
					instance._rpEndTime = '';
				}
				if (StructKeyExists(result.STRUCT, 'Time')) {
					instance.Time = result.STRUCT['Time'];
				} else {
					instance.Time = '';
				}
				if (StructKeyExists(result.STRUCT, 'rpDescription')) {
					instance.rpDescription = result.STRUCT['rpDescription'];
				} else {
					instance.rpDescription = '';
				}
				if (StructKeyExists(result.STRUCT, 'rpStatus')) {
					instance.rpStatus = result.STRUCT['rpStatus'];
				} else {
					instance.rpStatus = '';
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

	function editeUserReceptionForm( rpID ){

		userReception = factoryService.getService('userReceptionAPI').getReception( arguments.rpID );

		param name='form.rp_id' default='#userReception.rp_id#';
		param name='form.user_id' default='#userReception.user_id#';
		param name='form.rp_date' default='#userReception.rp_date#';
		param name='form.rp_starttime_default' default='#userReception.rp_starttime_default#';
		param name='form.rpTimeHStart' default='00';
		param name='form.rpTimeMStart' default='00';
		param name='form.rp_endtime_default' default='#dateAdd("s", +1, userReception.rp_endtime_default)#';
		param name='form.rpTimeHEnd' default='00';
		param name='form.rpTimeMEnd' default='00';
		param name='form.rp_description' default='#userReception.rp_description#';
		param name='form.rp_status' default='#userReception.rp_status#';

		qUser = factoryService.getService( 'authorization' ).getUser( userReception.user_id );
		_userGraphic = factoryService.getService('usersGraphicsAPI');
		_userGraphic.setUsersGraphicsList(userReception.user_id , userReception.rp_date, userReception.rp_date);
		userGraphic = _userGraphic.getUserGraphics( userReception.user_id, userReception.rp_date );
		param name='form.gr_starttime' default='#userGraphic.gr_starttime#';
		param name='form.gr_endtime' default='#userGraphic.gr_endtime#';
		//writeDump(qUser);
		//writeDump(userGraphic);

		// ---------------------------------------------------------- форма ---------------------------------------------------------------
		view = '';
		view &= '<div class="grid_8">
			<div class="signin-box">
			<a class="g-button g-button-submit" href="#request.CRequest.updateURL(false,"/?page=cabinet&section=reception&action=view&rpid=#userReception.rp_id#")#">Назад</a><br><br>

			<h2>Записать пациента на приём:</h2>
			<hr>
			<form name="" action="#request.CRequest.updateURL(false,"/?page=cabinet&section=reception&action=edite&rpid=#userReception.rp_id#")#" method="post">';

			view &= '<div>Врач: <b>#qUser.emp_family# #qUser.EMP_FIRSTNAME# #qUser.EMP_LASTNAME#</b></div>';
			view &= '<div><input type="hidden" name="rp_id" value="#form.rp_id#" size="20" maxlength="20"></div>';
			view &= '<div><input type="hidden" name="user_id" value="#form.user_id#" size="20" maxlength="20"></div>';
			view &= '<div><input type="hidden" name="gr_starttime" value="#form.gr_starttime#" size="20" maxlength="20"></div>';
			view &= '<div><input type="hidden" name="gr_endtime" value="#form.gr_endtime#" size="20" maxlength="20"></div>';

			view &= '<div>Дата: <b>#_DateFormate(form.rp_date)#</b><br>
				<input type="hidden" name="rp_date" value="#form.rp_date#" size="20" maxlength="20"></div>';

			view &= '<div>
					<label>Начало приёма у врача:</label>'; // если что, добавить <label>
				view &= ' <select name="rpTimeHStart">';
					    for ( var x=8; x<=20; x++){
					     view &= '<option value="#x#" #_DateCompare( x, form.rp_starttime_default, "HH")#>#numberformat(x,"09")#</option>';
					    }
				view &= ' </select>
					  <select name="rpTimeMStart">';
					    for ( var x=0; x<=59; x=x+5){
					    view &= '<option value="#x#" #_DateCompare( x, form.rp_starttime_default, "MM")#>#numberformat(x,"09")#</option>';
					    }
				view &= '  </select>';


	   		if (instance.rpStartTime is not ''){
				view &= '		<label for="rp_starttime" class="error" generated="3">#instance.rpStartTime#</label>';
			}

	   		if (instance._rpStartTime is not ''){
				view &= '		<label for="rp_starttime" class="error" generated="3">#instance._rpStartTime#</label>';
			}

			view &= '</div>
				<div>
					<label>Окончание приёма у врача:</label>';
				view &= ' <select name="rpTimeHEnd">';
					    for ( var x=8; x<=20; x++){
					     view &= '<option value="#x#" #_DateCompare( x, form.rp_endtime_default, "HH")#>#numberformat(x,"09")#</option>';
					    }
				view &= ' </select>
					  <select name="rpTimeMEnd">';
					    for ( var x=0; x<=59; x=x+5){
					    view &= '<option value="#x#" #_DateCompare( x, form.rp_endtime_default, "MM")#>#numberformat(x,"09")#</option>';
					    }
				view &= '  </select>';

	   		if (instance.rpEndTime is not ''){
				view &= '	<label for="rp_endtime" class="error" generated="3">#instance.rpEndTime#</label>';
			}
	   		if (instance._rpEndTime is not ''){
				view &= '	<label for="rp_endtime" class="error" generated="3">#instance._rpEndTime#</label>';
			}
	   		if (instance.Time is not ''){
				view &= '	<label for="rp_endtime" class="error" generated="3">#instance.Time#</label>';
			}

			view &= '</div>
				<div><input type="hidden" name="rp_status" value="#form.rp_status#" size="20" maxlength="20"></div>';

			view &= '
				<div>
					<label for="rp_description"><b>Примечание:</b></label>
					<textarea name = "rp_description" rows="6" cols="47" >#form.rp_description#</textarea>';

			if (instance.rpDescription is not ''){
			view &= '		<label for="rp_description" class="error" generated="0">#instance.rpDescription#</label>';
			}

			if (instance.rpStatus is not ''){
			view &= '		<label for="rp_status" class="error" generated="1">#instance.rpStatus#</label>';
			}

			view &= '</div><div>
					<input disabled class="g-button g-button-submit" type="submit" name="escape" value="Отмена">
					<input class="g-button g-button-submit" type="submit" name="editeUserReception" value="Сохранить"> ';

			if (instance.message is not ''){
				view &= '<div id="mes" style="color:red;">#instance.message#</div>';
			}
			if (instance.RBAC is not ''){
				view &= '<div id="RBAC" style="color:red;">#instance.RBAC#</div>';
			}

		view &='</div></form>
			</div></div>';

			// ------------------------------------------------ форма ---------------------------------------------------------------
		return view;
	}

	function _DateCompare(date1,date2, type){
		date1 = arguments.date1;
		date2 = timeFormat(arguments.date2, "#arguments.type#");
		//writeDump(date1);
		//writeOutPut('-');
		//writeDump(date2);
		//writeOutPut('<br>');
		if ( date1 == date2 ){
			return 'selected';
		}else{
			return '';
		}
	}


	function userGraphicsReceptionListForm(userID,Date){

		/////////////////////////////////////////////////////////////////////////////////////////

		if ( arguments.date == 'false' ){
			if ( isdefined('session.date') ){
				currentDate = session.date;
			}else{
				currentDate = createodbcdate(now()); //
				session.date = createodbcdate(now());
			}
			
		}else{
			date = arguments.date; //
			currentDate = createodbcdate(date);
			session.date = createodbcdate(date);
		}

		/////////////////////////////////////////////////////////////////////////////////////////

		currentDay = Day(currentDate);
		currentMonth = Month(currentDate);
		currentYear = Year(currentDate);
		//DayInMonth = DaysInMonth(currentDate);
		dayOfWeek = DayOfWeek(currentDate)-1;

		listDateOfWeek = '';
		if ( dayOfWeek == 0){
			for(x=1; x<7; x++){
				listDateOfWeek = listPrepend( listDateOfWeek, dateFormat(dateAdd('d', -x, currentDate),'YYYY.MM.DD') );
			}
			listDateOfWeek = listAppend( listDateOfWeek, dateFormat( currentDate,'YYYY.MM.DD') );

		}else if( dayOfWeek==1 ){
			for(x=1; x<7; x++){
				listDateOfWeek = listAppend( listDateOfWeek, dateFormat(dateAdd('d', +x, currentDate),'YYYY.MM.DD') );
			}
			listDateOfWeek = listPrepend( listDateOfWeek, dateFormat( currentDate,'YYYY.MM.DD') );
			//
		}else{
			for(x=1; x<dayOfWeek; x++){
				listDateOfWeek = listPrepend( listDateOfWeek, dateFormat(dateAdd('d', -x, currentDate),'YYYY.MM.DD') );
			}

			lastDay = 7-dayOfWeek;
			if ( dayOfWeek ){
				listDateOfWeek = listAppend( listDateOfWeek, dateFormat( currentDate,'YYYY.MM.DD') );
			}

			for(x=1; x<=lastDay; x++){
				listDateOfWeek = listAppend( listDateOfWeek, dateFormat(dateAdd('d', +x, currentDate),'YYYY.MM.DD') );
			}
		}


		qUser = factoryService.getService( 'authorization' ).getUser( arguments.userid );


		var view = '';
		view &= '<div class="grid_16"><div class="signin-box">
			<h2>График врача: #qUser.emp_family# #Left(qUser.emp_firstname,1)#.#Left(qUser.emp_lastname,1)# </h2>';

			                date1 = listGetAt(listDateOfWeek,1);
			                date7 = listGetAt(listDateOfWeek,7);
					userGraphics = factoryService.getService('usersGraphicsAPI');
					setUserGraphics = userGraphics.setUsersGraphicsList(arguments.userID, createODBCDate(date1), createODBCDate(date7));
					view &=	'<div class="block" style="text-align:center;">
						<span style="width: 14%; display:inline-block;"><input class="date" value="#dateFormat( currentDate,'YYYY.MM.DD')#"></span>
						<span style="width: 75%; display:inline-block;">
							<a href="/?page=cabinet&date=#dateFormat(dateAdd("ww", -1, currentDate),"YYYY.MM.DD")#"><<</a> 
								 #Day(date1)# #MonthAsString(month(date1))# #Year(date1)# - #Day(date7)# #MonthAsString(month(date7))# #Year(date7)#
							<a href="/?page=cabinet&date=#dateFormat(dateAdd("ww", +1, currentDate),"YYYY.MM.DD")#">>></a>
						</span>
					        <span style="width: 9%; display:inline-block;">
							<a href="/?page=cabinet&date=#dateFormat(now(),'YYYY.MM.DD')#">Сегодня</a>
						</span>
						</div>';

			view &= '
				<table width="100%" cellspacing="0" >
				<tr>
					<td class="block1" height="10%">x</td>';
					for(var x=1; x<=7; x++){
						if( !DateCompare( listGetAt(listDateOfWeek,x), now(), "d" )  ){
							view &= '<td width="13.5%" class="block1"><b>#dateFormat(listGetAt(listDateOfWeek,x),"DD.MM.YYYY")#<br>#DayofWeekAsString(DayOfWeek(listGetAt(listDateOfWeek,x)),"ru")#</b></td>';
						}else{                                                
							view &= '<td width="13.5%" class="block1">#dateFormat(listGetAt(listDateOfWeek,x),"DD.MM.YYYY")# <br>#DayofWeekAsString(DayOfWeek(listGetAt(listDateOfWeek,x)),"ru")# </td>';
						}
					}
			view &= '</tr>';

               			for ( var zy=1; zy<=12; zy++){
					z = zy+7;
					if (z == 8 or z == 9){z = '0'&z;}

					view &= '<tr>
							<td height="59px" class="block1">#z#<sup>00</sup></td>';
							if (zy==1){
								//////////////////////////////////////////////////////////////
								for (var x=1; x<=listLen(listDateOfWeek); x++){

									_Date = createODBCDate( listGetAt(listDateOfWeek,x));
									userGraphic = factoryService.getService('usersGraphicsAPI').getUserGraphics( arguments.userid, _Date );
									//writeDump(userGraphic);

									view &= '<td class="block1" rowspan="12" >';
									if (userGraphic.recordcount){
									//view &= '<td class="block1" style="text-align:left;" nowrap>&nbsp;<b><a href="/?page=reception&section=userGraphicsReception&action=view&userid=#userList.user_id[x]#">#userList.emp_family[x]# #Left(userList.emp_firstname[x],1)#.#Left(userList.emp_lastname[x],1)#.</a></b> <font color="grey">#userList.empt_name[x]#</font>&nbsp;</td>';
										if (userGraphic.gr_type == 1){

											instance.mass1 = arrayNew(1);
											_start_time = DateAdd("h", -8, "#userGraphic.gr_starttime#");
											_minutes = hour(_start_time)*60 + minute(_start_time);
											_block1(0,_minutes,'start','Н-#TimeFormat(userGraphic.gr_starttime, "HH:mm")#','','','');

											// считываем рассписание
											userReception = factoryService.getService('userReceptionAPI').getUserReception( arguments.userid, _Date);
											if (userReception.recordcount NEQ 0){
												for (var i=1; i<=userReception.recordcount; i++){
													s_time = DateAdd("h", -8, "#userReception.rp_starttime_default[i]#");
													start_time_m = hour(s_time)*60 + minute(s_time);
													e_time = DateAdd("h", -8, "#dateAdd("s", +1, userReception.rp_endtime_default[i])#");
													end_time_m = hour(e_time)*60 + minute(e_time);
													patient = '';
													dms = '';
													if ( userReception.pt_id[i] is not '') {
														//запрос к базе
														request.factoryService.getService('patientsAPI').setPatient(userReception.pt_id[i]);
														qPatient = factoryService.getService('patientsAPI').getPatient();
														patient_dms = factoryService.getService('patientsAPI').getPatientDMS('',userReception.pt_id[i]);
														dms = '#IIF( patient_dms.recordcount , DE("dms"), DE("") )#';
														patient = '#qPatient.pt_family# #Left(qPatient.pt_firstname,1)#.#Left(qPatient.pt_lastname,1)#.';
													}

													service = 'xxx';
													if ( userReception.rp_status[i] == 1 ){
														service = 'service1';
													}else if( userReception.rp_status[i] == 2 ){
														service = 'service2';
													}else if( userReception.rp_status[i] == 3 ){
														service = 'service3';
													}
													_block1(start_time_m,end_time_m,'#service#','#TimeFormat(userReception.rp_starttime_default[i], "HH:mm")#-#TimeFormat(dateAdd("s", +1, userReception.rp_endtime_default[i]), "HH:mm")#','/?page=cabinet&section=reception&action=view&rpid=#userReception.rp_id[i]#','#patient#','#dms#');
									
												}
											}

											_end_time = DateAdd("h", -8, "#userGraphic.gr_endtime#");
											_minutes = hour(_end_time)*60 + minute(_end_time);
											_block1(_minutes,720,'end','К-#TimeFormat(userGraphic.gr_endtime, "HH:mm")#','','','');

											instance.mass1 = normalMassive(instance.mass1, arguments.userid, dateFormat(_Date,"YYYY.MM.DD") );

											view &= '';
											for ( var y=1; y<=arrayLen(instance.mass1); y++){
								
												lenght = instance.mass1[y].end - instance.mass1[y].start;
												persent = lenght;
												//writeDump(persent);
												if (instance.mass1[y].type == 'start'){
													view &= '<span class="spanStart" style="height:#persent#px;" title="#instance.mass1[y].info#">&nbsp;</span>';
												}else if(instance.mass1[y].type == 'none'){
													view &= '<a href="#instance.mass1[y].link#"><span class="spanNone" style="height:#persent#px;" title="#instance.mass1[y].info#">-&nbsp;</span></a>';
												}else if(instance.mass1[y].type == 'service1'){
													if (instance.mass1[y].patient is ''){
														class = 'spanService';
													}else{
														if ( instance.mass1[y].dms is ''){
															class = 'spanService1';
														}else{
															class = 'spanService1dms';
														}
													}
													view &= '<a href="#instance.mass1[y].link#"><span class="#class#" style="height:#persent#px;" title="#instance.mass1[y].patient# #instance.mass1[y].info#">#instance.mass1[y].info#<br>#instance.mass1[y].patient#</span></a>';
												}else if(instance.mass1[y].type == 'service2'){
													if (instance.mass1[y].patient is ''){
														class = 'spanService';
													}else{
														if ( instance.mass1[y].dms is ''){
															class = 'spanService2';
														}else{
															class = 'spanService2dms';
														}
													}
													view &= '<a href="#instance.mass1[y].link#"><span class="#class#" style="height:#persent#px;" title="#instance.mass1[y].patient# #instance.mass1[y].info#">#instance.mass1[y].info#<br>#instance.mass1[y].patient#</span></a>';
												}else if(instance.mass1[y].type == 'service3'){
													if (instance.mass1[y].patient is ''){
														class = 'spanService';
													}else{
														if ( instance.mass1[y].dms is ''){
															class = 'spanService3';
														}else{
															class = 'spanService3dms';
														}
													}
													view &= '<a href="#instance.mass1[y].link#"><span class="#class#" style="height:#persent#px;" title="#instance.mass1[y].patient# #instance.mass1[y].info#">#instance.mass1[y].info#<br>#instance.mass1[y].patient#</span></a>';

												}else if(instance.mass1[y].type == 'end'){
													view &= '<span class="spanEnd" style="height:#persent#px;" title="#instance.mass1[y].info#">&nbsp;</span>';
												}else{
													color = 'grey';
													view &= '<span style="background: #color#; height:#persent#px; width: 100%; display:block;" title="#instance.mass1[y].info#">-&nbsp;</span>';
												}
											}
											view &= '';


											}else if (userGraphic.gr_type == 2){
												view &= 'Выходной день.';

											}else if (userGraphic.gr_type == 3){
												view &= 'В отпуске.';

											}else if (userGraphic.gr_type == 4){
												view &= 'На больничном.';
											}

										}else{
											view &= '<font color="red">расписание не задано</font>';
										}

										if (userGraphic.gr_type == 1){
											//view &= '<a href="/?page=reception&section=reception&action=add&userid=#arguments.userid#&date=#dateFormat(currentDate,"YYYY.MM.DD")#">записать</a>';
										}else{
											//view &= '&nbsp;записать';
										}
									view &= '</td>';

					                        }
								//////////////////////////////////////////////////////////////
							}
					view &= '</tr>';
				}



			view &= '</table>';

		view &= '</div></div>';

		return view;

	}



	function View() {
		return instance.view;
  	}

	function normalMassive(mass,userID,date){
		massive = arguments.mass;
		//for (var i=1; i<=arrayLen(massive); i++ ){
		//	type = massive[i].type;
		//	if (type == 'delete'){
		//		arrayDeleteAt(massive,i);
		//		i = i-1;
		//	}
		//}

		for (var i=1; i<=arrayLen(massive)-1; i++ ){
			end = massive[i].end;
			//writeDump(end);
			x=i+1;
			start = massive[x].start;
			//writeDump(start);
			lenght=start-end;
			if (end NEQ start AND lenght > 30){
				//lenght = lenght/30;
				//writeDump(lenght);
				s = end;
				e = start;
				l = lenght;
				col = l\30;
				ostatok = l MOD 30;
				//writedump(col);
				for (y=1; y<=col; y++){
					span = structNew();
					span.start = s;
					span.end = s+30;
					s=s+30;
					span.type = 'none';
					span.info = '#TimeFormat(DateAdd("n", span.start, "08:00"), "HH:mm")#-#TimeFormat(DateAdd("n", span.end, "08:00"), "HH:mm")#';
					// #TimeFormat(span.start, "HH:mm")#-#TimeFormat(span.end, "HH:mm")#
					span.patient = '';
					span.dms = '';
					span.link = '/?page=cabinet&section=reception&action=add&userid=#arguments.userID#&date=#arguments.date#&starttime=#TimeFormat( DateAdd("n", span.start, "08:00"), "HH:mm")#';
					arrayInsertAt(massive,x+y-1,span);
					i=i+1;
				}
				if (ostatok NEQ 0){
					span = structNew();
					span.start = s;
					span.end = s+ostatok;
					span.type = 'none';
					span.info = '#TimeFormat(DateAdd("n", s, "08:00"), "HH:mm")#-#TimeFormat(DateAdd("n", s+ostatok, "08:00"), "HH:mm")#';
					span.patient = '';
					span.dms = '';
					span.link = '/?page=cabinet&section=reception&action=add&userid=#arguments.userID#&date=#arguments.date#&starttime=#TimeFormat( DateAdd("n", span.start, "08:00"), "HH:mm")#';
					arrayInsertAt(massive,x+y-1,span);
					i=i+1;
				}
			} else if (end NEQ start AND lenght <= 30){
				//
				span = structNew();
				span.start = end;
				span.end = start;
				span.type = 'none';
				span.info = '#TimeFormat(DateAdd("n", span.start, "08:00"), "HH:mm")#-#TimeFormat(DateAdd("n", span.end, "08:00"), "HH:mm")#';
				span.patient = '';
				span.dms = '';
				span.link = '/?page=cabinet&section=reception&action=add&userid=#arguments.userID#&date=#arguments.date#&starttime=#TimeFormat( DateAdd("n", span.start, "08:00"), "HH:mm")#';
				arrayInsertAt(massive,x,span);
				//arrayInsertAt(massive,x+y-1,span);
				i=i+1;
			}
		}
		return massive;
	}

	function _block1(start,end,type,info,link,patient,dms){

		span = structNew();
		span.start = arguments.start;
		span.end = arguments.end;
		span.type = arguments.type;
		span.info = arguments.info;
		span.link = arguments.link;
		span.patient = arguments.patient;
		span.dms = arguments.dms;
		//arrayInsertAt(massive,x,span);
		arrayAppend(instance.mass1,span);

	}

	function status(status){
		status = arguments.status;
		if ( status == 1 ){
			return 'Приём не начался.';

		}else if ( status == 2 ){
			return 'Идёт приём.';

		}else if ( status == 3 ){
			return 'Приём окончен.';

		}

	}

	private function editeDocumentServiceHandler(rpID,svID){

		var qRServices = factoryService.getService('userServicesAPI').getReceptionService(arguments.svID);
		shablonDoc = qRServices.pls_shablon;
		shablonDocStruct = DeserializeJSON(shablonDoc);

		// --- обработчик формы---
		if ( isdefined('form.updateDoc') ){

			for (var i=1; i<=arrayLen(shablonDocStruct); i++){
				if ( structKeyExists(form, '#shablonDocStruct[i].name#')  ){
					shablonNew[i] = structNew();
					shablonNew[i].name = shablonDocStruct[i].name;
					shablonNew[i].data = StructFind(form,shablonDocStruct[i].name);
					shablonNew[i].pos = shablonDocStruct[i].pos;
				}
			}
			
			//writeDump(serializeJSON(shablonNew));
		
		var userServicesAPI = factoryService.getService('userServicesAPI');
		 result = userServicesAPI.editeReceptionService( arguments.rpID, arguments.svID, shablonNew );
			//writeDump(result);
			if ( result.RETVAL is 1 ){
				factoryService.getService('redirector').redirect('#request.CRequest.updateURL(false,"/?page=cabinet&section=reception&action=view&rpid=#qRServices.rp_id#")#');
			}else{
				// --- пробная версия
				if ( result.RETDESC is '') {
					instance.message = '';
				} else {
					instance.message = '#result.RETDESC#';
				}

				for (key in result.struct){
					if (StructKeyExists(result.STRUCT, '#key#')) {
						instance[key] = result.STRUCT['#key#'];
					} else {
						instance[key] = '';
					}
				}
			}
		
		}
		
		// --- обработчик формы---

	}

	function editeDocumentService(rpid,svid){

		// get rpID and svID
		var userReception = factoryService.getService('userReceptionAPI').getReception( arguments.rpID );
		//writeDump(userReception);
		// доктор
		var qUser = factoryService.getService( 'authorization' ).getUser( userReception.user_id );
		//writeDump(qUser);

		// пациент
		patientid = userReception.pt_id;
		factoryService.getService('patientsAPI').setPatient(patientid);
		patient = factoryService.getService('patientsAPI').getPatient();
		//writeDump(patient);

		var qRServices = factoryService.getService('userServicesAPI').getReceptionService(arguments.svID);
		//writeDump(qRServices);
		shablonDoc = qRServices.pls_shablon;
		//writeDump(shablonDoc);
		shablonDocStruct = DeserializeJSON(shablonDoc);

		view = '';
		view &= '<div class="grid_16">
				<div class="signin-box">';
		view &= '<div id="popup">
				<div id="popup_close"></div>
				<div id="popup_mes"></div>
			</div>';
		view &= '<div id="overlay"></div>';
		view &= '<form id="editeDoc" action="" method="post">';
		view &= '<p><a class="g-button g-button-submit" href="#request.CRequest.updateURL(false,"/?page=cabinet&section=reception&action=view&rpid=#arguments.rpID#")#">Назад</a></p>';
		view &= '<h2>#qRServices.sv_name#</h2><br>';
		view &= '<p><b>Пациент:</b> #patient.pt_family# #patient.pt_firstname# #patient.pt_lastname#</p>';
		view &= '<p><b>АНАМНЕЗ ЖИЗНИ:</b><br>';
		if ( patient.pt_anamnez != '' ){
			anamnez = DeserializeJSON( patient.pt_anamnez );
			for (var i=1; i<=arrayLen(anamnez); i++){
				if ( anamnez[i].data != '' ){
					view &= '<b>#anamnez[i].name#: </b>';
					view &= '#anamnez[i].data#';
					view &= '<br>';
				}
			}
        	}else{
			view &= 'нет данных <br>';
		}
		view &= '</p>';

		view &= '<input type="hidden" id="userid" name="userid" value="#qUser.user_id#" maxlength="20" size="20">';
		for (var i=1; i<=arrayLen(shablonDocStruct); i++){
			if( isStruct(shablonDocStruct[i]) ){
				param name='form[shablonDocStruct[i].name]' default='#shablonDocStruct[i].data#';
				param name='instance[shablonDocStruct[i].name]' default = '';
			}else{
				param name='form[shablonDocStruct[i].name]' default='';
				param name='instance[shablonDocStruct[i].name]' default = '';
			}
		}

		for (var i=1; i<=arrayLen(shablonDocStruct); i++){
			view &= '<input type="hidden" id="phKey_#i#" name="phKey" value="#shablonDocStruct[i].name#">';
			view &= '<div ><span style="display:inline-block; vertical-align: middle;"><b>#shablonDocStruct[i].name#:</b><br>';
			view &= '<textarea id="OutPut_#i#" name = "#shablonDocStruct[i].name#" rows="6" cols="50" >#form[shablonDocStruct[i].name]#</textarea>';
			if (instance[shablonDocStruct[i].name] is not ''){
				view &= '<label for="#shablonDocStruct[i].name#" class="error" generated="2">#instance[shablonDocStruct[i].name]#</label>';
			}
			view &= '</span>';
			view &= '<span style="display:inline-block; vertical-align: middle;"><input id="TextInsert_#i#" type="button" name="TextInsert_#i#" value="<<"></span>';

			qPhrases = factoryService.getService('phrasesAPI').getPhrases(#userReception.user_id#,'#shablonDocStruct[i].name#');
			//writeDump(qPhrases);

			view &= '<span style="display:inline-block; vertical-align: top;">
					<b>ВАРИАНТЫ:</b><br>
					<select class="select1" id="TextSelect_#i#" name="words" multiple>';

					for (var x=1; x<=qPhrases.recordcount; x++){
						view &= "<option title='#qPhrases.ph_value[x]#' value='#qPhrases.ph_value[x]#'>#qPhrases.ph_value[x]#</option>";
					}

			view &= '	</select><br>
					<input type="hidden" id="userid" name="userid" value="#qUser.user_id#" maxlength="20" size="20">
					<input id="phraseKey_#i#" value="" name="phraseKey_#i#" size="53" >
					<input id="addKey_#i#" type="button" value="+" name="+">
					<input id="deleteKey_#i#" type="button" value="-" name="-">
				</span></div>';
		}

		if (instance.rpStatus is not ''){
			view &= '<p><label for="rpStatus" class="error" generated="2">#instance.rpStatus#</label></p>';
		}

		if (instance.RBAC is not ''){
			view &= '<p><label for="RBAC" class="error" generated="2">#instance.RBAC#</label></p>';
		}

		view &= '<hr>
			<input disabled class="g-button g-button-submit" type="submit" name="escape" value="Отмена">
			<input class="g-button g-button-submit" type="submit" name="updateDoc" value="Сохранить"> ';

		view &= '	</div>
			</div>';

		view &= '</form>';

		return view;
	}

	function document(svID){
		return factoryService.getService('pdf').documentPdf(arguments.svID);
	}

	function document1(svID){
		return factoryService.getService('pdf').documentPdf1(arguments.svID);
	}

	function editeReceptionServiceHandler(svid){
		if ( isdefined('form.updateService') ){
			//
		//------------------------------------------
		qReception = factoryService.getService('userReceptionAPI').getReception(form.rp_id);
		qUser = factoryService.getService( 'authorization' ).getUser( qReception.user_id );
		usersInterest = factoryService.getService('usersInterestAPI');
		UI = usersInterest.getUserInterest( qUser.user_id, form.st_id );
		if ( UI.recordcount ){
			if ( UI.ui_type == 1 ){
				userInterest = round(form.sv_price/100 * UI.ui_value);
			}else if( UI.ui_type == 0 ){
				userInterest = UI.ui_value;
			}
		}else{
			userInterest = 0;
		}
		//------------------------------------------

			var userServices = factoryService.getService('userServicesAPI');
			  result = userServices.editeReceptionServicePrice( #form.sv_id#, #form.sv_price#, #form.pls_price_ot#, #form.pls_price_do#, userInterest );
			if ( result.RETVAL is 1 ){
				factoryService.getService('redirector').redirect('#request.CRequest.updateURL(false,"/?page=cabinet&section=reception&action=view&rpid=#form.rp_id#")#');
			}else{
				if ( result.RETDESC is '') {
					instance.message = '';
				} else {
					instance.message = '#result.RETDESC#';
				}
				if (StructKeyExists(result.STRUCT, 'svStatus')) {
					instance.svStatus = result.STRUCT['svStatus'];
				} else {
					instance.svStatus = '';
				}
				if (StructKeyExists(result.STRUCT, 'svPrice')) {
					instance.svPrice = result.STRUCT['svPrice'];
				} else {
					instance.svPrice = '';
				}
			}
		}
	}

	function editeReceptionService(svid){

		qService = factoryService.getService( 'userServicesAPI' ).getReceptionService( arguments.svid );
		qPlsService = factoryService.getService('servicesAPI').getService(qService.pls_id);

		//writeDump(qService);
		//writeDump(qPlsService);

		param name='form.sv_id' default='#qService.sv_id#';
		param name='form.st_id' default='#qService.st_id#';
		param name='form.sv_name' default='#qService.sv_name#';
		param name='form.sv_price' default='#qService.sv_price#';
		param name='form.rp_id' default='#qService.rp_id#';
		param name='form.pls_price_ot' default='#qPlsService.pls_price_ot#';
		param name='form.pls_price_do' default='#qPlsService.pls_price_do#';

		var view = '';
		view &= '
			<form name="" id="" action="#request.CRequest.updateURL(false,"/?page=cabinet&section=service&action=edite&svid=#arguments.svid#")#" method="post">
			<div class="grid_8"><div class="signin-box">
				<a class="g-button g-button-submit" href="#request.CRequest.updateURL(false,"/?page=cabinet&section=reception&action=view&rpid=#qService.rp_id#")#">Назад</a><br><br>
				<h2>Редактирование услуги</h2><hr>
				<div>
					<label for="sv_id"><b>ID услуги:</b> #form.sv_id#</label>
					<input type="hidden" name="sv_id" value="#form.sv_id#" size = "2" maxlength = "2">
					<input type="hidden" name="st_id" value="#form.st_id#" size = "2" maxlength = "2">
					<input type="hidden" name="rp_id" value="#form.rp_id#" size = "2" maxlength = "2">
				</div>
				<div>
					<label for="sv_name"><b>Наименование услуги:</b> #form.sv_name#</label>';

			view &='</div>
				<div>
					<label for="sv_price"><b>Цена услуги:</b></label>
					<input type="text" name="sv_price" value="#form.sv_price#" size = "5" maxlength = "10">
					<input type="hidden" name="pls_price_ot" value="#form.pls_price_ot#" size = "2" maxlength = "2">
					<input type="hidden" name="pls_price_do" value="#form.pls_price_do#" size = "2" maxlength = "2">
					<span>Для данной услуги определён диапазон цен (от <b>#LSCurrencyFormat(qPlsService.pls_price_ot)#</b> до <b>#LSCurrencyFormat(qPlsService.pls_price_do)#</b>)</span>';

			if (instance.svPrice is not ''){
				view &= '<label for="sv_price" class="error" generated="0">#instance.svPrice#</label>';
			}

			view &= '</div>
				<div><hr>
					<input disabled class="g-button g-button-submit" type="submit" name="escape" value="Отмена">
					<input class="g-button g-button-submit" type="submit" name="updateService" value="Сохранить">
				</div>';

			if (instance.message is not ''){
				view &= '<div id="mes" style="color:red;">#instance.message#</div>';
			}
			if (instance.svStatus is not ''){
				view &= '<div id="mes" style="color:red;">#instance.svStatus#</div>';
			}

			view &= '
			</div></div>';

		return view;

	}

}