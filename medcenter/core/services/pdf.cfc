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
		            <td><b>Договор на оказание платных медицинских услуг</b> № #patient.pt_id# от #now()#</td> 
		        </tr>

		        <tr> 
		            <td style="text-align: justify;">Общество с ограниченной ответственностью "Жемчужина Подолья", именуемое в дальнейшем "Исполнитель",
				в лице генерального директора Чагайдак Альберта Александровича, действующего на основании Устава и
				лицензии на медицинскую деятельность № ЛО-50-01-003487 от 30.05.2012 г. с одной стороны и 
				<b>#patient.pt_family#</b> <b>#patient.pt_firstname#</b> <b>#patient.pt_lastname#</b>, именуемый(ая) в дальнейшем "Пациент", 
				с другой стороны, далее "Стороны", заключили настоящий Договор о нижеследующем:<br><br>
				<b>1. Предмет договора.</b><br>
				1.1. Пациент поручает, а Исполнитель обязуется оказать Пацменту платную медицинскую услугу:<br>
				<table cellspacing="0" cellpadding="1" width="100%">
					<tr>
						<td class="block" width="50%">Наименование услуги</td>
						<td class="block" width="50%">Наименование услуги</td>
					</tr>
					<tr>
						<td class="block">Консультация врача-специалиста</td>
						<td class="block">Озонотерапия</td>
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
		// пациент
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
				view &= '<p><img style="float:left; margin: 0px 0px 0px 0px;" src="img/logodoc.png" width="110px" boredr="0"><center><b>Многопрофильный медицинский центр ООО "Жемчужина подолья"<br>
					г. Подольск, ул. Беляевская, д. 86Б <br>
					тел.: 8(499)705-86-56, 8(4967)66-33-63, 8(968)688-61-71</b></center>
					</p>';

				if ( qRServices.st_id == 1 OR qRServices.st_id == 4){
					view &= '<p align="center"><b>МЕДИЦИНСКАЯ КАРТА АМБУЛАТОРНОГО БОЛЬНОГО</b></p>';
					view &= '<p align="center"><b>#qRServices.sv_name#</b></p>';			
					view &= '<br><p><b>Номер карты:</b> #patient.pt_id#<br>';
					view &= '<b>Дата приёма:</b> #dateFormat(userReception.rp_date,"DD/MM/YYYY")#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Начало приёма:</b>#timeFormat(userReception.rp_starttime,"HH:MM")#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Окончание приёма:</b>#timeFormat(userReception.rp_endtime,"HH:MM")#<br>';
					view &= '<b>Пациент:</b> #patient.pt_family# #patient.pt_firstname# #patient.pt_lastname# <b>Дата рождения:</b> #dateFormat(patient.pt_dob,"DD/MM/YYYY")#<br>';
					view &= '<b>Врач:</b> #qUser.emp_family# #qUser.emp_firstname# #qUser.emp_lastname#</p>';
					view &= '-----------------------------------------------------------------------------------------------------------------------------------------------------------------';


				}else if ( qRServices.st_id == 2 OR qRServices.st_id == 3){
					view &= '<p align="center"><b>ПРОТОКОЛ № #qRServices.sv_id#</b></p>';
					view &= '<p align="center"><b>#qRServices.sv_name#</b></p>';
					view &= '<p><b>Номер карты:</b> #patient.pt_id#<br>';
					view &= '<b>Дата:</b> #dateFormat(userReception.rp_date,"DD/MM/YYYY")#<br>';
					view &= '<b>Пациент:</b> #patient.pt_family# #patient.pt_firstname# #patient.pt_lastname# <b>Дата рождения:</b> #dateFormat(patient.pt_dob,"DD/MM/YYYY")#<br>';
					view &= '<b>Врач:</b> #qUser.emp_family# #qUser.emp_firstname# #qUser.emp_lastname#</p>';
					view &= '-----------------------------------------------------------------------------------------------------------------------------------------------------------------';
				}else if ( qRServices.st_id == 6 ){
					view &= '<p align="center"><b>ПРОТОКОЛ ОПЕРАЦИИ № #qRServices.sv_id#</b></p>';
					view &= '<p align="center"><b>#qRServices.sv_name#</b></p>';
					view &= '<p><b>Номер карты:</b> #patient.pt_id#<br>';
					view &= '<b>Дата:</b> #dateFormat(userReception.rp_date,"DD/MM/YYYY")#<br>';
					view &= '<b>Пациент:</b> #patient.pt_family# #patient.pt_firstname# #patient.pt_lastname# <b>Дата рождения:</b> #dateFormat(patient.pt_dob,"DD/MM/YYYY")#<br>';
					view &= '<b>Врач:</b> #qUser.emp_family# #qUser.emp_firstname# #qUser.emp_lastname#</p>';
					view &= '-----------------------------------------------------------------------------------------------------------------------------------------------------------------';
				}

				for (var i=1; i<=arrayLen(shablonDocStruct); i++){
					// добавить скрытие пустых полей.
					if ( shablonDocStruct[i].name == 'АНАМНЕЗ ЗАБОЛЕВАНИЯ' ){
						if (shablonDocStruct[i].data != ''){
							view &= '<p><b>#shablonDocStruct[i].name#:</b><br> #_toString(shablonDocStruct[i].data)#</p>';
						}

						if (qRServices.st_id == 1){
							if ( patient.pt_anamnez != '' ){
							view &= '<p><b>АНАМНЕЗ ЖИЗНИ:</b><br>';
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
					view &= "<p align='right'>Лечащий врач __________________ #Left(qUser.emp_firstname,1)#.#Left(qUser.emp_lastname,1)#. #qUser.emp_family#</p>";					
				}else if( qRServices.st_id == 2 ){
					view &= "<p align='right'>Врач УЗИ__________________ #Left(qUser.emp_firstname,1)#.#Left(qUser.emp_lastname,1)#. #qUser.emp_family#</p>";
				}else{
					view &= "<p align='right'>Врач __________________ #Left(qUser.emp_firstname,1)#.#Left(qUser.emp_lastname,1)#. #qUser.emp_family#</p>";

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
		// пациент
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
				view &= '<p><img style="float:left; margin: 0px 0px 30px 20px;" src="img/logodoc.png" width="110px" boredr="0"><center><b>Многопрофильный медицинский центр ООО "Жемчужина подолья"<br>
					г. Подольск, ул. Беляевская, д. 86Б <br>
					тел.: 8(499)705-86-56, 8(4967)66-33-63, 8(968)688-61-71</b></center>
					</p><br>';

					view &= '<p><b>Номер карты:</b> #patient.pt_id#<br>';
					view &= '<b>Дата приёма:</b> #dateFormat(userReception.rp_date,"DD/MM/YYYY")#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Начало приёма:</b>#timeFormat(userReception.rp_starttime,"HH:MM")#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Окончание приёма:</b>#timeFormat(userReception.rp_endtime,"HH:MM")#<br>';
					view &= '<b>Пациент:</b> #patient.pt_family# #patient.pt_firstname# #patient.pt_lastname# <b>Дата рождения:</b> #dateFormat(patient.pt_dob,"DD/MM/YYYY")#<br>';
					view &= '<b>Врач:</b> #qUser.emp_family# #qUser.emp_firstname# #qUser.emp_lastname#</p>';
					view &= '-----------------------------------------------------------------------------------------------------------------------------------------------------------------';

				for (var i=1; i<=arrayLen(shablonDocStruct); i++){
					// добавить скрытие пустых полей.
					if ( shablonDocStruct[i].name == 'ДИАГНОЗ' OR 
						shablonDocStruct[i].name == 'КЛИНИЧЕСКИЙ ДИАГНОЗ' OR
						shablonDocStruct[i].name == 'ЛИСТ НАЗНАЧЕНИЙ' OR
						shablonDocStruct[i].name == 'РЕКОМЕНДАЦИИ' OR
						shablonDocStruct[i].name == 'ЛЕЧЕНИЕ' OR
						shablonDocStruct[i].name == 'ДОПОЛНИТЕЛЬНЫЕ НАЗНАЧЕНИЯ' OR
						shablonDocStruct[i].name == 'ПЛАН ОБСЛЕДОВАНИЯ' OR
						shablonDocStruct[i].name == 'РЕЦЕПТЫ'){

						if (shablonDocStruct[i].data != ''){
							view &= '<p><b>#shablonDocStruct[i].name#:</b><br> #_toString(shablonDocStruct[i].data)#</p>';
						}

					}
				}
				view &= "<p align='right'>Лечащий врач __________________ #Left(qUser.emp_firstname,1)#.#Left(qUser.emp_lastname,1)#. #qUser.emp_family#</p>";
											
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