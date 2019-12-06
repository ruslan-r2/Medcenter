<cfcomponent output="false">

	<cfset 	factoryService = request.factoryService >

	<cffunction name="init" returntype="any"> 
		<cfreturn this >
	</cffunction>

	<cffunction name="createPdf" returntype="any">
		<cfargument name="patientID" type="any" required="true">

		<cfset factoryService.getService('patientsAPI').setPatient(arguments.patientid) >
		<cfset patient = factoryService.getService('patientsAPI').getPatient() >
                <!---                                               portrait/landscape --->
		<cfdocument format="PDF" pageType="A5" orientation="landscape" unit="cm" marginTop="0.5" marginBottom="0.5" marginLeft="0.5" marginRight="0.5"> 
		<cfoutput>
		<style>
			.block{
				BORDER-RIGHT: ##000000 1px solid;
				BORDER-TOP: ##000000 1px solid;
				BORDER-LEFT: ##000000 1px solid;
				BORDER-BOTTOM: ##000000 1px solid;
				font-size:10px;
				FONT-FAMILY:Tahoma,Verdana,Arial,Helvetica,sans-serif;
				PADDING-LEFT: 2px; 
				PADDING-RIGHT: 2px; 
				PADDING-BOTTOM: 1px;
				PADDING-TOP: 1px; 
				COLOR:##000000;
				BACKGROUND-COLOR: ##FFFFFF;
				FONT-SIZE: 10px;
			}
		</style>
		    <table cellspacing="0" cellpadding="0" style="font-size:10px; FONT-FAMILY:Tahoma,Verdana,Arial,Helvetica,sans-serif;" > 
		        <tr> 
		            <td><b>������� �� �������� ������� ����������� �����</b> � #patient.pt_id# �� #now()#</td> 
		        </tr>

		        <tr> 
		            <td style="text-align: justify;">�������� � ������������ ���������������� "��������� �������", ��������� � ���������� "�����������",
				� ���� ������������ ��������� �������� �������� ��������������, ������������ �� ��������� ������ �
				�������� �� ����������� ������������ � ��-50-01-003487 �� 30.05.2012 �. � ����� ������� � 
				<b>#patient.pt_family#</b> <b>#patient.pt_firstname#</b> <b>#patient.pt_lastname#</b>, ���������(��) � ���������� "�������", 
				� ������ �������, ����� "�������", ��������� ��������� ������� � �������������:<br><br>
				<b>1. ������� ��������.</b><br>
				1.1. ������� ��������, � ����������� ��������� ������� �������� ������� ����������� ������:<br>
				<table cellspacing="0" cellpadding="1" width="100%">
					<tr>
						<td class="block" width="50%">������������ ������</td>
						<td class="block" width="50%">������������ ������</td>
					</tr>
					<tr>
						<td class="block">������������ �����-�����������</td>
						<td class="block">������������</td>
					</tr>
				</table>
			    </td>
		        </tr>

		    </table> 
		</cfoutput>
		</cfdocument>

	<cfreturn this>
	</cffunction>

	<cffunction name="documentPdf" returntype="any">
		<cfargument name="serviceID" type="any" required="true">
		<cfset qRServices = factoryService.getService('userServicesAPI').getReceptionService(arguments.serviceID) >
		<cfset shablonDoc = qRServices.pls_shablon >
		<cfset shablonDocStruct = DeserializeJSON(shablonDoc)>
		<cfset userReception = factoryService.getService('userReceptionAPI').getReception( qRServices.rp_id )>
		<cfset qUser = factoryService.getService( 'authorization' ).getUser( userReception.user_id ) >
		// �������
		<cfset patientid = userReception.pt_id >
		<cfset factoryService.getService('patientsAPI').setPatient(patientid) >
		<cfset patient = factoryService.getService('patientsAPI').getPatient() >
		<cfset view = ''>
		<!--- //FONT-FAMILY:Tahoma,Verdana,Arial,Helvetica,sans-serif; --->
                <!---                                               portrait/landscape --->
		<cfdocument localUrl="yes" format="PDF" mimeType = "text/plain|application/xml|image/jpeg|image/png|image/bmp|image/gif" pageType="A4" orientation="portrait" unit="cm" marginTop="0.5" marginBottom="0.5" marginLeft="0.8" marginRight="0.8"> 
		<cfoutput>
		<style>
			body{
				FONT-FAMILY: Arial;
				COLOR:##000000;
				BACKGROUND-COLOR: ##FFFFFF;
				font-size:13px;
			}
		</style>

			<cfscript>
				view &= '<p><img style="float:left; margin: 0px 0px 0px 0px;" src="img/logodoc.png" width="110px" boredr="0"><center><b>��������������� ����������� ����� ��� "��������� �������"<br>
					�. ��������, ��. ����������, �. 86� <br>
					���.: 8(499)705-86-56, 8(4967)66-33-63, 8(968)688-61-71</b></center>
					</p>';

				if ( qRServices.st_id == 1 OR qRServices.st_id == 4){
					view &= '<p align="center"><b>����������� ����� ������������� ��������</b></p>';
					view &= '<p align="center"><b>#qRServices.sv_name#</b></p>';			
					view &= '<br><p><b>����� �����:</b> #patient.pt_id#<br>';
					view &= '<b>���� �����:</b> #dateFormat(userReception.rp_date,"DD/MM/YYYY")#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>������ �����:</b>#timeFormat(userReception.rp_starttime,"HH:MM")#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>��������� �����:</b>#timeFormat(userReception.rp_endtime,"HH:MM")#<br>';
					view &= '<b>�������:</b> #patient.pt_family# #patient.pt_firstname# #patient.pt_lastname# <b>���� ��������:</b> #dateFormat(patient.pt_dob,"DD/MM/YYYY")#<br>';
					view &= '<b>����:</b> #qUser.emp_family# #qUser.emp_firstname# #qUser.emp_lastname#</p>';
					view &= '-----------------------------------------------------------------------------------------------------------------------------------------------------------------';


				}else if ( qRServices.st_id == 2 OR qRServices.st_id == 3){
					view &= '<p align="center"><b>�������� � #qRServices.sv_id#</b></p>';
					view &= '<p align="center"><b>#qRServices.sv_name#</b></p>';
					view &= '<p><b>����� �����:</b> #patient.pt_id#<br>';
					view &= '<b>����:</b> #dateFormat(userReception.rp_date,"DD/MM/YYYY")#<br>';
					view &= '<b>�������:</b> #patient.pt_family# #patient.pt_firstname# #patient.pt_lastname# <b>���� ��������:</b> #dateFormat(patient.pt_dob,"DD/MM/YYYY")#<br>';
					view &= '<b>����:</b> #qUser.emp_family# #qUser.emp_firstname# #qUser.emp_lastname#</p>';
					view &= '-----------------------------------------------------------------------------------------------------------------------------------------------------------------';
				}else if ( qRServices.st_id == 6 ){
					view &= '<p align="center"><b>�������� �������� � #qRServices.sv_id#</b></p>';
					view &= '<p align="center"><b>#qRServices.sv_name#</b></p>';
					view &= '<p><b>����� �����:</b> #patient.pt_id#<br>';
					view &= '<b>����:</b> #dateFormat(userReception.rp_date,"DD/MM/YYYY")#<br>';
					view &= '<b>�������:</b> #patient.pt_family# #patient.pt_firstname# #patient.pt_lastname# <b>���� ��������:</b> #dateFormat(patient.pt_dob,"DD/MM/YYYY")#<br>';
					view &= '<b>����:</b> #qUser.emp_family# #qUser.emp_firstname# #qUser.emp_lastname#</p>';
					view &= '-----------------------------------------------------------------------------------------------------------------------------------------------------------------';
				}

				for (var i=1; i<=arrayLen(shablonDocStruct); i++){
					// �������� ������� ������ �����.
					if ( shablonDocStruct[i].name == '������� �����������' ){
						if (shablonDocStruct[i].data != ''){
							view &= '<p><b>#shablonDocStruct[i].name#:</b><br> #_toString(shablonDocStruct[i].data)#</p>';
						}

						if (qRServices.st_id == 1){
							if ( patient.pt_anamnez != '' ){
							view &= '<p><b>������� �����:</b><br>';
								anamnez = DeserializeJSON( patient.pt_anamnez );
								for (var j=1; j<=arrayLen(anamnez); j++){
									if ( anamnez[j].data != '' ){
										view &= '<b>#anamnez[j].name#: </b>';
										view &= '#_toString(anamnez[j].data)#';
										view &= '<br>';
									}
								}
							view &= '</p>';
							}
						}

					}else{
						if (shablonDocStruct[i].data != ''){
							view &= '<p><b>#shablonDocStruct[i].name#:</b><br> #_toString(shablonDocStruct[i].data)#</p>';
						}
					}
				}

				if ( qRServices.st_id == 1 ){
					view &= "<p align='right'>������� ���� __________________ #Left(qUser.emp_firstname,1)#.#Left(qUser.emp_lastname,1)#. #qUser.emp_family#</p>";					
				}else if( qRServices.st_id == 2 ){
					view &= "<p align='right'>���� ���__________________ #Left(qUser.emp_firstname,1)#.#Left(qUser.emp_lastname,1)#. #qUser.emp_family#</p>";
				}else{
					view &= "<p align='right'>���� __________________ #Left(qUser.emp_firstname,1)#.#Left(qUser.emp_lastname,1)#. #qUser.emp_family#</p>";

				}
				writeOutPut(view);
			</cfscript>
		</cfoutput>
		</cfdocument>

	<cfreturn this>
	</cffunction>

	<cffunction name="documentPdf1" returntype="any">
		<cfargument name="serviceID" type="any" required="true">
		<cfset qRServices = factoryService.getService('userServicesAPI').getReceptionService(arguments.serviceID) >
		<cfset shablonDoc = qRServices.pls_shablon >
		<cfset shablonDocStruct = DeserializeJSON(shablonDoc)>
		<cfset userReception = factoryService.getService('userReceptionAPI').getReception( qRServices.rp_id )>
		<cfset qUser = factoryService.getService( 'authorization' ).getUser( userReception.user_id ) >
		// �������
		<cfset patientid = userReception.pt_id >
		<cfset factoryService.getService('patientsAPI').setPatient(patientid) >
		<cfset patient = factoryService.getService('patientsAPI').getPatient() >
		<cfset view = ''>

		<!--- //FONT-FAMILY:Tahoma,Verdana,Arial,Helvetica,sans-serif; --->
                <!---                                               portrait/landscape --->
		<cfdocument localUrl="yes" format="PDF" mimeType = "text/plain|application/xml|image/jpeg|image/png|image/bmp|image/gif" pageType="A4" orientation="portrait" unit="cm" marginTop="0.5" marginBottom="0.5" marginLeft="0.8" marginRight="0.8"> 
		<cfoutput>
		<style>
			body{
				FONT-FAMILY: Arial;
				COLOR:##000000;
				BACKGROUND-COLOR: ##FFFFFF;
				font-size:13px;
			}
		</style>

			<cfscript>
				view &= '<p><img style="float:left; margin: 0px 0px 30px 20px;" src="img/logodoc.png" width="110px" boredr="0"><center><b>��������������� ����������� ����� ��� "��������� �������"<br>
					�. ��������, ��. ����������, �. 86� <br>
					���.: 8(499)705-86-56, 8(4967)66-33-63, 8(968)688-61-71</b></center>
					</p><br>';

					view &= '<p><b>����� �����:</b> #patient.pt_id#<br>';
					view &= '<b>���� �����:</b> #dateFormat(userReception.rp_date,"DD/MM/YYYY")#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>������ �����:</b>#timeFormat(userReception.rp_starttime,"HH:MM")#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>��������� �����:</b>#timeFormat(userReception.rp_endtime,"HH:MM")#<br>';
					view &= '<b>�������:</b> #patient.pt_family# #patient.pt_firstname# #patient.pt_lastname# <b>���� ��������:</b> #dateFormat(patient.pt_dob,"DD/MM/YYYY")#<br>';
					view &= '<b>����:</b> #qUser.emp_family# #qUser.emp_firstname# #qUser.emp_lastname#</p>';
					view &= '-----------------------------------------------------------------------------------------------------------------------------------------------------------------';

				for (var i=1; i<=arrayLen(shablonDocStruct); i++){
					// �������� ������� ������ �����.
					if ( shablonDocStruct[i].name == '�������' OR 
						shablonDocStruct[i].name == '����������� �������' OR
						shablonDocStruct[i].name == '���� ����������' OR
						shablonDocStruct[i].name == '������������' OR
						shablonDocStruct[i].name == '�������' OR
						shablonDocStruct[i].name == '�������������� ����������' OR
						shablonDocStruct[i].name == '���� ������������' OR
						shablonDocStruct[i].name == '�������'){

						if (shablonDocStruct[i].data != ''){
							view &= '<p><b>#shablonDocStruct[i].name#:</b><br> #_toString(shablonDocStruct[i].data)#</p>';
						}

					}
				}
				view &= "<p align='right'>������� ���� __________________ #Left(qUser.emp_firstname,1)#.#Left(qUser.emp_lastname,1)#. #qUser.emp_family#</p>";
											
				writeOutPut(view);
			</cfscript>
		</cfoutput>
		</cfdocument>
	<cfreturn this>
	</cffunction>

	<cffunction name="_toString" returntype="any"> 
		<cfargument name="data" type="any" required="true">
		<cfscript>
			_data = arguments.data;
			_data=replace(_data, chr(60), "&##60;", "all");
			_data=replace(_data, chr(62), "&##62;", "all");
			_data=replace(_data, chr(13)&chr(10), "<br />", "all");
		</cfscript>
		<cfreturn _data >
	</cffunction>


</cfcomponent>