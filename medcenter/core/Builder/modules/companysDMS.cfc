/* 
	Виджет список компаний ДМС --
*/

component attributeName='companyDMS' output='false'{
	// псевдо конструктор
	factoryService = request.factoryService;

	instance.view = '';
	instance.message = '';
	instance.RBAC = '';

	instance.cdmsName = '';
	instance.cdmsContractNumber = '';
	instance.cdmsDateStart = '';
	instance.cdmsDateEnd = '';
	instance.cdmsDescription = '';
	instance.cdmsStatus = '';

	instance.reportDateStart = '';
	instance.reportDateEnd = '';

	instance.table = '';

	function Init(string section, string action) {
		section = arguments.section;
		action = arguments.action;

		if (section == 'false'){
			companysDmsListFormHandler();
			instance.view = companysDmsListForm();

		}else if( section == 'companyDMS' ){
			if( action == 'add' ){
				addCompanyDMSFormHandler();
				instance.view = addCompanyDMSForm();

			}else if( action == 'edite' ){
				cdmsid = request.CRequest.getUrl('cdmsid');
				updateCompanyDMSFormHandler(); 
				instance.view = updateCompanyDMSForm(cdmsid);

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

	private function addCompanyDMSFormHandler(){
		// --- обработчик формы---
		if ( isdefined('form.addCompanyDMS') ){

		  companysDmsAPI = factoryService.getService('companysDmsAPI');
		      result = companysDmsAPI.addCompanyDMS( #form.cdms_name# , #form.cdms_contract_number#, #form.cdms_date_start#, #form.cdms_date_end#, #form.cdms_description#, #form.cdms_status# );
			if ( result.RETVAL is 1 ){
				factoryService.getService('redirector').redirect('/?page=companysDms');
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

	function addCompanyDMSForm(){

		param name='form.cdms_name' default='';
		param name='form.cdms_contract_number' default='';
		param name='form.cdms_date_start' default='';
		param name='form.cdms_date_end' default='';
		param name='form.cdms_description' default='';
		param name='form.cdms_status' default='';

		var view = '';
		view &= '
			<form name="" id="" action="#request.CRequest.updateURL(false,"/?page=companysDms&section=companyDms&action=add")#" method="post">
			<div class="grid_8"><div class="signin-box">
				<a class="g-button g-button-submit" href="#request.CRequest.updateURL(false,"/?page=companysDms")#">Назад</a><br><br>
				<h2>Добавление компании ДМС</h2>
				<div>
					<label for="cdms_name"><b>Наименование компании ДМС:</b></label> 
					<input type="text" name="cdms_name" value="#form.cdms_name#" size = "50" maxlength = "250">';

			if (instance.cdmsName is not ''){
			view &= '		<label for="cdms_name" class="error" generated="0">#instance.cdmsName#</label>';
			}

			view &= '
				</div>
				<div>
					<label for="cdms_contract_number"><b>Номер договора:</b></label>
					<input type="text" name="cdms_contract_number" value="#form.cdms_contract_number#" size="10" maxlength="10"/>';

			if (instance.cdmsContractNumber is not ''){
			view &= '		<label for="cdms_contract_number" class="error" generated="0">#instance.cdmsContractNumber#</label>';
			}

			view &= '
				</div>
				<div>
					<label for="cdms_date_start"><b>Дата заключения договора:</b></label>
					<input type="text" name="cdms_date_start" value="#form.cdms_date_start#" size="10" maxlength="10"/>';

			if (instance.cdmsDateStart is not ''){
			view &= '		<label for="cdms_date_start" class="error" generated="0">#instance.cdmsDateStart#</label>';
			}

			view &= '
				</div>
				<div>
					<label for="cdms_date_end"><b>Дата окончания договора:</b></label>
					<input type="text" name="cdms_date_end" value="#form.cdms_date_end#" size="10" maxlength="10"/>';

			if (instance.cdmsDateEnd is not ''){
			view &= '		<label for="cdms_date_end" class="error" generated="0">#instance.cdmsDateEnd#</label>';
			}

			view &= '
				</div>
				<div>
					<label for="cdms_description"><b>Описание:</b></label>
					<textarea name = "cdms_description" rows="6" cols="47" >#form.cdms_description#</textarea>';

			if (instance.cdmsDescription is not ''){
			view &= '		<label for="cdms_description" class="error" generated="0">#instance.cdmsDescription#</label>';
			}


			view &= '</div>
				<div>
					<label for="cdms_status"><b>Статус:</b></label> 
					<input type="radio" name="cdms_status" value="1" #checkedRadio("1", form.cdms_status)# /> Включена <br>
					<input type="radio" name="cdms_status" value="0" #checkedRadio("0", form.cdms_status)#/> Выключена <br>
				</div>';

			if (instance.cdmsStatus is not ''){
			view &= '		<label for="cdms_status" class="error" generated="0">#instance.cdmsStatus#</label>';
			}

			view &= '
				<div>
					<input disabled class="g-button g-button-submit" type="submit" name="escape" value="Отмена">
					<input class="g-button g-button-submit" type="submit" name="addCompanyDMS" value="Сохранить">
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

	private function updateCompanyDMSFormHandler(){
		// --- обработчик формы---
		if ( isdefined('form.updateCompanyDMS') ){

		  companysDmsAPI = factoryService.getService('companysDmsAPI');
		      result = companysDmsAPI.editeCompanyDMS( #form.cdms_id#, #form.cdms_name#, #form.cdms_contract_number#, #form.cdms_date_start#, #form.cdms_date_end#, #form.cdms_description#, #form.cdms_status# );
			if ( result.RETVAL is 1 ){
				factoryService.getService('redirector').redirect('/?page=companysDms');
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

	function updateCompanyDMSForm(cdmsid){

		companysDmsAPI = factoryService.getService( 'companysDmsAPI' );
		qCompanysDms = companysDmsAPI.getCompanyDms( arguments.cdmsid );

		param name='form.cdms_id' default='#qCompanysDms.cdms_id#';
		param name='form.cdms_name' default='#qCompanysDms.cdms_name#';
		param name='form.cdms_contract_number' default='#qCompanysDms.cdms_contract_number#';
		param name='form.cdms_date_start' default='#qCompanysDms.cdms_date_start#';
		param name='form.cdms_date_end' default='#qCompanysDms.cdms_date_end#';
		param name='form.cdms_description' default='#qCompanysDms.cdms_description#';
		param name='form.cdms_status' default='#qCompanysDms.cdms_status#';

		var view = '';
		view &= '
			<form name="" id="" action="#request.CRequest.updateURL(false,"/?page=companysDms&section=companyDms&action=edite&cdmsid=#arguments.cdmsid#")#" method="post">
			<div class="grid_8"><div class="signin-box">
				<a class="g-button g-button-submit" href="#request.CRequest.updateURL(false,"/?page=companysDms")#">Назад</a><br><br>
				<h2>Добавление компании ДМС</h2>
				<div>
					<label for="cdms_id"><b>ID компании ДМС:</b></label>
					<input disabled type="text" name="_cdms_id" value="#form.cdms_id#" size = "2" maxlength = "2">
					<input type="hidden" name="cdms_id" value="#form.cdms_id#" size = "2" maxlength = "2">
				</div>
				<div>
					<label for="cdms_name"><b>Наименование компании ДМС:</b></label> 
					<input type="text" name="cdms_name" value="#form.cdms_name#" size = "50" maxlength = "250">';

			if (instance.cdmsName is not ''){
			view &= '		<label for="cdms_name" class="error" generated="0">#instance.cdmsName#</label>';
			}

			view &= '
				</div>
				<div>
					<label for="cdms_contract_number"><b>Номер договора:</b></label>
					<input type="text" name="cdms_contract_number" value="#form.cdms_contract_number#" size="10" maxlength="10"/>';

			if (instance.cdmsContractNumber is not ''){
			view &= '		<label for="cdms_contract_number" class="error" generated="0">#instance.cdmsContractNumber#</label>';
			}

			view &= '
				</div>
				<div>
					<label for="cdms_date_start"><b>Дата заключения договора:</b></label>
					<input type="text" name="cdms_date_start" value="#form.cdms_date_start#" size="10" maxlength="10"/>';

			if (instance.cdmsDateStart is not ''){
			view &= '		<label for="cdms_date_start" class="error" generated="0">#instance.cdmsDateStart#</label>';
			}

			view &= '
				</div>
				<div>
					<label for="cdms_date_end"><b>Дата окончания договора:</b></label>
					<input type="text" name="cdms_date_end" value="#form.cdms_date_end#" size="10" maxlength="10"/>';

			if (instance.cdmsDateEnd is not ''){
			view &= '		<label for="cdms_date_end" class="error" generated="0">#instance.cdmsDateEnd#</label>';
			}

			view &= '
				</div>
				<div>
					<label for="cdms_description"><b>Описание:</b></label>
					<textarea name = "cdms_description" rows="6" cols="47" >#form.cdms_description#</textarea>';

			if (instance.cdmsDescription is not ''){
			view &= '		<label for="cdms_description" class="error" generated="0">#instance.cdmsDescription#</label>';
			}


			view &= '</div>
				<div>
					<label for="cdms_status"><b>Статус:</b></label> 
					<input type="radio" name="cdms_status" value="1" #checkedRadio("1", form.cdms_status)# /> Включена <br>
					<input type="radio" name="cdms_status" value="0" #checkedRadio("0", form.cdms_status)#/> Выключена <br>
				</div>';

			if (instance.cdmsStatus is not ''){
			view &= '		<label for="cdms_status" class="error" generated="0">#instance.cdmsStatus#</label>';
			}

			view &= '
				<div>
					<input disabled class="g-button g-button-submit" type="submit" name="escape" value="Отмена">
					<input class="g-button g-button-submit" type="submit" name="updateCompanyDMS" value="Сохранить">
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

	function companysDmsListFormHandler(){
		//
		report = '';
		if ( isdefined('form.reportDMS') ){
			result = factoryService.getService('companysDmsAPI').getCompanysDmsReport( #form.report_date_start#, #form.report_date_end#, #form.cdms_id#);
			//writeDump(result);
			report = '';

			if ( result.RETVAL is 1 ){
				report = 'Отчёт с #form.report_date_start# - по #form.report_date_end# - #form.cdms_id# - #now()#';
				companysDmsReport = result.RETDATA;

			}else{
				// --- пробная версия
				if ( result.RETDESC is '') {
					instance.message = '';
				} else {
					instance.message = '#result.RETDESC#';
				}
				if (StructKeyExists(result.STRUCT, 'reportDateStart')) {
					instance.reportDateStart = result.STRUCT['reportDateStart'];
				} else {
					instance.reportDateStart = '';
				}
				if (StructKeyExists(result.STRUCT, 'reportDateEnd')) {
					instance.reportDateEnd = result.STRUCT['reportDateEnd'];
				} else {
					instance.reportDateEnd = '';
				}
			}

		}else if ( isdefined('form.reportDMSXLS') ){
			result = factoryService.getService('companysDmsAPI').getCompanysDmsReport( #form.report_date_start#, #form.report_date_end#, #form.cdms_id#);
			if ( result.RETVAL is 1 ){
			report = '';
			companysDmsReport = result.RETDATA;
				if (companysDmsReport.recordcount){
					report &= '<table border="1">
							<tr>
								<th>№</th>
								<th>id пц</th>
								<th>Полис</th>
								<th>ФИО</th>
								<th>id приема</th>
								<th>Дата приема</th>
								<th>Доктор</th>
								<th>id услуги по прайсу</th>
								<th>Наименование услуги</th>
								<th>Диагноз</th>
								<th>Цена</th>
							</tr>';

					tempMass = arrayNew(1);
					cnt = 1;
					cnt_= 1;
					for ( x=1; x<=companysDmsReport.recordcount; x++){
						//var class = IIF(cnt MOD 2, DE('tr_hover'), DE('tr_hover1'));
						if (companysDmsReport.rp_id[x] != companysDmsReport.rp_id[x-1]){
							tempMass[x] = '<tr>
								<td style="vertical-align:middle;" rowspan="@@">#cnt#</td>
								<td style="vertical-align:middle;" rowspan="@@">#companysDmsReport.pt_id[x]#</td>
								<td style="vertical-align:middle;" rowspan="@@">#companysDmsReport.ptdms_polis_number[x]#</td>
								<td style="vertical-align:middle;" rowspan="@@">#companysDmsReport.pt_family[x]# #companysDmsReport.pt_firstname[x]# #companysDmsReport.pt_lastname[x]#</td>
								<td style="vertical-align:middle;" rowspan="@@"><a  target="_blank" href="#request.CRequest.updateURL(false,"/?page=cabinet&section=reception&action=view&rpid=#companysDmsReport.rp_id[x]#")#">#companysDmsReport.rp_id[x]#</a></td>
								<td style="vertical-align:middle;" rowspan="@@">#dateFormat(companysDmsReport.rp_date[x],"dd/mm/yyyy")#</td>
								<td style="vertical-align:middle;" rowspan="@@">#Left(companysDmsReport.emp_firstname[x],1)#.#Left(companysDmsReport.emp_lastname[x],1)#. #companysDmsReport.emp_family[x]#</td>
								<td>#companysDmsReport.pls_id[x]#</td>
								<td>#companysDmsReport.sv_name[x]#</td>
								<td></td>
								<td>#round(companysDmsReport.sv_price[x])#</td>
							</tr>';
							cnt += 1;
							cnt_ = 1;
						}else{
							tempMass[x-cnt_] = rereplace(tempMass[x-cnt_], '@[0-9]{0,2}@', "@#val(cnt_+1)#@", "all");
							tempMass[x] = '<tr>
								<td>#companysDmsReport.pls_id[x]#</td>
								<td>#companysDmsReport.sv_name[x]#</td>
								<td></td>
								<td>#round(companysDmsReport.sv_price[x])#</td>
							</tr>';
							cnt_+= 1;

						}

					}
					//writeDump(tempMass);
					for (x=1; x<= arrayLen(tempMass); x++){
						report &= replace(tempMass[x], '@', "", "all");
					}
					report &= '<tr><td style="text-align:right;" colspan="10">ИТОГО:</td><td>=СУММ(K2:K#val(companysDmsReport.recordcount+1)#)</td></tr>';
					report &= '</table>';
				}
				serveFile("report.xls","#report#");

			}else{
				/*if ( result.RETDESC is '') {
					instance.message = '';
				} else {
					instance.message = '#result.RETDESC#';
				}*/
			}

		}
	}

	function companysDmsListForm(){

		companysDmsList = factoryService.getService('companysDmsAPI').getCompanysDmsList();

		var view = '';
		view &= '<div class="grid_16"><div class="signin-box"><h2>Список компаний ДМС:</h2>';
			view &= '<table class="td_head" width="100%">
						<tr><td style="text-align:right;" colspan="11"><a class="g-button g-button-submit" href="/?page=companysDms&section=companyDMS&action=add">+Добавить услугу</a></td></tr>

						<tr>
						<th>id</th>
						<th>Наименование</th>
						<th>Номер договора</th>
						<th>Дата начала</th>
						<th>Дата окончания</th>
						<th>Кол-во пц</th>
						<th>Описание</th>
						<th>Статус</th>
						<th> --- </th>
						</tr>';
			if ( companysDmsList.recordcount ){
			for (var x=1; x<=companysDmsList.recordcount; x++){
						var class = IIF(x MOD 2, DE('tr_hover'), DE('tr_hover1'));
						view &= '<tr class="#class#">
						<td>#companysDmsList.cdms_id[x]#&nbsp;</td> 
						<td style="text-align:left;">#companysDmsList.cdms_name[x]#</td>
						<td>#companysDmsList.cdms_contract_number[x]#</td>
						<td>#DateFormat(companysDmsList.cdms_date_start[x], "dd-mm-yyyy")#</td>
						<td>#DateFormat(companysDmsList.cdms_date_end[x], "dd-mm-yyyy")#</td>
						<td>#companysDmsList.cnt[x]#</td>
						<td>#companysDmsList.cdms_description[x]#</td>
						<td>#IIF(companysDmsList.cdms_status[x] is 1, DE('<font color="green">вкл</font>'), DE('<font color="red">выкл</font>'))#</td>
						<td nowrap><a href="/?page=companysDms&section=companyDms&action=edite&cdmsid=#companysDmsList.cdms_id[x]#">Ред.</a> | 
							<a href="/?page=companysDms&section=companyDms&action=delete&plsid=#companysDmsList.cdms_id[x]#">Удл.</a></td>
						</tr>';
			}
			}else{
						view &= '<tr>
						<td colspan="9"> В базе нет компаний. </td> 
						</tr>';
			}

			view &= '<tr><td style="text-align:right;" colspan="11"><a class="g-button g-button-submit" href="/?page=companysDms&section=companyDMS&action=add">+Добавить услугу</a></td></tr>';

			view &= '</table>';


			param name='form.report_date_start' default='#dateFormat( now(),'YYYY.MM.DD')#';
			param name='form.report_date_end' default='#dateFormat( now(),'YYYY.MM.DD')#';
			param name='form.cdms_id' default='';

			view &= '<hr>
				<form name="reportDMS" action="#request.CRequest.updateURL(false,"/?page=companysDms")#" method="post">

					<b>Дата начала:</b>
					<input class="date" type="text" name="report_date_start" value="#form.report_date_start#" size="6" maxlength="10"/>
					&nbsp;&nbsp;<b>Дата окончания:</b>
					<input class="date" type="text" name="report_date_end" value="#form.report_date_end#" size="6" maxlength="10"/> ';

					view &= '&nbsp;&nbsp;<b>ДМС:</b> <select name="cdms_id">
					<option value="" #checkedSelect("", form.cdms_id)# >-</option>';
					for (var x=1; x<=companysDmsList.recordcount; x++){
						view &= '<option value="#companysDmsList.cdms_id[x]#" #checkedSelect("#companysDmsList.cdms_id[x]#", form.cdms_id)# >#companysDmsList.cdms_name[x]#</option>';
					}
					view &= ' </select>';

				view &= '&nbsp;&nbsp;<input class="g-button g-button-submit" type="submit" name="reportDMS" value="Создать отчёт"> 
					&nbsp;<input class="g-button g-button-submit" type="submit" name="reportDMSXLS" value="XLS">
				</form>
				<br><hr>';

			if (instance.message is not ''){
				view &= '<div id="mes" style="color:red;">#instance.message#</div>';
			}
			if (instance.reportDateStart is not ''){
				view &= '<div id="mes" style="color:red;">#instance.reportDateStart#</div>';
			}
			if (instance.reportDateEnd is not ''){
				view &= '<div id="mes" style="color:red;">#instance.reportDateEnd#</div>';
			}

			if (report is not ''){
				view &= '#report#';
				//writeDump(companysDmsReport);
				if (companysDmsReport.recordcount){
					view &= '<table class="td_head" width="100%">
							<tr>
								<th>№</th>
								<th>id пц</th>
								<th>Полис</th>
								<th>ФИО</th>
								<th>id приема</th>
								<th>Дата приема</th>
								<th>Доктор</th>
								<th title="ID услуги по прайсу">id</th>
								<th>Наименование услуги</th>
								<th>Диагноз</th>
								<th>Цена</th>
							</tr>';

					tempMass = arrayNew(1);
					cnt = 1;
					cnt_= 1;
					for ( x=1; x<=companysDmsReport.recordcount; x++){
						//var class = IIF(cnt MOD 2, DE('tr_hover'), DE('tr_hover1'));
						if (companysDmsReport.rp_id[x] != companysDmsReport.rp_id[x-1]){
							tempMass[x] = '<tr class="#IIF(cnt MOD 2, DE('tr_hover'), DE('tr_hover1'))#">
								<td style="vertical-align:middle;" rowspan="@@">#cnt#</td>
								<td style="vertical-align:middle;" rowspan="@@">#companysDmsReport.pt_id[x]#</td>
								<td style="vertical-align:middle;" rowspan="@@">#companysDmsReport.ptdms_polis_number[x]#</td>
								<td style="vertical-align:middle;" rowspan="@@">#companysDmsReport.pt_family[x]# #companysDmsReport.pt_firstname[x]# #companysDmsReport.pt_lastname[x]#</td>
								<td style="vertical-align:middle;" rowspan="@@"><a  target="_blank" href="#request.CRequest.updateURL(false,"/?page=cabinet&section=reception&action=view&rpid=#companysDmsReport.rp_id[x]#")#">#companysDmsReport.rp_id[x]#</a></td>
								<td style="vertical-align:middle;" rowspan="@@">#dateFormat(companysDmsReport.rp_date[x],"dd/mm/yyyy")#</td>
								<td style="vertical-align:middle;" rowspan="@@">#Left(companysDmsReport.emp_firstname[x],1)#.#Left(companysDmsReport.emp_lastname[x],1)#. #companysDmsReport.emp_family[x]#</td>
								<td>#companysDmsReport.pls_id[x]#</td>
								<td>#companysDmsReport.sv_name[x]#</td>
								<td></td>
								<td>#round(companysDmsReport.sv_price[x])#</td>
							</tr>';
							cnt += 1;
							cnt_ = 1;
						}else{
							tempMass[x-cnt_] = rereplace(tempMass[x-cnt_], '@[0-9]{0,2}@', "@#val(cnt_+1)#@", "all");
							tempMass[x] = '<tr class="#IIF(val(cnt-1) MOD 2, DE('tr_hover'), DE('tr_hover1'))#">
								<td>#companysDmsReport.pls_id[x]#</td>
								<td>#companysDmsReport.sv_name[x]#</td>
								<td></td>
								<td>#round(companysDmsReport.sv_price[x])#</td>
							</tr>';
							cnt_+= 1;

						}

					}
					//writeDump(tempMass);
					for (x=1; x<= arrayLen(tempMass); x++){
						view &= replace(tempMass[x], '@', "", "all");
					}
					view &= '</table>';
				}else{
					view &= ' <font color="red">Поданной компании, в заданном временном диапазоне нет записей!</font>';
				}
			}

			view &= '</div></div>';

		return view;
	}

	function checkedSelect( value, status ){
		if (arguments.value == arguments.status){
			return 'selected';
		}else{
			return '';
		}
	}

	function View() {
		return instance.view;
  	}

	//<cfheader name="Content-Disposition" value="inline; filename=acmesalesQ1.xls"> 
	//<cfcontent type="application/vnd.msexcel">
	private void function serveFile(string filePath, string content){
	        var fileContent = '#arguments.content#';
       
	        var context = getPageContext();
        	context.setFlushOutput(false); 
       
	        var response = context.getResponse().getResponse();
        	response.reset();
	        response.setContentType("application/vnd.msexcel;charset=windows-1251");   
        	response.setContentLength(len(fileContent));       
	        //response.setHeader("Content-Disposition","attachment; filename=#listLast(filePath,'\')#");
	        response.setHeader("Content-Disposition","attachment; filename=#listLast(filePath,'\')#");
       
	        var out = response.getOutputStream();     
        	out.write(ToBinary(ToBase64(fileContent)));
	        out.flush();       
	        out.close();
	}

}