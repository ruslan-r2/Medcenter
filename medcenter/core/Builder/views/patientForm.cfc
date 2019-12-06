/* 
	������ ������ ��������� --
*/

component attributeName='userlist' output='false'{


	function PatientForm( ptID, ptFamily, ptFirstName, ptLastName, ptGender, ptDob, ptStatus ){

		param name='form.pt_id' default='';
		param name='form.pt_family' default='';		// �������
		param name='form.pt_firstname' default='';	// ���
		param name='form.pt_lastname' default='';	// ��������
		param name='form.pt_gender' default='';
		param name='form.pt_dob' default='';
		//param name='form.pt_dobYear' default='';
		//param name='form.pt_dobMonth' default='';
		//param name='form.pt_dobDay' default='';
		param name='form.pt_status' default='1';

		// ---------------------------------------------------------- ����� ---------------------------------------------------------------
		action = '#request.CRequest.updateURL(false,"/?page=patients&section=patient&action=add")#';

		view = '';
		view &= '<div class="grid_8">
			<div class="signin-box">
			<a class="g-button g-button-submit" href="#request.CRequest.updateURL(false,"/?page=patients")#">�����</a><br><br>
			<h2>���������� ������ ��������:</h2>
			<form id="addpatient" name="addpatient" action="#action#" method="post">
			<div>
				<label for="ptFamily"><strong>�������</strong></label>
				<input type="text" id="ptFamily" name="pt_family" value="#form.pt_family#" maxlength="50" size="20">';

			if (instance.patientFamily is not ''){
			view &= '<label for="ptFamily" class="error" generated="0">#instance.patientFamily#</label>';
			}

		view &= '</div>
			<div>
				<label><strong>���</strong></label>
				<input type="text" id="ptFirstname" name="pt_firstname" value="#form.pt_firstname#" maxlength="50" size="20">';
   			if (instance.patientFirstname is not ''){
			view &= '<label for="ptFirstname" class="error" generated="1">#instance.patientFirstname#</label>';
			}

		view &= '</div>
			<div>
				<label>��������:</label>
				<input type="text" id="ptLastname" name="pt_lastname" value="#form.pt_lastname#" maxlength="50" size="20">';
   			if (instance.patientLastname is not ''){
			view &= '<label for="ptLastname" class="error" generated="2">#instance.patientLastname#</label>';
			}


		view &= '</div>
			<div>
				<label for="pt_gender"><b>��� ��������:</b></label>
				<select name="pt_gender">
					<option value="�������" #checkedSelect("�������", form.pt_gender)# >�������</option>
					<option value="�������" #checkedSelect("�������", form.pt_gender)# >�������</option>
				</select>
			';

			if (instance.patientGender is not ''){
			view &= '<label for="pt_gender" class="error" generated="0">#instance.patientGender#</label>';
			}

		view &= '</div>
			<div>
				<label for="pt_dob"><b>���� ��������:</b></label>
                        
				<label for="pt_dobDay">����:</label>
				<input type="text" id="ptDobDay" name="pt_dobDay" value="#form.pt_dobDay#" maxlength="2" size="2">
				<label for="pt_dobMonth">�����:</label>
				<input type="text" id="ptDobMonth" name="pt_dobMonth" value="#form.pt_dobMonth#" maxlength="2" size="2">
				<label for="pt_dobYear">���:</label>
				<input type="text" id="ptDobYear" name="pt_dobYear" value="#form.pt_dobYear#" maxlength="4" size="4">
			';

			if (instance.patientDob is not ''){
			view &= '<label for="pt_dob" class="error" generated="0">#instance.patientDob#</label>';
			}

		view &= '</div><div>
				<input type="hidden" name="pt_status" value="#form.pt_status#" size = "2" maxlength = "2">
				<hr>
				<input disabled class="g-button g-button-submit" type="submit" name="escape" value="������">
				<input class="g-button g-button-submit" type="submit" name="addPatient" value="���������"> ';

			if (instance.message is not ''){
			view &= '<div id="mes" style="color:red;">#instance.message#</div>';
			}

		view &='</div></form>
			</div></div>';

			// ------------------------------------------------ ����� ---------------------------------------------------------------
		return view;
	}

}