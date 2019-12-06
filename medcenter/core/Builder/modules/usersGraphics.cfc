/* 
	������ ����� ������ ������ --
*/

component attributeName='usersGraphics' output='false'{
	// ������ �����������
	factoryService = request.factoryService;
	instance.view = '';

	instance.grType = '';
	instance.grDate = '';
	instance.grStartTime = '';
	instance.grEndTime = '';
	instance.grStatus = '';

	instance.message = '';
	instance.RBAC = '';

	function Init(string section, string action) {
		section = arguments.section;
		action = arguments.action;


		if (section == 'false'){
			Date = request.CRequest.getUrl('date');
			instance.view = usersGraphicsListForm(date);

		}else if( section == 'userGraphics' ){
			if( action == 'view' ){
				userid = request.CRequest.getUrl('userid');
				Date = request.CRequest.getUrl('date');
				instance.view = userGraphicsListForm(userid,Date);

			}else if( action == 'add'){
				userid = request.CRequest.getUrl('userid');
				date = request.CRequest.getUrl('date'); 	
				addUserGraphicFormHandler(userid,date);
				instance.view = addUserGraphicForm(userid,date);

			}else if( action == 'edite' ){
				userid = request.CRequest.getUrl('userid');
				stid = request.CRequest.getUrl('grid');
				updateUserGraphicFormHandler(); 
				instance.view = updateUserGraphicForm(userID, grID);

			}else if( action == 'delete'){
				//instance.view = 'delete group';
			}
		}
		return this;

	}

	function getWeekNameShort(n) {
		vk = ArrayNew(1);
		vk[1] = "<font color='red'>��</font>";
		vk[2] = "��";
		vk[3] = "��";
		vk[4] = "��";
		vk[5] = "��";
		vk[6] = "��";
		vk[7] = "<font color='red'>��</font>";
		return vk[n];
	}

	function getTypeDay(n) {
		vk = '';
		if (n == 2){
			vk = "<b><font color='##27408B'>�</font></b>";
		}else if ( n == 3){
			vk = "<b><font color='##FF4500'>�</font></b>";
		}else if( n == 4){
			vk = "<b><font color='red'>�</font></b>";
		}else{
			vk = "<b><font style='font-size:9px;' color='##1F4A14'>#n#</font></b>";
		}

		return vk;
	}

	function checkedRadio( value, status ){
		if (arguments.value == arguments.status){
			return 'checked';
		}else{
			return '';
		}
	}

	private function addUserGraphicFormHandler(userID,date){
		// --- ���������� �����---
		if ( isdefined('form.addUserGraphic') ){

		if ( form.gr_type == 1){
			form.gr_starttime = '#form.workTimeHStart#:#form.workTimeMStart#';
			form.gr_endtime = '#form.workTimeHEnd#:#form.workTimeMEnd#';
		}else{
			form.gr_starttime = '';
			form.gr_endtime = '';
		}
		//writeDump(form);
		var userGraphic = factoryService.getService('usersGraphicsAPI');
		  result = userGraphic.addUserGraphic( #form.user_id#, #form.gr_type#, #form.gr_date#, #form.gr_starttime#, #form.gr_endtime#, #form.gr_status# );
			//result.RETVAL = 1;
			if ( result.RETVAL is 1 ){
				factoryService.getService('redirector').redirect('#request.CRequest.updateURL(false,"/?page=usersGraphics&section=userGraphics&action=view&userid=#arguments.userID#")#');
			}else{
				// --- ������� ������
				if ( result.RETDESC is '') {
					instance.message = '';
				} else {
					instance.message = '#result.RETDESC#';
				}


				if (StructKeyExists(result.STRUCT, 'grType')) {
					instance.grType = result.STRUCT['grType'];
				} else {
					instance.grType = '';
				}
				if (StructKeyExists(result.STRUCT, 'grDate')) {
					instance.grDate = result.STRUCT['grDate'];
				} else {
					instance.grDate = '';
				}
				if (StructKeyExists(result.STRUCT, 'grStartTime')) {
					instance.grStartTime = result.STRUCT['grStartTime'];
				} else {
					instance.grStartTime = '';
				}
				if (StructKeyExists(result.STRUCT, 'grEndTime')) {
					instance.grEndTime = result.STRUCT['grEndTime'];
				} else {
					instance.grEndTime = '';
				}
				if (StructKeyExists(result.STRUCT, 'grStatus')) {
					instance.grStatus = result.STRUCT['grStatus'];
				} else {
					instance.grStatus = '';
				}

				if (StructKeyExists(result.STRUCT, 'RBAC')) {
					instance.RBAC = result.STRUCT['RBAC'];
				} else {
					instance.RBAC = '';
				}

			}
		}
		// --- ���������� �����---
	}

	function addUserGraphicForm(userID,date){
		//param name='form.gr_id' default='#userGraphic.gr_id#';
		param name='form.user_id' default='#arguments.userID#';
		param name='form.gr_type' default='1';
		param name='form.gr_date' default='#DateFormat(arguments.date)#';
		param name='form.gr_starttime' default='';
		param name='form.workTimeHStart' default='00';
		param name='form.workTimeMStart' default='00';
		param name='form.gr_endtime' default='';
		param name='form.workTimeHEnd' default='00';
		param name='form.workTimeMEnd' default='00';
		param name='form.gr_status' default='1';

		// ---------------------------------------------------------- ����� ---------------------------------------------------------------
		view = '';
		view &= '<div class="grid_8">
			<div class="signin-box">
			<a class="g-button g-button-submit" href="#request.CRequest.updateURL(false,"/?page=usersGraphics&section=userGraphics&action=view&userid=#arguments.userID#")#">�����</a><br><br>
			<h2>���������� �������:</h2>
			<form name="" action="#request.CRequest.updateURL(false,"/?page=usersGraphics&section=userGraphics&action=add&userid=#arguments.userID#&date=#arguments.date#")#" method="post">
				<div>
					<label for="user_id"><b>ID ������������:</b></label>
					<input disabled type="text" name="_user_id" value="#form.user_id#" size = "2" maxlength = "2">
					<input type="hidden" name="user_id" value="#form.user_id#" size = "2" maxlength = "2">
				</div>';


			view &= '
				<div>
					<label for="gr_type"><b>��� ��������:</b></label> 
					<input type="radio" name="gr_type" value="1" #checkedRadio("1", form.gr_type)# /> ������� ���� <br>
					<input type="radio" name="gr_type" value="2" #checkedRadio("2", form.gr_type)#/> �������� ���� <br>
					<input type="radio" name="gr_type" value="3" #checkedRadio("3", form.gr_type)#/> ������ <br>
					<input type="radio" name="gr_type" value="4" #checkedRadio("4", form.gr_type)#/> ���������� <br>
				';

			if (instance.grType is not ''){
			view &= '		<label for="gr_type" class="error" generated="0">#instance.grType#</label>';
			}

			view &= '</div>
				<div>
					<hr>
					<label>����:</label>
					<p>#_DateFormate(form.gr_date)#</p>
					<input type="hidden" name="gr_date" value="#form.gr_date#" size="20" maxlength="20">';

	   		if (instance.grDate is not ''){
				view &= '		<label for="gr_date" class="error" generated="3">#instance.grDate#</label>';
			}

			view &= '</div>
				<div>
					<label>������ �������� ���:</label>';
				view &= ' <select name="workTimeHStart">';
					    for ( var x=8; x<=20; x++){
					     view &= '<option value="#x#" #_DateCompare( x, form.gr_starttime, "HH")#>#numberformat(x,"09")#</option>';
					    }
				view &= ' </select>
					  <select name="workTimeMStart">';
					    for ( var x=0; x<=59; x=x+5){
					    view &= '<option value="#x#" #_DateCompare( x, form.gr_starttime, "MM")#>#numberformat(x,"09")#</option>';
					    }
				view &= '  </select>';


	   		if (instance.grStartTime is not ''){
				view &= '		<label for="gr_starttime" class="error" generated="3">#instance.grStartTime#</label>';
			}

			view &= '</div>
				<div>
					<label>����� �������� ���:</label>';
				view &= ' <select name="workTimeHEnd">';
					    for ( var x=8; x<=20; x++){
					     view &= '<option value="#x#" #_DateCompare( x, form.gr_endtime, "HH")#>#numberformat(x,"09")#</option>';
					    }
				view &= ' </select>
					  <select name="workTimeMEnd">';
					    for ( var x=0; x<=59; x=x+5){
					    view &= '<option value="#x#" #_DateCompare( x, form.gr_endtime, "MM")#>#numberformat(x,"09")#</option>';
					    }
				view &= '  </select>';

	   		if (instance.grEndTime is not ''){
				view &= '		<label for="gr_endtime" class="error" generated="3">#instance.grEndTime#</label>';
			}

			view &= '</div>
				<div>
					<label for="gr_status"><b>������:</b></label> 
					<input type="radio" name="gr_status" value="1" #checkedRadio("1", form.gr_status)# /> �������� <br>
					<input type="radio" name="gr_status" value="0" #checkedRadio("0", form.gr_status)#/> ��������� <br>
				';

			if (instance.grStatus is not ''){
			view &= '		<label for="gr_status" class="error" generated="0">#instance.grStatus#</label>';
			}


			view &= '
				</div>
				<div>
					<input disabled class="g-button g-button-submit" type="submit" name="escape" value="������">
					<input class="g-button g-button-submit" type="submit" name="addUserGraphic" value="���������"> ';

			if (instance.message is not ''){
				view &= '<div id="mes" style="color:red;">#instance.message#</div>';
			}
			if (instance.RBAC is not ''){
				view &= '<div id="mes" style="color:red;">#instance.RBAC#</div>';
			}

		view &='</div></form>
			</div></div>';

			// ------------------------------------------------ ����� ---------------------------------------------------------------
		return view;
	}

	private function updateUserGraphicFormHandler(){
		// --- ���������� �����---
		if ( isdefined('form.updateUserGraphic') ){

		if ( form.gr_type == 1 ){
		form.gr_starttime = '#form.workTimeHStart#:#form.workTimeMStart#';
		form.gr_endtime = '#form.workTimeHEnd#:#form.workTimeMEnd#';
		}else{
		form.gr_starttime = '';
		form.gr_endtime = '';
		}

		var userGraphic = factoryService.getService('usersGraphicsAPI');
		  result = userGraphic.editeUserGraphic( #form.gr_id#, #form.user_id#, #form.gr_type#, #form.gr_date#, #form.gr_starttime#, #form.gr_endtime#, #form.gr_status# );
			//writeDump(form);
			//result.RETVAL = 1;
			if ( result.RETVAL is 1 ){
				if (StructKeyExists(result, 'RETDESC')) {
					instance.message = result['RETDESC'];
				} else {
					instance.message = '';
				}
			}else{
				// --- ������� ������
				if ( result.RETDESC is '') {
					instance.message = '';
				} else {
					instance.message = '#result.RETDESC#';
				}


				if (StructKeyExists(result.STRUCT, 'grType')) {
					instance.grType = result.STRUCT['grType'];
				} else {
					instance.grType = '';
				}
				if (StructKeyExists(result.STRUCT, 'grDate')) {
					instance.grDate = result.STRUCT['grDate'];
				} else {
					instance.grDate = '';
				}
				if (StructKeyExists(result.STRUCT, 'grStartTime')) {
					instance.grStartTime = result.STRUCT['grStartTime'];
				} else {
					instance.grStartTime = '';
				}
				if (StructKeyExists(result.STRUCT, 'grEndTime')) {
					instance.grEndTime = result.STRUCT['grEndTime'];
				} else {
					instance.grEndTime = '';
				}
				if (StructKeyExists(result.STRUCT, 'grStatus')) {
					instance.grStatus = result.STRUCT['grStatus'];
				} else {
					instance.grStatus = '';
				}
				if (StructKeyExists(result.STRUCT, 'RBAC')) {
					instance.RBAC = result.STRUCT['RBAC'];
				} else {
					instance.RBAC = '';
				}

			}
		}
		// --- ���������� �����---
	}

	function updateUserGraphicForm(userID, grID){

		userGraphic = factoryService.getService('usersGraphicsAPI').getUserGraphic( arguments.grID );

		param name='form.gr_id' default='#userGraphic.gr_id#';
		param name='form.user_id' default='#userGraphic.user_id#';
		param name='form.gr_type' default='#userGraphic.gr_type#';
		param name='form.gr_date' default='#userGraphic.gr_date#';
		param name='form.gr_starttime' default='#userGraphic.gr_starttime#';
		param name='form.workTimeHStart' default='00';
		param name='form.workTimeMStart' default='00';
		param name='form.gr_endtime' default='#userGraphic.gr_endtime#';
		param name='form.workTimeHEnd' default='00';
		param name='form.workTimeMEnd' default='00';
		param name='form.gr_status' default='#userGraphic.gr_status#';

		// ---------------------------------------------------------- ����� ---------------------------------------------------------------
		view = '';
		view &= '<div class="grid_8">
			<div class="signin-box">
			<a class="g-button g-button-submit" href="#request.CRequest.updateURL(false,"/?page=usersGraphics&section=userGraphics&action=view&userid=#arguments.userID#")#">�����</a><br><br>
			<h2>�������������� �������:</h2>
			<form name="" action="#request.CRequest.updateURL(false,"/?page=usersGraphics&section=userGraphics&action=edite&userid=#arguments.userID#&grid=#arguments.grID#")#" method="post">
				<div>
					<label for="gr_id"><b>ID:</b></label>
					<input disabled type="text" name="_gr_id" value="#form.gr_id#" size = "2" maxlength = "2">
					<input type="hidden" name="gr_id" value="#form.gr_id#" size = "2" maxlength = "2">
				</div>
				<div>
					<label for="user_id"><b>ID ������������:</b></label>
					<input disabled type="text" name="_user_id" value="#form.user_id#" size = "2" maxlength = "2">
					<input type="hidden" name="user_id" value="#form.user_id#" size = "2" maxlength = "2">
				</div>';


			view &= '
				<div>
					<label for="gr_type"><b>��� ��������:</b></label> 
					<input type="radio" name="gr_type" value="1" #checkedRadio("1", form.gr_type)# /> ������� ���� <br>
					<input type="radio" name="gr_type" value="2" #checkedRadio("2", form.gr_type)#/> �������� ���� <br>
					<input type="radio" name="gr_type" value="3" #checkedRadio("3", form.gr_type)#/> ������ <br>
					<input type="radio" name="gr_type" value="4" #checkedRadio("4", form.gr_type)#/> ���������� <br>
				';

			if (instance.grType is not ''){
			view &= '		<label for="gr_type" class="error" generated="0">#instance.grType#</label>';
			}

			view &= '</div>
				<div>
					<hr>
					<label>����:</label>
					<p>#_DateFormate(form.gr_date)#</p>
					<input type="hidden" name="gr_date" value="#form.gr_date#" size="20" maxlength="20">';

	   		if (instance.grDate is not ''){
				view &= '		<label for="gr_date" class="error" generated="3">#instance.grDate#</label>';
			}

			view &= '</div>
				<div>
					<label>������ �������� ���:</label>';
				view &= ' <select name="workTimeHStart">';
					    for ( var x=8; x<=20; x++){
					     view &= '<option value="#x#" #_DateCompare( x, form.gr_starttime, "HH")#>#numberformat(x,"09")#</option>';
					    }
				view &= ' </select>
					  <select name="workTimeMStart">';
					    for ( var x=0; x<=59; x=x+5){
					    view &= '<option value="#x#" #_DateCompare( x, form.gr_starttime, "MM")#>#numberformat(x,"09")#</option>';
					    }
				view &= '  </select>';


	   		if (instance.grStartTime is not ''){
				view &= '		<label for="gr_starttime" class="error" generated="3">#instance.grStartTime#</label>';
			}

			view &= '</div>
				<div>
					<label>����� �������� ���:</label>';
				view &= ' <select name="workTimeHEnd">';
					    for ( var x=8; x<=20; x++){
					     view &= '<option value="#x#" #_DateCompare( x, form.gr_endtime, "HH")#>#numberformat(x,"09")#</option>';
					    }
				view &= ' </select>
					  <select name="workTimeMEnd">';
					    for ( var x=0; x<=59; x=x+5){
					    view &= '<option value="#x#" #_DateCompare( x, form.gr_endtime, "MM")#>#numberformat(x,"09")#</option>';
					    }
				view &= '  </select>';

	   		if (instance.grEndTime is not ''){
				view &= '		<label for="gr_endtime" class="error" generated="3">#instance.grEndTime#</label>';
			}

			view &= '</div>
				<div>
					<label for="gr_status"><b>������:</b></label> 
					<input type="radio" name="gr_status" value="1" #checkedRadio("1", form.gr_status)# /> �������� <br>
					<input type="radio" name="gr_status" value="0" #checkedRadio("0", form.gr_status)#/> ��������� <br>
				';

			if (instance.grStatus is not ''){
			view &= '		<label for="gr_status" class="error" generated="0">#instance.grStatus#</label>';
			}


			view &= '
				</div>
				<div>
					<input disabled class="g-button g-button-submit" type="submit" name="escape" value="������">
					<input class="g-button g-button-submit" type="submit" name="updateUserGraphic" value="���������"> ';

			if (instance.message is not ''){
				view &= '<div id="mes" style="color:red;">#instance.message#</div>';
			}
			if (instance.RBAC is not ''){
				view &= '<div id="mes" style="color:red;">#instance.RBAC#</div>';
			}

		view &='</div></form>
			</div></div>';

			// ------------------------------------------------ ����� ---------------------------------------------------------------
		return view;
	}

	function userGraphicsListForm(userID,date){
		qUser = authorization = factoryService.getService( 'authorization' ).getUser( arguments.userid );

		if ( arguments.date == 'false' ){
			currentDate = createodbcdate(now()); //
		}else{
			date = arguments.date; //
			currentDate = createodbcdate(date);
		}

		currentDay = Day(currentDate);
		currentMonth = Month(currentDate);
		currentYear = Year(currentDate);
		DayInMonth = DaysInMonth(currentDate);

			firstDayInMonth = CreateDate( currentYear, currentMonth, 1);
			lastDayInMonth = CreateDate( currentYear, currentMonth, DayInMonth);
			userGraphics = factoryService.getService('usersGraphicsAPI');
			setUserGraphics = userGraphics.setUsersGraphicsList( arguments.userid, firstDayInMonth, lastDayInMonth);

		var view = '';
		view &= '<div class="grid_16"><div class="signin-box">
			<a class="g-button g-button-submit" href="#request.CRequest.updateURL(false,"/?page=usersGraphics")#">�����</a><br><br>
			<h2>������ ����� - #qUser.emp_family# #qUser.emp_firstname# #qUser.emp_lastname#:</h2><hr>';

			view &= '<table width="100%">

						<tr>
						<td class="block1" colspan="6">
							<a href="/?page=usersGraphics&section=userGraphics&action=view&userid=#arguments.userid#&date=#dateFormat(dateAdd('m', -1, currentDate),'YYYY.MM.DD')#"> << </a> 
								#MonthAsString(currentMonth)# #currentYear#
							<a href="/?page=usersGraphics&section=userGraphics&action=view&userid=#arguments.userid#&date=#dateFormat(dateAdd('m', +1, currentDate),'YYYY.MM.DD')#"> >> </a>
						</td>
						</tr>

						<tr style="color:grey;">
						<td>����</td> 
						<td>���</td> 
						<td>������</td>
						<td>�����</td>
						<td>������</td>
						<td> --- </td>
						</tr>';

        	for ( var y=1; y<=DayInMonth; y++){ 
			_Date = CreateDate( currentYear, currentMonth, y);
			userGraphic = userGraphics.getUserGraphics( arguments.userid, _Date);
			view &= '<tr #_style(_Date)#>';

			if (userGraphic.recordcount){
				view &= '<td>#_DateFormate(userGraphic.gr_date)# #getWeekNameShort(DayOfWeek(_Date))#</td>
					<td>#getTypeDay(userGraphic.gr_type)#</td>
					<td>#timeFormat(userGraphic.gr_starttime, "HH:MM")#</td>
					<td>#timeFormat(userGraphic.gr_endtime, "HH:MM")#</td>
					<td>#userGraphic.gr_status#</td>
					<td><a href="/?page=usersGraphics&section=userGraphics&action=edite&userid=#arguments.userid#&grid=#userGraphic.gr_id#">�������������</a></td>';

			}else{
				view &= '<td>#_DateFormate(_Date)# #getWeekNameShort(DayOfWeek(_Date))#</td>
					<td colspan="4">-</td>
					<td><a href="/?page=usersGraphics&section=userGraphics&action=add&userid=#arguments.userid#&date=#currentYear#.#currentMonth#.#y#">��������</a></td>';
			}

			view &= '</tr>';

		}

		view &= '</table>';

		view &= '</div></div>';

		return view;
	}

	function usersGraphicsListForm( date ){

		userList = factoryService.getService('usersAPI').getUserList();
		//writeDump(userList);

		/////////////////////////////////////////////////////////////////////////////////////////

		if ( arguments.date == 'false' ){
			currentDate = createodbcdate(now()); //
		}else{
			date = arguments.date; //
			currentDate = createodbcdate(date);
		}

		currentDay = Day(currentDate);
		currentMonth = Month(currentDate);
		currentYear = Year(currentDate);

		DayInMonth = DaysInMonth(currentDate);

		/////////////////////////////////////////////////////////////////////////////////////////
				
		var view = '';

		view &= '<div class="grid_16"><div class="signin-box">
			<h2>����� ������ ������:</h2>';

			view &= '<table width="100%" cellspacing="0">
						<tr>
						<td class="block1" style="color:grey;vertical-align:middle;" rowspan="3">�����: �-� \ ���</td>
						<td class="block1" colspan="#DayInMonth#">
							<a href="/?page=usersGraphics&date=#dateFormat(dateAdd('m', -1, currentDate),'YYYY.MM.DD')#"><<</a> 
								#MonthAsString(currentMonth)# #currentYear#
							<a href="/?page=usersGraphics&date=#dateFormat(dateAdd('m', +1, currentDate),'YYYY.MM.DD')#">>></a>
						</td>
						<td></td>
						</tr>

						<tr style="color:grey;">';

						for ( var y=1; y<=DayInMonth; y++){
							_Date = CreateDate( currentYear, currentMonth, y);
							if ( DateCompare("#_Date#", "#now()#" , "d") == 0 ){
								view &= '<td #_style(_Date)#><b>#y#</b></td>';
							}else{
								view &= '<td #_style(_Date)#>#y#</td>';
							}
						} 
						view &= '<td></td>
						</tr>';
			view &= '
						<tr style="color:grey;">
						';
						for ( var y=1; y<=DayInMonth; y++){
							_Date = CreateDate( currentYear, currentMonth, y);
							if ( DateCompare("#_Date#", "#now()#" , "d") == 0 ){
								view &= '<td #_style(_Date)#><b>#getWeekNameShort(DayOfWeek( _Date  ))#</b></td>';
							}else{
								view &= '<td #_style(_Date)#>#getWeekNameShort(DayOfWeek( _Date  ))#</td>';
							}
						} 
						view &= '<td> --- </td>
						</tr>';

			// ������ �������� ���
			firstDayInMonth = CreateDate( currentYear, currentMonth, 1);
			lastDayInMonth = CreateDate( currentYear, currentMonth, DayInMonth);
			userGraphics = factoryService.getService('usersGraphicsAPI');
			setUserGraphics = userGraphics.setUsersGraphicsList('',firstDayInMonth, lastDayInMonth);
			usersGraphics = userGraphics.getUsersGraphicsList();
			//writeDump(usersGraphics);

			massUG = arrayNew(2);
			for (var x=1; x<=userList.recordcount; x++){
				for(var y=1; y<=DayInMonth; y++){
					massUG[userList.user_id[x]][y] = '';
				}
			}

			//writeDump(usersGraphics);
			for (var x=1; x<=usersGraphics.recordcount; x++ ){
				if (usersGraphics.gr_type[x] == 1){
					startTimeH = '#Hour(usersGraphics.gr_starttime[x])#';
					startTimeM = '#minute(usersGraphics.gr_starttime[x])#';
					startTime = '#startTimeH#';
					if (startTimeM != 0){
						startTime &= ':#startTimeM#';
					}
					endTimeH = '#Hour(usersGraphics.gr_endtime[x])#';
					endTimeM = '#minute(usersGraphics.gr_endtime[x])#';
					endTime = '#endTimeH#';
					if (endTimeM != 0){
						endTime &= ':#endTimeM#';
					}
					massUG['#usersGraphics.user_id[x]#']['#day(usersGraphics.gr_date[x])#'] = '#startTime#<br>#endTime#';
				}else{
					massUG['#usersGraphics.user_id[x]#']['#day(usersGraphics.gr_date[x])#'] = usersGraphics.gr_type[x];
				}
			}

			for (var x=1; x<=userList.recordcount; x++){
						var class = IIF(x MOD 2, DE('tr_hover'), DE('tr_hover1'));
						view &= '<tr class="#class#">
						<td class="block1" style="text-align:left;">&nbsp#x#. <b>#userList.emp_family[x]# #Left(userList.emp_firstname[x],1)#.#Left(userList.emp_lastname[x],1)#.</b> <font color="grey">#userList.emp_type[x]#</font></td>';
						for ( var y=1; y<=DayInMonth; y++){
							_Date = CreateDate( currentYear, currentMonth, y);
							gr_type = massUG[userList.user_id[x]][y];
							if (gr_type == ''){
								view &= '<td #_style(_Date)#>-</td>';
							}else{
								view &= '<td #_style(_Date)#>#getTypeDay(gr_type)#</td>';
							}
						}
						if( date is not 'false' ){
							view &= '<td> <a href="/?page=usersGraphics&section=userGraphics&action=view&userid=#userList.user_id[x]#&date=#date#">���.</a> </td>
						</tr>';
						}else{
							view &= '<td> <a href="/?page=usersGraphics&section=userGraphics&action=view&userid=#userList.user_id[x]#">���.</a> </td>
						</tr>';
						}

			}


			view &= '</table>';

			day = DayOfWeek(now());
			view &= '
				#getTypeDay(1)# - ������� ����<br>
				#getTypeDay(2)# - �������� ����<br>
				#getTypeDay(3)# - ������<br>
				#getTypeDay(4)# - ����������<br>
				"-" - �� ��������';

		view &= '</div></div>';
		return view;
	}

	function View() {
		return instance.view;
  	}

	function _DateFormate(date){
		date = arguments.date;

		myYear = Year(date);
		myMonth = MonthAsString(Month(date));
		myDay = Day(date);

		return '#myDay# #myMonth# #myYear#';

	}
	                                   // HH ��� MM
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

	function _style(date){
		_date = arguments.date;

		if ( DayOfWeek( _date ) <= 6 AND DayOfWeek( _date ) >= 2 ){
			style = 'class="block1"';
		}else{
			style = 'class="block1" style="BACKGROUND-COLOR: ##7DD268;"'; //##FF7F66
		}                                                        

		return style;
	}

}

/*
<h3>DayOfWeek Example</h3> 
    More information about your date: 
    <cfset yourDate = CreateDate(2013, 12, 14)> 
    <cfoutput> 
    <p>Your date, #DateFormat(yourDate)#. 
    <br>It is #DayofWeekAsString(DayOfWeek(yourDate))#, day  
         #DayOfWeek(yourDate)# in the week. 
    <br>This is day #Day(YourDate)# in the month of  
         #MonthAsString(Month(yourDate))#, which has 
     #DaysInMonth(yourDate)# days. 
    <br>We are in week #Week(yourDate)# of #Year(YourDate)# (day  
     #DayofYear(yourDate)# of #DaysinYear(yourDate)#).  
    <br><cfif IsLeapYear(Year(yourDate))>This is a leap year 
        <cfelse>This is not a leap year</cfif> 
    </cfoutput>
*/