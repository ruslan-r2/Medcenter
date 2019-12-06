/* 
	Виджет список пациентов --
*/

component attributeName='userlist' output='false'{
	// псевдо конструктор
	factoryService = request.factoryService;

	instance.view = '';

	instance.patientFamily = '';
	instance.patientFirstname = '';
	instance.patientLastname = '';
	instance.patientGender = '';
	instance.patientDob = '';
	instance.patientStatus = '';
	instance.chPatient = '';

	instance.ctID = '';
	instance.ptcData = '';
	instance.ptcDescription = '';
	instance.ptcStatus = '';

	instance.ptID = '';
	instance.ptdDocument = '';
	instance.ptdNumber = '';
	instance.ptdNumber1 = '';
	instance.ptdIssued = '';
	instance.ptdDate = '';
	instance.ptdSc = '';
	instance.ptdSc1 = '';
	instance.ptdStatus = '';

	instance.ptaID = '';
	instance.ptaType = '';
	instance.ptaFirmData = '';
	instance.ptaCountry = '';
	instance.ptaRegion = '';
	instance.ptaCity = '';
	instance.ptaLocality = '';
	instance.ptaStreet = '';
	instance.ptaIndex = '';
	instance.ptaHouse = '';
	instance.ptaBuilding = '';
	instance.ptaFlat = '';
	instance.ptaDescription = '';
	instance.ptaStatus = '';

	instance.ptdmsID = '';
	instance.cdmsID = '';
	instance.ptdmsPolisNumber = '';
	instance.ptdmsDescription = '';
	instance.ptdmsStatus = '';

	instance.message = '';


	function Init(string section, string action) {
		section = arguments.section;
		action = arguments.action;

		if (section == 'false'){
			sortby = request.CRequest.getUrl('sortby');
			patientsListFormHandler(sortby);
			instance.view = patientsListForm();

		}else if( section == 'patient' ){
			if (action == 'view'){
				patientid = request.CRequest.getUrl('patientid');
				instance.view = viewPatientForm(patientid);
			}else if( action == 'add' ){
				addPatientFormHandler();
				instance.view = addPatientForm();

			}else if( action == 'edite' ){
				patientid = request.CRequest.getUrl('patientid');
				updatePatientFormHandler(); 
				instance.view = updatePatientForm(patientid);

			}else if( action == 'delete'){
				instance.view = 'delete group';

			}
		}else if( section == 'contact'){
			if (action == 'view'){
				//patientid = request.CRequest.getUrl('patientid');
				instance.view = 'viewContactForm(patientid)';
			}else if( action == 'add' ){
				patientid = request.CRequest.getUrl('patientid');
				addContactFormHandler();
				instance.view = addContactForm(patientid);

			}else if( action == 'edite' ){
				ptcid = request.CRequest.getUrl('ptcid');
				updateContactFormHandler();
				instance.view = updateContactForm(ptcid);

			}else if( action == 'delete'){
				instance.view = 'delete contact';

			}

		}else if(section == 'document'){
			if (action == 'add' ){
				patientid = request.CRequest.getUrl('patientid');
				addDocumentFormHandler();
				instance.view = addDocumentForm(patientid);

			}else if (action == 'edite'){
				ptdID = request.CRequest.getUrl('ptdID');
				updateDocumentFormHandler();
				instance.view = updateDocumentForm(ptdID);

			}else if (action == 'delete'){
				instance.view = 'deleteDocument';

			}

		}else if(section == 'dms'){
			if (action == 'add' ){
				patientid = request.CRequest.getUrl('patientid');
				addDMSFormHandler();
				instance.view = addDMSForm(patientid);

			}else if (action == 'edite'){
				ptdmsID = request.CRequest.getUrl('ptdmsID');
				updateDMSFormHandler();
				instance.view = updateDMSForm(ptdmsID);

			}else if (action == 'delete'){
				instance.view = 'deleteDMS';

			}

		}else if(section == 'address'){
			if (action == 'add' ){
				patientid = request.CRequest.getUrl('patientid');
				addAddressFormHandler();
				instance.view = addAddressForm(patientid);
			}else if (action == 'edite'){
				ptaID = request.CRequest.getUrl('ptaID');
				updateAddressFormHandler();
				instance.view = updateAddressForm(ptaID);
			}else if (action == 'delete'){
				instance.view = 'deleteAddress';
			}
			//patientid = request.CRequest.getUrl('patientid');
			//instance.view = document(patientid);

		}else if(section == 'anamnez'){
			if (action == 'edite'){
				rbac = request.RBAC;
				if ( rbac.CheckAccess('anamnez','read') ){
					patientid = request.CRequest.getUrl('patientid');
					updateAnamnezFormHandler();
					instance.view = updateAnamnezForm(patientid);
				}else{
					instance.view = 'Доступ закрыт!';
				}
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

	function _DateFormate(date){
		date = arguments.date;

		myYear = Year(date);
		myMonth = MonthAsString(Month(date));
		myDay = Day(date);

		return '#myDay# #myMonth# #myYear#';

	}

	function phoneFormat(phone){

		phone = arguments.phone;
		areacode = left(phone,3);
		firstthree = mid(phone,4,3);
		lastfour = right(phone,4);

		return '(#areacode#) #firstthree#-#lastfour#';

	}


	private function addPatientFormHandler(){
		// --- обработчик формы---
		if ( isdefined('form.addPatient') ){

		// собрать дату из формы
		form.pt_dob = '#form.pt_dobYear#-#form.pt_dobMonth#-#form.pt_dobDay#';
		var patientsAPI = factoryService.getService('patientsAPI');
		  result = patientsAPI.addPatient( #form.pt_family#, #form.pt_firstname#, #form.pt_lastname#, #form.pt_gender#, #form.pt_dob#, #form.pt_status# );
			//writeDump(form);
			//result.RETVAL = 1;
			if ( result.RETVAL is 1 ){
				factoryService.getService('redirector').redirect('#request.CRequest.updateURL(false,"/?page=patients&section=patient&action=view&patientid=#result.RETDESC#")#');
			}else{
				// --- пробная версия
				if ( result.RETDESC is '') {
					instance.message = '';
				} else {
					instance.message = '#result.RETDESC#';
				}


				if (StructKeyExists(result.STRUCT, 'patientFamily')) {
					instance.patientFamily = result.STRUCT['patientFamily'];
				} else {
					instance.patientFamily = '';
				}
				if (StructKeyExists(result.STRUCT, 'patientFirstname')) {
					instance.patientFirstname = result.STRUCT['patientFirstname'];
				} else {
					instance.patientFirstname = '';
				}
				if (StructKeyExists(result.STRUCT, 'patientLastname')) {
					instance.patientLastname = result.STRUCT['patientLastname'];
				} else {
					instance.patientLastname = '';
				}

				if (StructKeyExists(result.STRUCT, 'patientGender')) {
					instance.patientGender = result.STRUCT['patientGender'];
				} else {
					instance.patientGender = '';
				}
				if (StructKeyExists(result.STRUCT, 'patientDoB')) {
					instance.patientDoB = result.STRUCT['patientDoB'];
				} else {
					instance.patientDoB = '';
				}

				if (StructKeyExists(result.STRUCT, 'patientStatus')) {
					instance.patientStatus = result.STRUCT['patientStatus'];
				} else {
					instance.patientStatus = '';
				}

				if (StructKeyExists(result.STRUCT, 'chPatient')) {
					instance.chPatient = result.STRUCT['chPatient'];
				} else {
					instance.chPatient = '';
				}


			}
		}
		// --- обработчик формы---
	}

	function addPatientForm(){
		param name='form.pt_family' default='';		// фамилия
		param name='form.pt_firstname' default='';	// Имя
		param name='form.pt_lastname' default='';	// Отчество
		param name='form.pt_gender' default='';
		param name='form.pt_dob' default='';
		param name='form.pt_dobYear' default='';
		param name='form.pt_dobMonth' default='';
		param name='form.pt_dobDay' default='';
		param name='form.pt_status' default='1';

		// ---------------------------------------------------------- форма ---------------------------------------------------------------
		action = '#request.CRequest.updateURL(false,"/?page=patients&section=patient&action=add")#';

		view = '';
		view &= '<div class="grid_8">
			<div class="signin-box">
			<a class="g-button g-button-submit" href="#request.CRequest.updateURL(false,"/?page=patients")#">Назад</a><br><br>
			<h2>Добавление нового пациента:</h2>
			<form id="addpatient" name="addpatient" action="#action#" method="post">
				<div>
					<label for="ptFamily"><strong>Фамилия</strong></label>
					<input type="text" id="ptFamily" name="pt_family" value="#form.pt_family#" maxlength="50" size="20">';

		if (instance.patientFamily is not ''){
		view &= '		<label for="ptFamily" class="error" generated="0">#instance.patientFamily#</label>';
		}

		view &= '	</div>
				<div>
					<label><strong>Имя</strong></label>
					<input type="text" id="ptFirstname" name="pt_firstname" value="#form.pt_firstname#" maxlength="50" size="20">';
   		if (instance.patientFirstname is not ''){
		view &= '		<label for="ptFirstname" class="error" generated="1">#instance.patientFirstname#</label>';
		}

		view &= '	</div>
				<div>
					<label>Отчество:</label>
					<input type="text" id="ptLastname" name="pt_lastname" value="#form.pt_lastname#" maxlength="50" size="20">';
   		if (instance.patientLastname is not ''){
		view &= '		<label for="ptLastname" class="error" generated="2">#instance.patientLastname#</label>';
		}


		view &= '	</div>
				<div>
					<label for="pt_gender"><b>Пол пациента:</b></label>
					<select name="pt_gender">
						<option value="Мужской" #checkedSelect("Мужской", form.pt_gender)# >Мужской</option>
						<option value="Женский" #checkedSelect("Женский", form.pt_gender)# >Женский</option>
					</select>
				';

		if (instance.patientGender is not ''){
		view &= '		<label for="pt_gender" class="error" generated="0">#instance.patientGender#</label>';
		}

		view &= '	</div>
				<div>
					<label for="pt_dob"><b>Дата рождения:</b></label>

					<label for="pt_dobDay">День:</label>
					<input type="text" id="ptDobDay" name="pt_dobDay" value="#form.pt_dobDay#" maxlength="2" size="2">
					<label for="pt_dobMonth">Месяц:</label>
					<input type="text" id="ptDobMonth" name="pt_dobMonth" value="#form.pt_dobMonth#" maxlength="2" size="2">
					<label for="pt_dobYear">Год:</label>
					<input type="text" id="ptDobYear" name="pt_dobYear" value="#form.pt_dobYear#" maxlength="4" size="4">
				';

		if (instance.patientDob is not ''){
		view &= '		<label for="pt_dob" class="error" generated="0">#instance.patientDob#</label>';
		}

		view &= '	</div><div>
				<input type="hidden" name="pt_status" value="#form.pt_status#" size = "2" maxlength = "2">
				<hr>
				<input disabled class="g-button g-button-submit" type="submit" name="escape" value="Отмена">
				<input class="g-button g-button-submit" type="submit" name="addPatient" value="Сохранить"> ';

		if (instance.chPatient is not ''){
			view &= '<div id="mes" style="color:red;">#instance.chPatient#</div>';
		}

		if (instance.message is not ''){
			view &= '<div id="mes" style="color:red;">#instance.message#</div>';
		}

		view &='</div></form>
			</div></div>';

			// ------------------------------------------------ форма ---------------------------------------------------------------
		return view;
	}

	private function updatePatientFormHandler(){
		// --- обработчик формы---
		if ( isdefined('form.updatePatient') ){

		// собрать дату из формы
		form.pt_dob = '#form.pt_dobYear#-#form.pt_dobMonth#-#form.pt_dobDay#';
		var patientsAPI = factoryService.getService('patientsAPI');
		  result = patientsAPI.editePatient( #form.pt_id#, #form.pt_family#, #form.pt_firstname#, #form.pt_lastname#, #form.pt_gender#, #form.pt_dob#, #form.pt_status# );
			//writeDump(form);
			//result.RETVAL = 1;
			if ( result.RETVAL is 1 ){
				if ( result.RETDESC is '') {
					instance.message = '';
				} else {
					instance.message = '#result.RETDESC#';
				}

			}else{
				// --- пробная версия
				if ( result.RETDESC is '') {
					instance.message = '';
				} else {
					instance.message = '#result.RETDESC#';
				}


				if (StructKeyExists(result.STRUCT, 'patientFamily')) {
					instance.patientFamily = result.STRUCT['patientFamily'];
				} else {
					instance.patientFamily = '';
				}
				if (StructKeyExists(result.STRUCT, 'patientFirstname')) {
					instance.patientFirstname = result.STRUCT['patientFirstname'];
				} else {
					instance.patientFirstname = '';
				}
				if (StructKeyExists(result.STRUCT, 'patientLastname')) {
					instance.patientLastname = result.STRUCT['patientLastname'];
				} else {
					instance.patientLastname = '';
				}

				if (StructKeyExists(result.STRUCT, 'patientGender')) {
					instance.patientGender = result.STRUCT['patientGender'];
				} else {
					instance.patientGender = '';
				}
				if (StructKeyExists(result.STRUCT, 'patientDoB')) {
					instance.patientDoB = result.STRUCT['patientDoB'];
				} else {
					instance.patientDoB = '';
				}

				if (StructKeyExists(result.STRUCT, 'patientStatus')) {
					instance.patientStatus = result.STRUCT['patientStatus'];
				} else {
					instance.patientStatus = '';
				}

				if (StructKeyExists(result.STRUCT, 'chPatient')) {
					instance.chPatient = result.STRUCT['chPatient'];
				} else {
					instance.chPatient = '';
				}

			}
		}
		// --- обработчик формы---
	}

	function updatePatientForm(patientid){

		factoryService.getService( 'patientsAPI' ).setPatient( arguments.patientid );
		patient = factoryService.getService( 'patientsAPI' ).getPatient();

		param name='form.pt_id' default='#patient.pt_id#';
		param name='form.pt_family' default='#patient.pt_family#';		// фамилия
		param name='form.pt_firstname' default='#patient.pt_firstname#';	// Имя
		param name='form.pt_lastname' default='#patient.pt_lastname#';	// Отчество
		param name='form.pt_gender' default='#patient.pt_gender#';
		param name='form.pt_dob' default='#patient.pt_dob#';
		param name='form.pt_dobYear' default='#year(patient.pt_dob)#';
		param name='form.pt_dobMonth' default='#month(patient.pt_dob)#';
		param name='form.pt_dobDay' default='#day(patient.pt_dob)#';
		param name='form.pt_status' default='#patient.pt_status#';

		// ---------------------------------------------------------- форма ---------------------------------------------------------------
		action = '#request.CRequest.updateURL(false,"/?page=patients&section=patient&action=edite&patientid=#arguments.patientid#")#';

		view = '';
		view &= '<div class="grid_8">
			<div class="signin-box">
			<a class="g-button g-button-submit" href="#request.CRequest.updateURL(false,"/?page=patients")#">Назад</a><br><br>
			<h2>Редактирование пациента:</h2>
			<form id="addpatient" name="addpatient" action="#action#" method="post">
				<div>
					<label for="pt_id"><b>ID пациента:</b></label>
					<input disabled type="text" name="_pt_id" value="#form.pt_id#" size = "2" maxlength = "2">
					<input type="hidden" name="pt_id" value="#form.pt_id#" size = "2" maxlength = "2">
				</div>
				<div>
					<label for="ptFamily"><strong>Фамилия</strong></label>
					<input type="text" id="ptFamily" name="pt_family" value="#form.pt_family#" maxlength="50" size="20">';

		if (instance.patientFamily is not ''){
		view &= '		<label for="ptFamily" class="error" generated="0">#instance.patientFamily#</label>';
		}

		view &= '	</div>
				<div>
					<label><strong>Имя</strong></label>
					<input type="text" id="ptFirstname" name="pt_firstname" value="#form.pt_firstname#" maxlength="50" size="20">';
   		if (instance.patientFirstname is not ''){
		view &= '		<label for="ptFirstname" class="error" generated="1">#instance.patientFirstname#</label>';
		}

		view &= '	</div>
				<div>
					<label>Отчество:</label>
					<input type="text" id="ptLastname" name="pt_lastname" value="#form.pt_lastname#" maxlength="50" size="20">';
   		if (instance.patientLastname is not ''){
		view &= '		<label for="ptLastname" class="error" generated="2">#instance.patientLastname#</label>';
		}


		view &= '	</div>
				<div>
					<label for="pt_gender"><b>Пол пациента:</b></label>
					<select name="pt_gender">
						<option value="Мужской" #checkedSelect("Мужской", form.pt_gender)# >Мужской</option>
						<option value="Женский" #checkedSelect("Женский", form.pt_gender)# >Женский</option>
					</select>
				';

		if (instance.patientGender is not ''){
		view &= '		<label for="pt_gender" class="error" generated="0">#instance.patientGender#</label>';
		}

		view &= '	</div>
				<div>
					<label for="pt_dob"><b>Дата рождения:</b></label>
					<label for="pt_dobDay">День:</label>
					<input type="text" id="ptDobDay" name="pt_dobDay" value="#form.pt_dobDay#" maxlength="2" size="2">
					<label for="pt_dobMonth">Месяц:</label>
					<input type="text" id="ptDobMonth" name="pt_dobMonth" value="#form.pt_dobMonth#" maxlength="2" size="2">
					<label for="pt_dobYear">Год:</label>
					<input type="text" id="ptDobYear" name="pt_dobYear" value="#form.pt_dobYear#" maxlength="4" size="4">
				';

		if (instance.patientDob is not ''){
		view &= '		<label for="pt_dob" class="error" generated="0">#instance.patientDob#</label>';
		}

		view &= '	</div><div>
				<input type="hidden" name="pt_status" value="#form.pt_status#" size = "2" maxlength = "2">
				<hr>
				<input disabled class="g-button g-button-submit" type="submit" name="escape" value="Отмена">
				<input class="g-button g-button-submit" type="submit" name="updatePatient" value="Сохранить"> ';

		if (instance.chPatient is not ''){
			view &= '<div id="mes" style="color:red;">#instance.chPatient#</div>';
		}

		if (instance.message is not ''){
			view &= '<div id="mes" style="color:red;">#instance.message#</div>';
		}

		view &='</div></form>
			</div></div>';

			// ------------------------------------------------ форма ---------------------------------------------------------------
		return view;
	}

	private function viewPatientFormHandler(){
	}

	function viewPatientForm(patientid){

		patientid = arguments.patientid;
		factoryService.getService('patientsAPI').setPatient(patientid);
		patient = factoryService.getService('patientsAPI').getPatient();
		//writeDump(patient);
		factoryService.getService('patientsAPI').setPatientDocuments(patientid);
		patient_doc = factoryService.getService('patientsAPI').getPatientDocuments();
		//writeDump(patient_doc);
		factoryService.getService('patientsAPI').setPatientAddresses(patientid);
		patient_add = factoryService.getService('patientsAPI').getPatientAddresses();
		//writeDump(patient_add);
		factoryService.getService('patientsAPI').setPatientContacts(patientid);
		patient_cnt = factoryService.getService('patientsAPI').getPatientContacts();
		//writeDump(patient_cnt);
		patient_reception = factoryService.getService('patientsAPI').getPatientReception(patientid);
		//writeDump(patient_reception);
		patient_dms = factoryService.getService('patientsAPI').getPatientDms('',patientid);
		//writeDump(patient_dms);

		var view = '';
		view &= '<div class="grid_8"><div class="signin-box">
				<div> <a class="g-button g-button-submit" href="#request.CRequest.updateURL(false,"/?page=patients")#">Назад</a></div>
				<h2>Пациент: #patient.pt_family#</b> #patient.pt_firstname# #patient.pt_lastname# </h2>
				<fieldset>
					<legend>Основная информация</legend>
					<p>
					Пол: <b>#patient.pt_gender#</b><br>
					Дата рождения: <b>#_DateFormate(patient.pt_dob)#</b><br>
					Дата добавления: <b>#_DateFormate(patient.pt_dateadd)#</b><br>
					<a href="/?page=patients&section=patient&action=edite&patientid=#patient.pt_id#">Редактировать</a>
					</p>
				</fieldset>

				<fieldset>
					<legend>Контакты:</legend>';

					if (patient_cnt.recordcount == 0){
						view &= '<font color="red">Нет контактных данных.</font><br>';
					}else{
						for (var x=1; x<=patient_cnt.recordcount; x++ ){
							view &= '#patient_cnt.cnt_type_description[x]#: <b>#patient_cnt.ptc_data[x]#</b> 
								<a href="/?page=patients&section=contact&action=edite&ptcid=#patient_cnt.ptc_id[x]#">Редактировать</a> | 
								<a href="/?page=patients&section=contact&action=delete&ptcid=#patient_cnt.ptc_id[x]#">Удалить</a><br>';
						}
					}

					view &= '<a href="/?page=patients&section=contact&action=add&patientid=#patient.pt_id#">+Добавить контакт</a>
				</fieldset>';
///xxx
				view &= '<fieldset>
					<legend>ДМС:</legend>';
					if (patient_dms.recordcount == 0){
						view &= '<font color="red">Нет данных.</font><br>
						<a href="/?page=patients&section=dms&action=add&patientid=#patient.pt_id#">+Добавить информацию о ДМС</a>';
					}else{
						for (var x=1; x<=patient_dms.recordcount; x++ ){
							view &= 'Номер полиса: <b>#patient_dms.ptdms_polis_number[x]#</b><br>
								Примечание: <b>#patient_dms.ptdms_description[x]#</b><br>
								Компания ДМС: <b>#patient_dms.cdms_name[x]#</b><br>
								<a href="/?page=patients&section=dms&action=edite&ptdmsid=#patient_dms.ptdms_id[x]#">Редактировать</a> | 
								<a href="/?page=patients&section=dms&action=delete&ptdmsid=#patient_dms.ptdms_id[x]#">Удалить</a><br>';
						}
					}

				view &= '</fieldset>';

				
       				view &= '<fieldset>
					<legend>Документы:</legend> 
					<p>';
					if (patient_doc.recordcount == 0){
						view &= '<font color="red">Нет данных.</font><br>';
						view &= '<a href="/?page=patients&section=document&action=add&patientid=#patient.pt_id#">+Добавить</a>';
					}else{
						view &= 'Документ: <b>#patient_doc.ptd_document#</b><br>
							Cерия-номер:<b>#patient_doc.ptd_number#</b><br> 
							Паспорт выдан: <b>#patient_doc.ptd_issued#</b><br>
							Дата выдачи: <b>#_DateFormate(patient_doc.ptd_date)#</b><br>
							Код подразделения: <b>#patient_doc.ptd_sc#</b>
							<a href="/?page=patients&section=document&action=edite&ptdID=#patient_doc.ptd_id#">Редактировать</a> | <a href="/?page=patients&section=document&action=delete">Удалить</a><br>';
					}
			
		view &='	</p>
				</fieldset>

				<fieldset>
					<legend>Адреса:</legend>
						<p>';
					if (patient_add.recordcount == 0){
						view &= '<font color="red">Нет данных.</font><br>';
						view &= '<a href="/?page=patients&section=address&action=add&patientid=#patient.pt_id#">+Добавить</a>';

					}else{
						for (var x=1; x<=patient_add.recordcount; x++){
							view &= '
								Адрес #x#:<br>
								Страна: <b>#patient_add.pta_country#</b><br>
								Регион\область:<b>#patient_add.pta_region#</b><br>
								Индекс:<b>#patient_add.pta_index#</b><br>
								Город:<b>#patient_add.pta_city#</b><br>
								Населённый пункт:<b>#patient_add.pta_locality#</b><br>
								Улица:<b>#patient_add.pta_street#</b><br>
								Дом:<b>#patient_add.pta_house#</b><br>
								Корпус:<b>#patient_add.pta_building#</b><br>
								Квартира:<b>#patient_add.pta_flat#</b>
								<a href="/?page=patients&section=address&action=edite&ptaID=#patient_add.pta_id#">Редактировать</a> | <a href="/?page=patients&section=address&action=delete">Удалить</a><br>';
						}
					}

					
		view &= '			</p>
				</fieldset>

			 </div></div>';


		view &= '<div class="grid_8"><div class="signin-box">';

					rbac = request.RBAC;
					if ( rbac.CheckAccess('anamnez','read') ){
					view &= '<fieldset>
						<legend>АНАМНЕЗ ЖИЗНИ:</legend> 
						<p>';
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

						view &= '<a href="/?page=patients&section=anamnez&action=edite&patientid=#patientid#">Редактировать.</a></p>';
		                                view &= '</fieldset>';
					}

				

		view &= '	<fieldset>
					<legend>Записи пациента к врачам:</legend>';

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

		view &= '	</fieldset>

			 </div></div>';

		return view;
	}


	function patientsListFormHandler(){

		if ( isdefined('form.Search') ){
			patientsList = factoryService.getService('patientsAPI').searchPatients('#form.pt_family#');
		}else{
			patientsList = factoryService.getService('patientsAPI').searchPatients('');
		}

	}

	function patientsListForm(){

		param name='form.pt_family' default='';
		param name='start' default='1';
		messagePerPage = 50;
		max_get = start + messagePerPage - 1;
		
		var view = '';
		view &= '<div class="grid_16"><div class="signin-box">
			<h2>Пациенты:</h2>';
			view &= '<table class="td_head" width="100%">
						<tr>
							<td style="text-align:left;" colspan="9">
							<form name="" action="#request.CRequest.updateURL(false,"/?page=patients")#" method="post">
								Фамилия: <input type="text" name="pt_family" value="#form.pt_family#" size="20" maxlength="20">
								<input class="g-button g-button-submit" type="submit" name="Search" value="Найти">
							</form>
							</td>
						</tr>

						<tr>
							<td style="text-align:right;" colspan="9"><a class="g-button g-button-submit" href="/?page=patients&section=patient&action=add">+Добавить пациента</a></td>
						</tr>

						<tr style="color:grey;">
							<th>№</th> 
							<th>Ф.И.О</th>
							<th title="Кол-во записей к врачу">-</th>
							<th title="Страховой пациент или нет">-</th>
							<th>id</th> 
							<th>Пол</th>
							<th>Дата рождения</th>
							<th>Контакты</th>
							<th>Док.</th>
						</tr>';

			if ( patientsList.recordcount ){
			 for (var x=start; x<=max_get; x++){

				factoryService.getService('patientsAPI').setPatientContacts(patientsList.pt_id[x]);
				patient_cnt = factoryService.getService('patientsAPI').getPatientContacts();
				patient_dms = factoryService.getService('patientsAPI').getPatientDMS('',patientsList.pt_id[x]);

				var class = IIF(x MOD 2, DE('tr_hover'), DE('tr_hover1'));
				view &= '
					<tr class="#class#">
						<td style="color:grey;">#x#</td> 
						<td class="" style="text-align:left;"><a href="/?page=patients&section=patient&action=view&patientid=#patientsList.pt_id[x]#">
							#patientsList.pt_family[x]# #patientsList.pt_firstname[x]# #patientsList.pt_lastname[x]#</a>
						</td>
						<td>#patientsList.cnt[x]#</td>
						<td style="FONT-SIZE:11px;">#IIF( patient_dms.recordcount , DE("<img src='img/health-16.png' title='Страховая информация'>"), DE("") )#</td>
						<td>#patientsList.pt_id[x]#</td> 
						<td>#patientsList.pt_gender[x]#</td>
						<td>#_DateFormate(patientsList.pt_dob[x])#</td>
						<td>';
						for(var y=1; y<=patient_cnt.recordcount; y++){
							if (patient_cnt.ct_id == 2 OR patient_cnt.ct_id == 3){
								view&= '#phoneFormat(patient_cnt.ptc_data[y])#&nbsp;';
							}else{
								view&= '#patient_cnt.ptc_data[y]#&nbsp;';
							}
						}
					view&= '</td>
						 <td>---<!--- <a href="/?page=patients&section=document&patientid=#patientsList.pt_id[x]#" target="_blank"><img src = "img/pdf.jpg" align = "absmiddle"></a>---></td>
					</tr>';
				if (x EQ patientsList.recordcount){
					break;
				}

			 }
			}else{
				view &= '
					<tr class="block">
						<td colspan="9">Нет пациентов #now()#</td>
					</tr>
					';
			}
			// pager
			pager = request.factoryService.getService('pager').init();
			pager.setSettings(start,messagePerPage,patientsList.recordcount,'/?page=patients&start=');
			view &='
				<tr class="block">
					<td style="text-align:left;" colspan="6">&nbsp;#pager.view()#&nbsp;</td>
					<td style="text-align:right;" colspan="3">&nbsp;#pager.view1()#&nbsp;</td>
				</tr>';

			view &= '<tr><td style="text-align:right;" colspan="9"><a class="g-button g-button-submit" href="/?page=patients&section=patient&action=add">+Добавить пациента</a></td></tr>';

			view &= '</table>';
		view &= '</div></div>';
		return view;
	}

	// ///////////////////


	private function addContactFormHandler(){
		// --- обработчик формы---
		if ( isdefined('form.addContact') ){

		var patientsAPI = factoryService.getService('patientsAPI');
		  result = patientsAPI.addContact( #form.pt_id#, #form.ct_id#, #form.ptc_data#, #form.ptc_description#, #form.ptc_status# );
			//writeDump(form);
			//result.RETVAL = 1;
			if ( result.RETVAL is 1 ){
				factoryService.getService('redirector').redirect('#request.CRequest.updateURL(false,"/?page=patients&section=patient&action=view&patientid=#form.pt_id#")#');
			}else{
				// --- пробная версия
				if ( result.RETDESC is '') {
					instance.message = '';
				} else {
					instance.message = '#result.RETDESC#';
				}


				if (StructKeyExists(result.STRUCT, 'ctID')) {
					instance.ctID = result.STRUCT['ctID'];
				} else {
					instance.ctID = '';
				}

				if (StructKeyExists(result.STRUCT, 'ptcData')) {
					instance.ptcData = result.STRUCT['ptcData'];
				} else {
					instance.ptcData = '';
				}
				if (StructKeyExists(result.STRUCT, 'ptcDescription')) {
					instance.ptcDescription = result.STRUCT['ptcDescription'];
				} else {
					instance.ptcDescription = '';
				}

				if (StructKeyExists(result.STRUCT, 'ptcStatus')) {
					instance.ptcStatus = result.STRUCT['ptcStatus'];
				} else {
					instance.ptcStatus = '';
				}                           


			}
		}
		// --- обработчик формы---
	}

	function addContactForm(patientid){

		contactsType = factoryService.getService('contactsTypeAPI').getContactsTypeList();
		//writeDump(contactsType);

		//param name='form.ptc_id' default='';		// id контакта
		param name='form.pt_id' default='#arguments.patientid#';		// id пациента
		param name='form.ct_id' default='2';
		param name='form.ptc_data' default='';
		param name='form.ptc_description' default='';
		param name='form.ptc_status' default='1';

		// ---------------------------------------------------------- форма ---------------------------------------------------------------
		action = '#request.CRequest.updateURL(false,"/?page=patients&section=contact&action=add&patientid=#arguments.patientid#")#';

		view = '';
		view &= '<div class="grid_8">
			<div class="signin-box">
			<a class="g-button g-button-submit" href="#request.CRequest.updateURL(false,"/?page=patients&section=patient&action=view&patientid=#arguments.patientid#")#">Назад</a><br><br>
			<h2>Добавление нового контакта:</h2>
			<form id="addpatient" name="addpatient" action="#action#" method="post">
				<div>
					<input type="hidden" id="pt_id" name="pt_id" value="#form.pt_id#" maxlength="50" size="20">';

		view &= '	</div>
				<div>
					<label for="ct_id"><b>Тип контакта:</b></label>
					<select name="ct_id">';
					for (var x=1; x<=contactsType.recordcount; x++){
						view &= ' <option value="#contactsType.cnt_type_id[x]#" #checkedSelect("#contactsType.cnt_type_id[x]#", form.ct_id)# >#contactsType.CNT_TYPE_DESCRIPTION[x]#</option>';
					}
					view &= ' </select>';

		if (instance.ctID is not ''){
		view &= '		<label for="ct_id" class="error" generated="0">#instance.ctID#</label>';
		}

		view &= '	</div>
				<div>
					<label>Контакт:</label>
					<input class="phone" type="text" id="ptc_data" name="ptc_data" value="#form.ptc_data#" maxlength="50" size="45">';
   		if (instance.ptcData is not ''){
		view &= '		<label for="ptcData" class="error" generated="2">#instance.ptcData#</label>';
		}

		view &= '
				</div>
				<div>
					<label for="ptc_description"><b>Описание:</b></label>
					<textarea name = "ptc_description" rows="6" cols="47" >#form.ptc_description#</textarea>';
		if (instance.ptcDescription is not ''){
			view &= '		<label for="ptc_description" class="error" generated="0">#instance.ptcDescription#</label>';
		}


		view &= '	</div><div>
				<input type="hidden" name="ptc_status" value="#form.ptc_status#" size = "2" maxlength = "2">
				<hr>
				<input disabled class="g-button g-button-submit" type="submit" name="escape" value="Отмена">
				<input class="g-button g-button-submit" type="submit" name="addContact" value="Сохранить"> ';

		if (instance.message is not ''){
			view &= '<div id="mes" style="color:red;">#instance.message#</div>';
		}

		view &='</div></form>
			</div></div>';

			// ------------------------------------------------ форма ---------------------------------------------------------------
		return view;
	}

	private function updateContactFormHandler(){
		// --- обработчик формы---
		if ( isdefined('form.updateContact') ){

		var patientsAPI = factoryService.getService('patientsAPI');
		  result = patientsAPI.editeContact( #form.ptc_id#, #form.pt_id#, #form.ct_id#, #form.ptc_data#, #form.ptc_description#, #form.ptc_status# );
			//writeDump(form);
			//result.RETVAL = 1;
			if ( result.RETVAL is 1 ){
				factoryService.getService('redirector').redirect('#request.CRequest.updateURL(false,"/?page=patients&section=patient&action=view&patientid=#form.pt_id#")#');
			}else{
				// --- пробная версия
				if ( result.RETDESC is '') {
					instance.message = '';
				} else {
					instance.message = '#result.RETDESC#';
				}


				if (StructKeyExists(result.STRUCT, 'ctID')) {
					instance.ctID = result.STRUCT['ctID'];
				} else {
					instance.ctID = '';
				}

				if (StructKeyExists(result.STRUCT, 'ptcData')) {
					instance.ptcData = result.STRUCT['ptcData'];
				} else {
					instance.ptcData = '';
				}
				if (StructKeyExists(result.STRUCT, 'ptcDescription')) {
					instance.ptcDescription = result.STRUCT['ptcDescription'];
				} else {
					instance.ptcDescription = '';
				}

				if (StructKeyExists(result.STRUCT, 'ptcStatus')) {
					instance.ptcStatus = result.STRUCT['ptcStatus'];
				} else {
					instance.ptcStatus = '';
				}                           


			}
		}
		// --- обработчик формы---
	}

	function updateContactForm(ptcid){

		contactsType = factoryService.getService('contactsTypeAPI').getContactsTypeList();
		//writeDump(contactsType);
		contact = factoryService.getService('patientsAPI').getContact(arguments.ptcID);

		param name='form.ptc_id' default='#contact.ptc_id#';		// id контакта
		param name='form.pt_id' default='#contact.pt_id#';		// id пациента
		param name='form.ct_id' default='#contact.ct_id#';
		param name='form.ptc_data' default='#contact.ptc_data#';
		param name='form.ptc_description' default='#contact.ptc_description#';
		param name='form.ptc_status' default='#contact.ptc_status#';

		// ---------------------------------------------------------- форма ---------------------------------------------------------------
		action = '#request.CRequest.updateURL(false,"/?page=patients&section=contact&action=edite&ptcid=#arguments.ptcid#")#';

		view = '';
		view &= '<div class="grid_8">
			<div class="signin-box">
			<a class="g-button g-button-submit" href="#request.CRequest.updateURL(false,"/?page=patients&section=patient&action=view&patientid=#contact.pt_id#")#">Назад</a><br><br>
			<h2>Добавление нового контакта:</h2>
			<form id="addpatient" name="addpatient" action="#action#" method="post">
				<div>
					<input type="hidden" id="ptc_id" name="ptc_id" value="#form.ptc_id#" maxlength="50" size="20">
					<input type="hidden" id="pt_id" name="pt_id" value="#form.pt_id#" maxlength="50" size="20">';

		view &= '	</div>
				<div>
					<label for="ct_id"><b>Тип контакта:</b></label>
					<select name="ct_id">';
					for (var x=1; x<=contactsType.recordcount; x++){
						view &= ' <option value="#contactsType.cnt_type_id[x]#" #checkedSelect("#contactsType.cnt_type_id[x]#", form.ct_id)# >#contactsType.CNT_TYPE_DESCRIPTION[x]#</option>';
					}
					view &= ' </select>';

		if (instance.ctID is not ''){
		view &= '		<label for="ct_id" class="error" generated="0">#instance.ctID#</label>';
		}

		view &= '	</div>
				<div>
					<label>Контакт:</label>
					<input type="text" id="ptc_data" name="ptc_data" value="#form.ptc_data#" maxlength="50" size="45">';
   		if (instance.ptcData is not ''){
		view &= '		<label for="ptcData" class="error" generated="2">#instance.ptcData#</label>';
		}

		view &= '
				</div>
				<div>
					<label for="ptc_description"><b>Описание:</b></label>
					<textarea name = "ptc_description" rows="6" cols="47" >#form.ptc_description#</textarea>';
		if (instance.ptcDescription is not ''){
			view &= '		<label for="ptc_description" class="error" generated="0">#instance.ptcDescription#</label>';
		}


		view &= '	</div><div>
				<input type="hidden" name="ptc_status" value="#form.ptc_status#" size = "2" maxlength = "2">
				<hr>
				<input disabled class="g-button g-button-submit" type="submit" name="escape" value="Отмена">
				<input class="g-button g-button-submit" type="submit" name="updateContact" value="Сохранить"> ';

		if (instance.message is not ''){
			view &= '<div id="mes" style="color:red;">#instance.message#</div>';
		}

		view &='</div></form>
			</div></div>';

			// ------------------------------------------------ форма ---------------------------------------------------------------
		return view;
	}


	private function updateAnamnezFormHandler(){

		//writeDump(form);
		shablon = '
			[	{"NAME":"Наследственность","POS":1,"DATA":""},
				{"NAME":"Семейное положение","POS":2,"DATA":""},
				{"NAME":"Характер питания","POS":3,"DATA":""},
				{"NAME":"Вредные привычки","POS":4,"DATA":""},
				{"NAME":"Перенесённые заболевания","POS":5,"DATA":""},
				{"NAME":"Перенесённые травмы и хирургические вмешательства","POS":6,"DATA":""},
				{"NAME":"Переливание крови и кровезаменителей","POS":7,"DATA":""},
				{"NAME":"Аллергологический анамнез","POS":8,"DATA":""}
			]';

		shablonJSON = DeserializeJSON(shablon);
		//writeDump(shablonJSON);

		// --- обработчик формы---
		if ( isdefined('form.updateAnamnez') ){

			for (var i=1; i<=arrayLen(shablonJSON); i++){
				if ( structKeyExists(form, '#shablonJSON[i].name#')  ){
					shablonNew[i] = structNew();
					shablonNew[i].name = shablonJSON[i].name;
					shablonNew[i].data = StructFind(form,shablonJSON[i].name);
					shablonNew[i].pos = shablonJSON[i].pos;
				}
			}
			
			//writeDump(serializeJSON(shablonNew));

		var patientsAPI = factoryService.getService('patientsAPI');
		 result = patientsAPI.editeAnamnez( #form.patientid#, shablonNew );
			//result.RETVAL = 0;
			//result.RETDESC = '';
			//writeDump(result);
			if ( result.RETVAL is 1 ){
				factoryService.getService('redirector').redirect('#request.CRequest.updateURL(false,"/?page=patients&section=patient&action=view&patientid=#form.patientid#")#');
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

	function updateAnamnezForm(patientid){

		patientid = arguments.patientid;
		factoryService.getService('patientsAPI').setPatient(patientid);
		patient = factoryService.getService('patientsAPI').getPatient();
		anamnez = patient.pt_anamnez;
		param name='form.patientid' default='#patient.pt_id#';
		//writeDump(patient);
		if (anamnez == ''){
			anamnez = shablon;
		}
		anamnezJSON = DeserializeJSON(anamnez);
		//writeDump(shablonJSON);
		//writeDump(anamnezJSON);

		view = '';

		
		view &= '<div class="grid_8">
				<div class="signin-box">';

		view &= '<form name="editeAnamnez" action="" method="post">';
		view &= '<p><a class="g-button g-button-submit" href="#request.CRequest.updateURL(false,"/?page=patients&section=patient&action=view&patientid=#patientid#")#">Назад</a></p>';
		view &= '<h2>АНАМНЕЗ ЖИЗНИ</h2>';
		view &= '<h2>#patient.pt_family# #patient.pt_firstname# #patient.pt_lastname#</h2>';
		view &= '<input type="hidden" name="patientid" value="#form.patientid#" maxlength="20" size="20">';
		//view &= '#anamnez#';

		
		for (var i=1; i<=arrayLen(shablonJSON); i++){
			if( isStruct(anamnezJSON[i]) ){
				param name='form[shablonJSON[i].name]' default='#anamnezJSON[i].data#';
				param name='instance[shablonJSON[i].name]' default = '';
			}else{
				param name='form[shablonJSON[i].name]' default='';
				param name='instance[shablonJSON[i].name]' default = '';
			}
		}

		for (var i=1; i<=arrayLen(shablonJSON); i++){
			view &= '<p><b>#shablonJSON[i].name#:</b><br>';
			view &= '<textarea name = "#shablonJSON[i].name#" rows="3" cols="47" >#form[shablonJSON[i].name]#</textarea>';
			if (instance[shablonJSON[i].name] is not ''){
				view &= '<label for="#shablonJSON[i].name#" class="error" generated="2">#instance[shablonJSON[i].name]#</label>';
			}
			view &= '</p>';
		}

		view &= '<hr>
			<input disabled class="g-button g-button-submit" type="submit" name="escape" value="Отмена">
			<input class="g-button g-button-submit" type="submit" name="updateAnamnez" value="Сохранить"> ';

		view &= '	</div>
			</div>';

		view &= '</form>';

		view &= '<div class="grid_8">
				<div class="signin-box">';

		view &= '<h2>Помощь</h2>
			<p>Анамнез жизни пациента</p>';

		view &= '	</div>
			</div>';

		return view;
	}

	private function addDocumentFormHandler(){
		// --- обработчик формы---
		if ( isdefined('form.addDocument') ){
		// собрать дату из формы

			form.ptd_date = '#form.ptd_dateYear#-#form.ptd_dateMonth#-#form.ptd_dateDay#';
			var patientsAPI = factoryService.getService('patientsAPI');
			//result = patientsAPI.addDocument( #form.pt_id#, #form.ptd_document#, #form.ptd_number#, #form.ptd_number1#, #form.ptd_issued#, #form.ptd_date#, #form.ptd_sc#, #form.ptd_status# );
			result = patientsAPI.addDocument( #form.pt_id#, #form.ptd_document#, #form.ptd_number#, #form.ptd_number1#, #form.ptd_issued#, #form.ptd_date#, #form.ptd_sc#, #form.ptd_sc1#, #form.ptd_status# );
			//writeDump(result);
			if ( result.RETVAL is 1 ){
				factoryService.getService('redirector').redirect('#request.CRequest.updateURL(false,"/?page=patients&section=patient&action=view&patientid=#form.pt_id#")#');
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

	function addDocumentForm(patientid){

		param name='form.pt_id' default='#arguments.patientid#';		// id пациента
		param name='form.ptd_document' default='ПАСПОРТ';
		param name='form.ptd_number' default='';
		param name='form.ptd_number1' default='';
		param name='form.ptd_issued' default='';
		param name='form.ptd_date' default='';
		param name='form.ptd_dateDay' default='';
		param name='form.ptd_dateMonth' default='';
		param name='form.ptd_dateYear' default='';

		param name='form.ptd_sc' default='';
		param name='form.ptd_sc1' default='';
		param name='form.ptd_status' default='1';

		action = '#request.CRequest.updateURL(false,"/?page=patients&section=document&action=add&patientid=#arguments.patientid#")#';

		// ---------------------------------------------------------- форма ---------------------------------------------------------------
		view = '';
		view &= '<div class="grid_8">
			<div class="signin-box">
			<a class="g-button g-button-submit" href="#request.CRequest.updateURL(false,'/?page=patients&section=patient&action=view&patientid=#arguments.patientid#')#">Назад</a><br><br>
			<h2>Добавление нового дкумента:</h2>
			<form id="addDocument" name="addDocument" action="#action#" method="post">
				<div>
					<input type="hidden" id="pt_id" name="pt_id" value="#form.pt_id#" maxlength="50" size="20">';

		view &= '	</div>
				<div>
					<label for="ptd_document"><b>Документ:</b></label>
					<input disabled type="text" id="ptd_doc" name="ptd_doc" value="#form.ptd_document#" maxlength="7" size="7">
					<input type="hidden" id="ptd_document" name="ptd_document" value="#form.ptd_document#" maxlength="7" size="7">';

		if (instance.ptdDocument is not ''){
		view &= '		<label for="ptd_document" class="error" generated="0">#instance.ptdDocument#</label>';
		}

		view &= '	</div>
				<div>
					<label>Номер:</label>
					<input type="text" id="ptd_number" name="ptd_number" value="#form.ptd_number#" maxlength="4" size="4">';
   		if (instance.ptdNumber is not ''){
		view &= '		<label for="ptdNumber" class="error" generated="2">#instance.ptdNumber#</label>';
		}

		view &= '	</div>
				<div>
					<label>Серия:</label>
					<input type="text" id="ptd_number1" name="ptd_number1" value="#form.ptd_number1#" maxlength="6" size="6">';
   		if (instance.ptdNumber1 is not ''){
		view &= '		<label for="ptdNumber1" class="error" generated="2">#instance.ptdNumber1#</label>';
		}

		view &= '</div>
				<div>
					<label for="ptd_issued"><b>Выдан:</b></label>
					<textarea name = "ptd_issued" rows="6" cols="47" >#form.ptd_issued#</textarea>';
		if (instance.ptdIssued is not ''){
			view &= '		<label for="ptd_issued" class="error" generated="0">#instance.ptdIssued#</label>';
		}

		view &= '	</div>
				<div>
					<label for="ptd_date"><b>Дата выдачи:</b></label>

					<label for="ptd_dateDay">День:</label>
					<input type="text" id="ptdDateDay" name="ptd_dateDay" value="#form.ptd_dateDay#" maxlength="2" size="2">
					<label for="ptd_dateMonth">Месяц:</label>
					<input type="text" id="ptdDateMonth" name="ptd_dateMonth" value="#form.ptd_dateMonth#" maxlength="2" size="2">
					<label for="ptd_dateYear">Год:</label>
					<input type="text" id="ptdDateYear" name="ptd_dateYear" value="#form.ptd_dateYear#" maxlength="4" size="4">
				';

		if (instance.ptdDate is not ''){
		view &= '		<label for="ptd_date" class="error" generated="0">#instance.ptdDate#</label>';
		}

		view &= '</div>
				<div>
					<label for="ptd_sc"><b>Код подразделения:</b></label>
					<input type="text" id="ptd_sc" name="ptd_sc" value="#form.ptd_sc#" maxlength="3" size="3">-<input type="text" id="ptd_sc1" name="ptd_sc1" value="#form.ptd_sc1#" maxlength="3" size="3">';
		if (instance.ptdSc is not ''){
			view &= '		<label for="ptd_sc" class="error" generated="0">#instance.ptdSc#</label>';
		}

		if (instance.ptdSc1 is not ''){
			view &= '		<label for="ptd_sc1" class="error" generated="0">#instance.ptdSc1#</label>';
		}

		view &= '	</div><div>
				<input type="hidden" name="ptd_status" value="#form.ptd_status#" size = "2" maxlength = "2">
				<hr>
				<input disabled class="g-button g-button-submit" type="submit" name="escape" value="Отмена">
				<input class="g-button g-button-submit" type="submit" name="addDocument" value="Сохранить"> ';

		if (instance.message is not ''){
			view &= '<div id="mes" style="color:red;">#instance.message#</div>';
		}

		view &='</div></form>
			</div></div>';


		return view;
	}

	private function updateDocumentFormHandler(){
		// --- обработчик формы---
		if ( isdefined('form.updateDocument') ){
		// собрать дату из формы

			form.ptd_date = '#form.ptd_dateYear#-#form.ptd_dateMonth#-#form.ptd_dateDay#';
			var patientsAPI = factoryService.getService('patientsAPI');
			result = patientsAPI.editeDocument( #form.ptd_id#, #form.pt_id#, #form.ptd_document#, #form.ptd_number#, #form.ptd_number1#, #form.ptd_issued#, #form.ptd_date#, #form.ptd_sc#, #form.ptd_sc1#, #form.ptd_status# );
			//writeDump(result);
			if ( result.RETVAL is 1 ){
				factoryService.getService('redirector').redirect('#request.CRequest.updateURL(false,"/?page=patients&section=patient&action=view&patientid=#form.pt_id#")#');
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

	function updateDocumentForm( ptdID ){

		// запрос к базе
		patient_doc = factoryService.getService('patientsAPI').getPatientDocument(ptdID);

		param name='form.ptd_id' default='#patient_doc.ptd_id#';
		param name='form.pt_id' default='#patient_doc.pt_id#';
		param name='form.ptd_document' default='#patient_doc.ptd_document#';
		param name='form.ptd_number' default='#mid(patient_doc.ptd_number,1,4)#';
		param name='form.ptd_number1' default='#mid(patient_doc.ptd_number,6,6)#';
		param name='form.ptd_issued' default='#patient_doc.ptd_issued#';
		param name='form.ptd_date' default='#patient_doc.ptd_date#';

		param name='form.ptd_dateDay' default='#day(patient_doc.ptd_date)#';
		param name='form.ptd_dateMonth' default='#month(patient_doc.ptd_date)#';
		param name='form.ptd_dateYear' default='#year(patient_doc.ptd_date)#';

		param name='form.ptd_sc' default='#mid(patient_doc.ptd_sc,1,3)#';
		param name='form.ptd_sc1' default='#mid(patient_doc.ptd_sc,5,3)#';
		param name='form.ptd_status' default='#patient_doc.ptd_status#';

		action = '#request.CRequest.updateURL(false,"/?page=patients&section=document&action=edite&ptdID=#patient_doc.ptd_id#")#';

		// ---------------------------------------------------------- форма ---------------------------------------------------------------
		view = '';
		view &= '<div class="grid_8">
			<div class="signin-box">
			<a class="g-button g-button-submit" href="#request.CRequest.updateURL(false,'/?page=patients&section=patient&action=view&patientid=#patient_doc.pt_id#')#">Назад</a><br><br>
			<h2>Редактирование дкумента:</h2>
			<form id="updateDocument" name="updateDocument" action="#action#" method="post">
				<div>
					<input type="hidden" id="ptd_id" name="ptd_id" value="#form.ptd_id#" maxlength="50" size="20">
					<input type="hidden" id="pt_id" name="pt_id" value="#form.pt_id#" maxlength="50" size="20">';

		view &= '	</div>
				<div>
					<label for="ptd_document"><b>Документ:</b></label>
					<input disabled type="text" id="ptd_doc" name="ptd_doc" value="#form.ptd_document#" maxlength="7" size="7">
					<input type="hidden" id="ptd_document" name="ptd_document" value="#form.ptd_document#" maxlength="7" size="7">';

		if (instance.ptdDocument is not ''){
		view &= '		<label for="ptd_document" class="error" generated="0">#instance.ptdDocument#</label>';
		}

		view &= '	</div>
				<div>
					<label>Номер:</label>
					<input type="text" id="ptd_number" name="ptd_number" value="#form.ptd_number#" maxlength="4" size="4">';
   		if (instance.ptdNumber is not ''){
		view &= '		<label for="ptdNumber" class="error" generated="2">#instance.ptdNumber#</label>';
		}

		view &= '	</div>
				<div>
					<label>Серия:</label>
					<input type="text" id="ptd_number1" name="ptd_number1" value="#form.ptd_number1#" maxlength="6" size="6">';
   		if (instance.ptdNumber1 is not ''){
		view &= '		<label for="ptdNumber1" class="error" generated="2">#instance.ptdNumber1#</label>';
		}

		view &= '</div>
				<div>
					<label for="ptd_issued"><b>Выдан:</b></label>
					<textarea name = "ptd_issued" rows="6" cols="47" >#form.ptd_issued#</textarea>';
		if (instance.ptdIssued is not ''){
			view &= '		<label for="ptd_issued" class="error" generated="0">#instance.ptdIssued#</label>';
		}

		view &= '	</div>
				<div>
					<label for="ptd_date"><b>Дата выдачи:</b></label>

					<label for="ptd_dateDay">День:</label>
					<input type="text" id="ptdDateDay" name="ptd_dateDay" value="#form.ptd_dateDay#" maxlength="2" size="2">
					<label for="ptd_dateMonth">Месяц:</label>
					<input type="text" id="ptdDateMonth" name="ptd_dateMonth" value="#form.ptd_dateMonth#" maxlength="2" size="2">
					<label for="ptd_dateYear">Год:</label>
					<input type="text" id="ptdDateYear" name="ptd_dateYear" value="#form.ptd_dateYear#" maxlength="4" size="4">
				';

		if (instance.ptdDate is not ''){
		view &= '		<label for="ptd_date" class="error" generated="0">#instance.ptdDate#</label>';
		}

		view &= '</div>
				<div>
					<label for="ptd_sc"><b>Код подразделения:</b></label>
					<input type="text" id="ptd_sc" name="ptd_sc" value="#form.ptd_sc#" maxlength="3" size="3">-<input type="text" id="ptd_sc1" name="ptd_sc1" value="#form.ptd_sc1#" maxlength="3" size="3">';
		if (instance.ptdSc is not ''){
			view &= '		<label for="ptd_sc" class="error" generated="0">#instance.ptdSc#</label>';
		}

		if (instance.ptdSc1 is not ''){
			view &= '		<label for="ptd_sc1" class="error" generated="0">#instance.ptdSc1#</label>';
		}

		view &= '	</div><div>
				<input type="hidden" name="ptd_status" value="#form.ptd_status#" size = "2" maxlength = "2">
				<hr>
				<input disabled class="g-button g-button-submit" type="submit" name="escape" value="Отмена">
				<input class="g-button g-button-submit" type="submit" name="updateDocument" value="Сохранить"> ';

		if (instance.message is not ''){
			view &= '<div id="mes" style="color:red;">#instance.message#</div>';
		}

		view &='</div></form>
			</div></div>';


		return view;
	}

	private function addAddressFormHandler(){
		// --- обработчик формы---
		if ( isdefined('form.addAddress') ){
		// собрать дату из формы
			writeDump(form);
			var patientsAPI = factoryService.getService('patientsAPI');
			result = patientsAPI.addAddress( #form.pt_id#, #form.pta_type#, #form.pta_firmdata#, #form.pta_country#, #form.pta_region#, #form.pta_city#, #form.pta_locality#, #form.pta_street#, #form.pta_index#, #form.pta_house#, #form.pta_building#, #form.pta_flat#, #form.pta_description#, #form.pta_status# );
			//writeDump(result);
			if ( result.RETVAL is 1 ){
				factoryService.getService('redirector').redirect('#request.CRequest.updateURL(false,"/?page=patients&section=patient&action=view&patientid=#form.pt_id#")#');
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

	function addAddressForm(patientid){

		param name='form.pt_id' default='#arguments.patientid#';		// id пациента
		param name='form.pta_type' default='1';
		param name='form.pta_firmdata' default='';
		param name='form.pta_country' default='Россия';
		param name='form.pta_region' default='';
		param name='form.pta_city' default='';
		param name='form.pta_locality' default='';
		param name='form.pta_street' default='';
		param name='form.pta_index' default='';
		param name='form.pta_house' default='';
		param name='form.pta_building' default='';
		param name='form.pta_flat' default='';
		param name='form.pta_description' default='';
		param name='form.pta_status' default='1';

		action = '#request.CRequest.updateURL(false,"/?page=patients&section=address&action=add&patientid=#arguments.patientid#")#';

		// ---------------------------------------------------------- форма ---------------------------------------------------------------
		view = '';
		view &= '<div class="grid_8">
			<div class="signin-box">
			<a class="g-button g-button-submit" href="#request.CRequest.updateURL(false,'/?page=patients&section=patient&action=view&patientid=#arguments.patientid#')#">Назад</a><br><br>
			<h2>Добавление нового дкумента:</h2>
			<form id="addDocument" name="addDocument" action="#action#" method="post">
				<div>
					<input type="hidden" id="pt_id" name="pt_id" value="#form.pt_id#" maxlength="50" size="20">
					<input type="hidden" id="pta_type" name="pta_type" value="#form.pta_type#" maxlength="50" size="20">
					<input type="hidden" id="pta_firmdata" name="pta_firmdata" value="#form.pta_firmdata#" maxlength="50" size="20">
					';

		view &= '	</div>
				<div>
					<label for="pta_country"><b>Страна:</b></label>
					<input type="text" id="pta_country" name="pta_country" value="#form.pta_country#" maxlength="50" size="30">';

		if (instance.ptaCountry is not ''){
		view &= '		<label for="pta_country" class="error" generated="0">#instance.ptaCountry#</label>';
		}

		view &= '	</div>
				<div>
					<label>Регион\область:</label>
					<input type="text" id="pta_region" name="pta_region" value="#form.pta_region#" maxlength="50" size="30">';
   		if (instance.ptaRegion is not ''){
		view &= '		<label for="ptaRegion" class="error" generated="2">#instance.ptaRegion#</label>';
		}

		view &= '	</div>
				<div>
					<label>Город:</label>
					<input type="text" id="pta_city" name="pta_city" value="#form.pta_city#" maxlength="50" size="40">';
   		if (instance.ptaCity is not ''){
		view &= '		<label for="ptaCity" class="error" generated="2">#instance.ptaCity#</label>';
		}

		view &= '</div>
				<div>
					<label for="pta_locality"><b>Населённый пункт:</b></label>
					<input type="text" id="pta_locality" name="pta_locality" value="#form.pta_locality#" maxlength="50" size="40">';
		if (instance.ptaLocality is not ''){
			view &= '		<label for="pta_locality" class="error" generated="0">#instance.ptaLocality#</label>';
		}

		view &= '</div>
				<div>
					<label for="pta_street"><b>Улица:</b></label>
					<input type="text" id="pta_street" name="pta_street" value="#form.pta_street#" maxlength="50" size="40">';
		if (instance.ptaStreet is not ''){
			view &= '		<label for="pta_street" class="error" generated="0">#instance.ptaStreet#</label>';
		}

		view &= '</div>
				<div>
					<label for="pta_index"><b>Индекс:</b></label>
					<input type="text" id="pta_index" name="pta_index" value="#form.pta_index#" maxlength="6" size="6">';
		if (instance.ptaIndex is not ''){
			view &= '		<label for="pta_index" class="error" generated="0">#instance.ptaIndex#</label>';
		}

		view &= '</div>
				<div>
					<label for="pta_houes"><b>Дом:</b></label>
					<input type="text" id="pta_house" name="pta_house" value="#form.pta_house#" maxlength="10" size="10">';
		if (instance.ptaHouse is not ''){
			view &= '		<label for="pta_house" class="error" generated="0">#instance.ptaHouse#</label>';
		}

		view &= '</div>
				<div>
					<label for="pta_building"><b>Строение:</b></label>
					<input type="text" id="pta_building" name="pta_building" value="#form.pta_building#" maxlength="10" size="10">';
		if (instance.ptaBuilding is not ''){
			view &= '		<label for="pta_building" class="error" generated="0">#instance.ptaBuilding#</label>';
		}

		view &= '</div>
				<div>
					<label for="pta_flat"><b>Квартира:</b></label>
					<input type="text" id="pta_flat" name="pta_flat" value="#form.pta_flat#" maxlength="10" size="10">';
		if (instance.ptaFlat is not ''){
			view &= '		<label for="pta_flat" class="error" generated="0">#instance.ptaFlat#</label>';
		}

		view &= '</div>
				<div>
					<label for="pta_description"><b>Описание:</b></label>
					<textarea name = "pta_description" rows="6" cols="47" >#form.pta_description#</textarea>';
		if (instance.ptaDescription is not ''){
			view &= '		<label for="pta_description" class="error" generated="0">#instance.ptaDescription#</label>';
		}

		view &= '	</div><div>
				<input type="hidden" name="pta_status" value="#form.pta_status#" size = "2" maxlength = "2">
				<hr>
				<input disabled class="g-button g-button-submit" type="submit" name="escape" value="Отмена">
				<input class="g-button g-button-submit" type="submit" name="addAddress" value="Сохранить"> ';

		if (instance.message is not ''){
			view &= '<div id="mes" style="color:red;">#instance.message#</div>';
		}

		view &='</div></form>
			</div></div>';


		return view;
	}

	private function updateAddressFormHandler(){
		// --- обработчик формы---
		if ( isdefined('form.updateAddress') ){
		// собрать дату из формы
			writeDump(form);
			var patientsAPI = factoryService.getService('patientsAPI');
			result = patientsAPI.editeAddress( form.pta_id, form.pt_id, form.pta_type, form.pta_firmdata, form.pta_country, form.pta_region, form.pta_city, form.pta_locality, form.pta_street, form.pta_index, form.pta_house, form.pta_building, form.pta_flat, form.pta_description, form.pta_status );
			//writeDump(result);
			if ( result.RETVAL is 1 ){
				factoryService.getService('redirector').redirect('#request.CRequest.updateURL(false,"/?page=patients&section=patient&action=view&patientid=#form.pt_id#")#');
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

	function updateAddressForm( ptaID ){

		// запрос к базе
		patient_add = factoryService.getService('patientsAPI').getPatientAddress(ptaID);

		param name='form.pta_id' default='#patient_add.pta_id#';
		param name='form.pt_id' default='#patient_add.pt_id#';		// id пациента
		param name='form.pta_type' default='#patient_add.pta_type#';
		param name='form.pta_firmdata' default='#patient_add.pta_firmdata#';
		param name='form.pta_country' default='#patient_add.pta_country#';
		param name='form.pta_region' default='#patient_add.pta_region#';
		param name='form.pta_city' default='#patient_add.pta_city#';
		param name='form.pta_locality' default='#patient_add.pta_locality#';
		param name='form.pta_street' default='#patient_add.pta_street#';
		param name='form.pta_index' default='#patient_add.pta_index#';
		param name='form.pta_house' default='#patient_add.pta_house#';
		param name='form.pta_building' default='#patient_add.pta_building#';
		param name='form.pta_flat' default='#patient_add.pta_flat#';
		param name='form.pta_description' default='#patient_add.pta_description#';
		param name='form.pta_status' default='#patient_add.pta_status#';

		action = '#request.CRequest.updateURL(false,"/?page=patients&section=address&action=edite&ptaID=#patient_add.pta_id#")#';

		// ---------------------------------------------------------- форма ---------------------------------------------------------------
		view = '';
		view &= '<div class="grid_8">
			<div class="signin-box">
			<a class="g-button g-button-submit" href="#request.CRequest.updateURL(false,'/?page=patients&section=patient&action=view&patientid=#patient_add.pt_id#')#">Назад</a><br><br>
			<h2>Добавление нового дкумента:</h2>
			<form id="editeDocument" name="editeDocument" action="#action#" method="post">
				<div>
					<input type="hidden" id="pta_id" name="pta_id" value="#form.pta_id#" maxlength="50" size="20">
					<input type="hidden" id="pt_id" name="pt_id" value="#form.pt_id#" maxlength="50" size="20">
					<input type="hidden" id="pta_type" name="pta_type" value="#form.pta_type#" maxlength="50" size="20">
					<input type="hidden" id="pta_firmdata" name="pta_firmdata" value="#form.pta_firmdata#" maxlength="50" size="20">';

		view &= '	</div>
				<div>
					<label for="pta_country"><b>Страна:</b></label>
					<input type="text" id="pta_country" name="pta_country" value="#form.pta_country#" maxlength="50" size="30">';

		if (instance.ptaCountry is not ''){
		view &= '		<label for="pta_country" class="error" generated="0">#instance.ptaCountry#</label>';
		}

		view &= '	</div>
				<div>
					<label>Регион\область:</label>
					<input type="text" id="pta_region" name="pta_region" value="#form.pta_region#" maxlength="50" size="30">';
   		if (instance.ptaRegion is not ''){
		view &= '		<label for="ptaRegion" class="error" generated="2">#instance.ptaRegion#</label>';
		}

		view &= '	</div>
				<div>
					<label>Город:</label>
					<input type="text" id="pta_city" name="pta_city" value="#form.pta_city#" maxlength="50" size="40">';
   		if (instance.ptaCity is not ''){
		view &= '		<label for="ptaCity" class="error" generated="2">#instance.ptaCity#</label>';
		}

		view &= '</div>
				<div>
					<label for="pta_locality"><b>Населённый пункт:</b></label>
					<input type="text" id="pta_locality" name="pta_locality" value="#form.pta_locality#" maxlength="50" size="40">';
		if (instance.ptaLocality is not ''){
			view &= '		<label for="pta_locality" class="error" generated="0">#instance.ptaLocality#</label>';
		}

		view &= '</div>
				<div>
					<label for="pta_street"><b>Улица:</b></label>
					<input type="text" id="pta_street" name="pta_street" value="#form.pta_street#" maxlength="50" size="40">';
		if (instance.ptaStreet is not ''){
			view &= '		<label for="pta_street" class="error" generated="0">#instance.ptaStreet#</label>';
		}

		// ---------------
		view &= '</div>
				<div>
					<label for="pta_index"><b>Индекс:</b></label>
					<input type="text" id="pta_index" name="pta_index" value="#form.pta_index#" maxlength="6" size="6">';
		if (instance.ptaIndex is not ''){
			view &= '		<label for="pta_index" class="error" generated="0">#instance.ptaIndex#</label>';
		}
		// ---------------
		view &= '</div>
				<div>
					<label for="pta_houes"><b>Дом:</b></label>
					<input type="text" id="pta_house" name="pta_house" value="#form.pta_house#" maxlength="10" size="10">';
		if (instance.ptaHouse is not ''){
			view &= '		<label for="pta_house" class="error" generated="0">#instance.ptaHouse#</label>';
		}

		view &= '</div>
				<div>
					<label for="pta_building"><b>Строение:</b></label>
					<input type="text" id="pta_building" name="pta_building" value="#form.pta_building#" maxlength="10" size="10">';
		if (instance.ptaBuilding is not ''){
			view &= '		<label for="pta_building" class="error" generated="0">#instance.ptaBuilding#</label>';
		}

		view &= '</div>
				<div>
					<label for="pta_flat"><b>Квартира:</b></label>
					<input type="text" id="pta_flat" name="pta_flat" value="#form.pta_flat#" maxlength="10" size="10">';
		if (instance.ptaFlat is not ''){
			view &= '		<label for="pta_flat" class="error" generated="0">#instance.ptaFlat#</label>';
		}

		view &= '</div>
				<div>
					<label for="pta_description"><b>Описание:</b></label>
					<textarea name = "pta_description" rows="6" cols="47" >#form.pta_description#</textarea>';
		if (instance.ptaDescription is not ''){
			view &= '		<label for="pta_description" class="error" generated="0">#instance.ptaDescription#</label>';
		}

		view &= '	</div><div>
				<input type="hidden" name="pta_status" value="#form.pta_status#" size = "2" maxlength = "2">
				<hr>
				<input disabled class="g-button g-button-submit" type="submit" name="escape" value="Отмена">
				<input class="g-button g-button-submit" type="submit" name="updateAddress" value="Сохранить"> ';

		if (instance.message is not ''){
			view &= '<div id="mes" style="color:red;">#instance.message#</div>';
		}

		view &='</div></form>
			</div></div>';


		return view;

	}

	private function addDMSFormHandler(){
		if ( isdefined('form.addDMS') ){

		var patientsAPI = factoryService.getService('patientsAPI');
		  result = patientsAPI.addDMS( #form.pt_id#, #form.cdms_id#, #form.ptdms_polis_number#, #form.ptdms_description#, #form.ptdms_status# );
			if ( result.RETVAL is 1 ){
				factoryService.getService('redirector').redirect('#request.CRequest.updateURL(false,"/?page=patients&section=patient&action=view&patientid=#form.pt_id#")#');
			}else{
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
	}

	function addDMSForm(patientid){

		companysDms = factoryService.getService('companysDmsAPI').getCompanysDmsList();

		param name='form.pt_id' default='#arguments.patientid#';		// id пациента
		param name='form.cdms_id' default='';
		param name='form.ptdms_polis_number' default='';
		param name='form.ptdms_description' default='';
		param name='form.ptdms_status' default='1';

		// ---------------------------------------------------------- форма ---------------------------------------------------------------
		action = '#request.CRequest.updateURL(false,"/?page=patients&section=dms&action=add&patientid=#arguments.patientid#")#';

		view = '';
		view &= '<div class="grid_8">
			<div class="signin-box">
			<a class="g-button g-button-submit" href="#request.CRequest.updateURL(false,"/?page=patients&section=patient&action=view&patientid=#arguments.patientid#")#">Назад</a><br><br>
			<h2>Добавление информации ДМС:</h2>
			<form id="addDMS" name="addDMS" action="#action#" method="post">
				<div>
					<input type="hidden" id="pt_id" name="pt_id" value="#form.pt_id#" maxlength="50" size="20">';

		view &= '	</div>
				<div>
					<label>Номер полиса:</label>
					<input class="phone" type="text" id="ptdms_polis_number" name="ptdms_polis_number" value="#form.ptdms_polis_number#" maxlength="50" size="12">';
   		if (instance.ptdmsPolisNumber is not ''){
		view &= '		<label for="ptdmsPolisNumber" class="error" generated="2">#instance.ptdmsPolisNumber#</label>';
		}

		view &= '	</div>
				<div>
					<label for="cdms_id"><b>Компания ДМС:</b></label>
					<select name="cdms_id">
					<option value="" #checkedSelect("", form.cdms_id)# >-</option>';
					for (var x=1; x<=companysDms.recordcount; x++){
						view &= '<option value="#companysDms.cdms_id[x]#" #checkedSelect("#companysDms.cdms_id[x]#", form.cdms_id)# #IIF(companysDms.cdms_status[x] is 1, DE(''), DE('disabled'))#>#companysDms.cdms_name[x]#</option>';
					}
					view &= ' </select>';

		if (instance.cdmsID is not ''){
		view &= '		<label for="cdms_id" class="error" generated="0">#instance.cdmsID#</label>';
		}

		view &= '
				</div>
				<div>
					<label for="ptdns_description"><b>Описание:</b></label>
					<textarea name = "ptdms_description" rows="6" cols="47" >#form.ptdms_description#</textarea>';
		if (instance.ptdmsDescription is not ''){
			view &= '		<label for="ptdms_description" class="error" generated="0">#instance.ptdmsDescription#</label>';
		}


		view &= '	</div><div>
				<input type="hidden" name="ptdms_status" value="#form.ptdms_status#" size = "2" maxlength = "2">
				<hr>
				<input disabled class="g-button g-button-submit" type="submit" name="escape" value="Отмена">
				<input class="g-button g-button-submit" type="submit" name="addDMS" value="Сохранить"> ';

		if (instance.message is not ''){
			view &= '<div id="mes" style="color:red;">#instance.message#</div>';
		}

		view &='</div></form>
			</div></div>';

			// ------------------------------------------------ форма ---------------------------------------------------------------
		return view;
	}

	private function updateDMSFormHandler(){
		if ( isdefined('form.updateDMS') ){

		var patientsAPI = factoryService.getService('patientsAPI');
		  result = patientsAPI.editeDMS( #form.ptdms_id#, #form.pt_id#, #form.cdms_id#, #form.ptdms_polis_number#, #form.ptdms_description#, #form.ptdms_status# );
			if ( result.RETVAL is 1 ){
				factoryService.getService('redirector').redirect('#request.CRequest.updateURL(false,"/?page=patients&section=patient&action=view&patientid=#form.pt_id#")#');
			}else{
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
	}

	function updateDMSForm(ptdmsid){

		companysDms = factoryService.getService('companysDmsAPI').getCompanysDmsList();
		patient_dms = factoryService.getService('patientsAPI').getPatientDms(arguments.ptdmsid,'');

		param name='form.ptdms_id' default='#patient_dms.ptdms_id#';		// id пациента
		param name='form.pt_id' default='#patient_dms.pt_id#';		// id пациента
		param name='form.cdms_id' default='#patient_dms.cdms_id#';
		param name='form.ptdms_polis_number' default='#patient_dms.ptdms_polis_number#';
		param name='form.ptdms_description' default='#patient_dms.ptdms_description#';
		param name='form.ptdms_status' default='#patient_dms.ptdms_status#';

		// ---------------------------------------------------------- форма ---------------------------------------------------------------
		action = '#request.CRequest.updateURL(false,"/?page=patients&section=dms&action=edite&ptdmsid=#patient_dms.ptdms_id#")#';

		view = '';
		view &= '<div class="grid_8">
			<div class="signin-box">
			<a class="g-button g-button-submit" href="#request.CRequest.updateURL(false,"/?page=patients&section=patient&action=view&patientid=#patient_dms.pt_id#")#">Назад</a><br><br>
			<h2>Добавление информации ДМС:</h2>
			<form id="addDMS" name="addDMS" action="#action#" method="post">
				<div>
					<input type="hidden" id="ptdms_id" name="ptdms_id" value="#form.ptdms_id#" maxlength="50" size="20">
					<input type="hidden" id="pt_id" name="pt_id" value="#form.pt_id#" maxlength="50" size="20">';

		view &= '	</div>
				<div>
					<label>Номер полиса:</label>
					<input class="phone" type="text" id="ptdms_polis_number" name="ptdms_polis_number" value="#form.ptdms_polis_number#" maxlength="50" size="12">';
   		if (instance.ptdmsPolisNumber is not ''){
		view &= '		<label for="ptdmsPolisNumber" class="error" generated="2">#instance.ptdmsPolisNumber#</label>';
		}

		view &= '	</div>
				<div>
					<label for="cdms_id"><b>Компания ДМС:</b></label>
					<select name="cdms_id">
					<option value="" #checkedSelect("", form.cdms_id)# >-</option>';
					for (var x=1; x<=companysDms.recordcount; x++){
						view &= '<option value="#companysDms.cdms_id[x]#" #checkedSelect("#companysDms.cdms_id[x]#", form.cdms_id)# #IIF(companysDms.cdms_status[x] is 1, DE(''), DE('disabled'))#>#companysDms.cdms_name[x]#</option>';
					}
					view &= ' </select>';

		if (instance.cdmsID is not ''){
		view &= '		<label for="cdms_id" class="error" generated="0">#instance.cdmsID#</label>';
		}

		view &= '
				</div>
				<div>
					<label for="ptdns_description"><b>Описание:</b></label>
					<textarea name = "ptdms_description" rows="6" cols="47" >#form.ptdms_description#</textarea>';
		if (instance.ptdmsDescription is not ''){
			view &= '		<label for="ptdms_description" class="error" generated="0">#instance.ptdmsDescription#</label>';
		}


		view &= '	</div><div>
				<input type="hidden" name="ptdms_status" value="#form.ptdms_status#" size = "2" maxlength = "2">
				<hr>
				<input disabled class="g-button g-button-submit" type="submit" name="escape" value="Отмена">
				<input class="g-button g-button-submit" type="submit" name="updateDMS" value="Сохранить"> ';

		if (instance.message is not ''){
			view &= '<div id="mes" style="color:red;">#instance.message#</div>';
		}

		view &='</div></form>
			</div></div>';

			// ------------------------------------------------ форма ---------------------------------------------------------------
		return view;
	}

	/*
	function document(ptID){
		return factoryService.getService('pdf').createPDF(arguments.ptID);
	}
	*/


	function View() {
		return instance.view;
  	}

}