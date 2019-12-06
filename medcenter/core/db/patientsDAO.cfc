/*
*/
component displayname="patientsDAO" output="false" {

	/* Псевдо конструктор */
	instance = {datasource = ''} ; // объект

	function init() {
		instance.datasource = createObject('component', 'core.db.Datasource').init();
		return this ;
	}

	function searchPatients( _string ){

		string = Trim(arguments._string);
		if (string is not ''){
			_len = len(string);
			string = '#UCase(mid(string, 1,1))##LCase(mid(string,2,_len-1))#';
		}else{
			string = '';
		}

		qSearch = new Query();
		qSearch.setName("qSearch");
		qSearch.setTimeout("5");
		qSearch.setDatasource("#variables.instance.datasource.getDSName()#");

				//SELECT TOP 45 * 
				//FROM (SELECT COUNT(*) as cnt FROM reception) patients 
				//WHERE pt_family LIKE('#string#%') 
				//ORDER by pt_id DESC
		qSearch.setSQL("SELECT TOP 50 * , ( SELECT COUNT(*) as cnt FROM reception WHERE rp_status > 0 AND pt_id = a.pt_id) as cnt
				FROM patients a
				WHERE a.pt_family LIKE('#string#%') 
				ORDER by a.pt_id DESC");

		var execute = qSearch.execute(); // вся структура и result и prefix
		var result = execute.getResult();
		//writeDump(result);
		return result; //query
	}

	// CRUD
	function readPatients(){
		qPatients = new Query();
		qPatients.setName("qPatients");
		qPatients.setTimeout("5");
		qPatients.setDatasource("#variables.instance.datasource.getDSName()#");

		qPatients.setSQL("SELECT * FROM patients");

		var execute = qPatients.execute(); // вся структура и result и prefix
		var result = execute.getResult();
		return result; //query
	}

	function readPatient( required numeric ptID ) {
		qPatient = new Query();
		qPatient.setName("qPatient");
		qPatient.setTimeout("5");
		qPatient.setDatasource("#variables.instance.datasource.getDSName()#");

		qPatient.setSQL("SELECT * FROM patients WHERE pt_id = '#arguments.ptID#' ");
	
		var execute = qPatient.execute(); // вся структура и result и prefix
		var result = execute.getResult();

		return result;
	}

	function checkPatient( required string patientFamily, required string patientFirstName, required string patientLastName, required patientDoB ) {
		chPatient = new Query();
		chPatient.setName("chPatient");
		chPatient.setTimeout("5");
		chPatient.setDatasource("#variables.instance.datasource.getDSName()#");

		chPatient.addParam(name = "patientFamily", value = "#trim(arguments.patientFamily)#", cfsqltype = "cf_sql_varchar" );
		chPatient.addParam(name = "patientFirstName", value = "#trim(arguments.patientFirstName)#", cfsqltype = "cf_sql_varchar" );
		chPatient.addParam(name = "patientLastName", value = "#trim(arguments.patientLastName)#", cfsqltype = "cf_sql_varchar" );
		chPatient.addParam(name = "patientDoB", value = "#arguments.patientDoB#", cfsqltype = "cf_sql_date" );

		chPatient.setSQL("SELECT * FROM patients WHERE pt_family = :patientFamily AND pt_firstname = :patientFirstNAme AND pt_lastname = :patientLastName AND pt_dob = :patientDoB");
	
		var execute = chPatient.execute(); // вся структура и result и prefix
		var result = execute.getResult();

		return result;
	}

	function readPatientDocuments( required numeric ptID ) {
		qPatientDocs = new Query();
		qPatientDocs.setName("qPatientDocs");
		qPatientDocs.setTimeout("5");
		qPatientDocs.setDatasource("#variables.instance.datasource.getDSName()#");

		qPatientDocs.setSQL("SELECT * FROM patients_documents WHERE pt_id = '#arguments.ptID#' ");
	
		var execute = qPatientDocs.execute(); // вся структура и result и prefix
		var result = execute.getResult();

		return result;
	}

	function readPatientDocument( required numeric ptdID ) {
		qPatientDoc = new Query();
		qPatientDoc.setName("qPatientDoc");
		qPatientDoc.setTimeout("5");
		qPatientDoc.setDatasource("#variables.instance.datasource.getDSName()#");

		qPatientDoc.setSQL("SELECT * FROM patients_documents WHERE ptd_id = '#arguments.ptdID#' ");
	
		var execute = qPatientDoc.execute(); // вся структура и result и prefix
		var result = execute.getResult();

		return result;
	}

	function readPatientAddresses( required numeric ptID ) {
		qPatientAdds = new Query();
		qPatientAdds.setName("qPatientAdds");
		qPatientAdds.setTimeout("5");
		qPatientAdds.setDatasource("#variables.instance.datasource.getDSName()#");

		qPatientAdds.setSQL("SELECT * FROM patients_addresses WHERE pt_id = '#arguments.ptID#' ");
	
		var execute = qPatientAdds.execute(); // вся структура и result и prefix
		var result = execute.getResult();

		return result;
	}

	function readPatientAddress( required numeric ptaID ) {
		qPatientAdd = new Query();
		qPatientAdd.setName("qPatientAdd");
		qPatientAdd.setTimeout("5");
		qPatientAdd.setDatasource("#variables.instance.datasource.getDSName()#");

		qPatientAdd.setSQL("SELECT * FROM patients_addresses WHERE pta_id = '#arguments.ptaID#' ");
	
		var execute = qPatientAdd.execute(); // вся структура и result и prefix
		var result = execute.getResult();

		return result;
	}

	function readPatientContacts( required numeric ptID ) {
		qPatientCon = new Query();
		qPatientCon.setName("qPatientCon");
		qPatientCon.setTimeout("5");
		qPatientCon.setDatasource("#variables.instance.datasource.getDSName()#");

		qPatientCon.setSQL("SELECT a.ptc_id, a.pt_id, a.ct_id, a.ptc_data, a.ptc_description, a.ptc_status, b.cnt_type_description 
					FROM patients_contacts a, contacts_types b
					WHERE pt_id = '#arguments.ptID#'
						AND a.ct_id = b.cnt_type_id");

		var execute = qPatientCon.execute(); // вся структура и result и prefix
		var result = execute.getResult();

		return result;
	}

	function readContact( required numeric ptcID ) {
		qPatientC = new Query();
		qPatientC.setName("qPatientC");
		qPatientC.setTimeout("5");
		qPatientC.setDatasource("#variables.instance.datasource.getDSName()#");

		qPatientC.setSQL("SELECT * FROM patients_contacts WHERE ptc_id = '#arguments.ptcID#' ");
	
		var execute = qPatientC.execute(); // вся структура и result и prefix
		var result = execute.getResult();

		return result;
	}

	function checkContact( required string ptcData ) {
		chPatientC = new Query();
		chPatientC.setName("chPatientC");
		chPatientC.setTimeout("5");
		chPatientC.setDatasource("#variables.instance.datasource.getDSName()#");

		chPatientC.setSQL("SELECT * FROM patients_contacts WHERE ptc_data = '#arguments.ptcData#' ");
	
		var execute = chPatientC.execute(); // вся структура и result и prefix
		var result = execute.getResult();

		return result;
	}

	function readPatientReception( ptID ){
		qPtReception = new Query();
		qPtReception.setName("readPatientReception");
		qPtReception.setTimeout("5");
		qPtReception.setDatasource("#variables.instance.datasource.getDSName()#");

		qPtReception.setSQL("SELECT * FROM reception WHERE pt_id = #arguments.ptID# AND rp_status >= 1 ORDER BY rp_date DESC, rp_starttime_default DESC");
	
		var execute = qPtReception.execute(); // вся структура и result и prefix
		var result = execute.getResult();
		return result; //query
	}

	function readPatientDMS( ptdmsID='', ptID='' ){
		qPtDMS = new Query();
		qPtDMS.setName("readPatientDMS");
		qPtDMS.setTimeout("5");
		qPtDMS.setDatasource("#variables.instance.datasource.getDSName()#");

		if (arguments.ptdmsID is not '' ){
			// считываем конкретную запись по id
			qPtDMS.setSQL("SELECT * FROM patients_dms WHERE ptdms_id = #arguments.ptdmsID#");
		}else{
			// считываем из базы записи конкретного пациента должна быть одна
			qPtDMS.setSQL("SELECT a.ptdms_id, a.pt_id, a.cdms_id, a.ptdms_polis_number, a.ptdms_description, a.ptdms_status, b.cdms_name 
					FROM patients_dms a, companysdms b 
					WHERE a.pt_id = #arguments.ptID# 
						AND b.cdms_id = a.cdms_id");
		}
	
		var execute = qPtDMS.execute(); // вся структура и result и prefix
		var result = execute.getResult();
		return result; //query
	}


	// создание нового пациента
	function createPatient(required string patientFamily, required string patientFirstName, required string patientLastName, required string patientGender, required patientDoB, required patientDateAdd, required patientStatus ) {
		// дописать время создания и ip
		createPatient = new Query();
		createPatient.setDatasource("#instance.datasource.getDSName()#");
		createPatient.setName("createPatient");
		createPatient.setTimeout("5");
		createPatient.addParam(name = "patientFamily", value = "#trim(arguments.patientFamily)#", cfsqltype = "cf_sql_varchar" );
		createPatient.addParam(name = "patientFirstName", value = "#trim(arguments.patientFirstName)#", cfsqltype = "cf_sql_varchar" );
		createPatient.addParam(name = "patientLastName", value = "#trim(arguments.patientLastName)#", cfsqltype = "cf_sql_varchar" );
		createPatient.addParam(name = "patientGender", value = "#arguments.patientGender#", cfsqltype = "cf_sql_varchar" );
		createPatient.addParam(name = "patientDoB", value = "#arguments.patientDoB#", cfsqltype = "cf_sql_date" );
		createPatient.addParam(name = "patientDateAdd", value = "#arguments.patientDateAdd#", cfsqltype = "cf_sql_date" );
		createPatient.addParam(name = "patientStatus", value = "#arguments.patientStatus#", cfsqltype = "cf_sql_integer" );
			
		createPatient.setSQL("INSERT INTO patients ( pt_family, pt_firstname, pt_lastname, pt_gender, pt_dob, pt_dateadd, pt_status )
			VALUES ( :patientFamily, :patientFirstName, :patientLastName, :patientGender, :patientDoB, :patientDateAdd, :patientStatus )
			");

		ret = createPatient.execute(); // вся структура и result и prefix
		//writeDump(ss);
		var structCreatePatient=structNew();
		structCreatePatient.RETVAL = 1; //REG
		structCreatePatient.RETDESC = '#ret.getPrefix().GENERATEDKEY#';
		return structCreatePatient;
	}

	function updatePatient(required patientID, required string patientFamily, required string patientFirstName, required string patientLastName, required string patientGender, required patientDoB, required patientDateAdd, required patientStatus ){

		updatePatient = new Query();
		updatePatient.setDatasource("#instance.datasource.getDSName()#");
		updatePatient.setName("_updatePatient");
		updatePatient.setTimeout("5");

		updatePatient.addParam(name = "patientID", value = "#arguments.patientID#", cfsqltype = "cf_sql_integer" );
		updatePatient.addParam(name = "patientFamily", value = "#trim(arguments.patientFamily)#", cfsqltype = "cf_sql_varchar" );
		updatePatient.addParam(name = "patientFirstName", value = "#trim(arguments.patientFirstName)#", cfsqltype = "cf_sql_varchar" );
		updatePatient.addParam(name = "patientLastName", value = "#trim(arguments.patientLastName)#", cfsqltype = "cf_sql_varchar" );
		updatePatient.addParam(name = "patientGender", value = "#arguments.patientGender#", cfsqltype = "cf_sql_varchar" );
		updatePatient.addParam(name = "patientDoB", value = "#arguments.patientDoB#", cfsqltype = "cf_sql_date" );
		updatePatient.addParam(name = "patientDateAdd", value = "#arguments.patientDateAdd#", cfsqltype = "cf_sql_date" );
		//updatePatient.addParam(name = "patientStatus", value = "#arguments.patientStatus#", cfsqltype = "cf_sql_integer" );


		updatePatient.setSQL("UPDATE patients 
				SET 
				pt_family=:patientFamily,
				pt_firstname=:patientFirstName,
				pt_lastname=:patientLastName,
				pt_gender=:patientGender,
				pt_dob=:patientDoB,
				pt_dateadd=:patientDateAdd 
				WHERE pt_id = :patientID");

		updatePatient.execute();
		var structUpdatePatient = structNew();
		structUpdatePatient.RETVAL = 1; // create
		structUpdatePatient.RETDESC = 'Информация пациента изменена!';
		return structUpdatePatient;

	}

	function createContact( required numeric ptID, required numeric ctID, required ptcData, ptcDescription, ptcStatus ) {
		// дописать время создания и ip
		createContact = new Query();
		createContact.setDatasource("#instance.datasource.getDSName()#");
		createContact.setName("createContact");
		createContact.setTimeout("5");
		createContact.addParam(name = "ptID", value = "#arguments.ptID#", cfsqltype = "cf_sql_integer" );
		createContact.addParam(name = "ctID", value = "#arguments.ctID#", cfsqltype = "cf_sql_integer" );
		createContact.addParam(name = "ptcData", value = "#arguments.ptcData#", cfsqltype = "cf_sql_varchar" );
		createContact.addParam(name = "ptcDescription", value = "#arguments.ptcDescription#", cfsqltype = "cf_sql_varchar" );
		createContact.addParam(name = "ptcStatus", value = "#arguments.ptcStatus#", cfsqltype = "cf_sql_integer" );
			
		createContact.setSQL("INSERT INTO patients_contacts ( pt_id, ct_id, ptc_data, ptc_description, ptc_status )
			VALUES ( :ptID, :ctID, :ptcData, :ptcDescription, :ptcStatus )
			");

		ss = createContact.execute(); // вся структура и result и prefix
		//writeDump(ss);
		var structCreateContact=structNew();
		structCreateContact.RETVAL = 1; //REG
		structCreateContact.RETDESC = 'Контакт пациента добавлен!';
		return structCreateContact;
	}

	function updateContact( required numeric ptcID, required numeric ptID, required numeric ctID, required ptcData, ptcDescription, ptcStatus ){

		updateContact = new Query();
		updateContact.setDatasource("#instance.datasource.getDSName()#");
		updateContact.setName("updateContact");
		updateContact.setTimeout("5");

		updateContact.addParam(name = "ptcID", value = "#arguments.ptcID#", cfsqltype = "cf_sql_integer" );
		updateContact.addParam(name = "ptID", value = "#arguments.ptID#", cfsqltype = "cf_sql_integer" );
		updateContact.addParam(name = "ctID", value = "#arguments.ctID#", cfsqltype = "cf_sql_integer" );
		updateContact.addParam(name = "ptcData", value = "#arguments.ptcData#", cfsqltype = "cf_sql_varchar" );
		updateContact.addParam(name = "ptcDescription", value = "#arguments.ptcDescription#", cfsqltype = "cf_sql_varchar" );
		updateContact.addParam(name = "ptcStatus", value = "#arguments.ptcStatus#", cfsqltype = "cf_sql_integer" );

		updateContact.setSQL("UPDATE patients_contacts 
				SET 
				pt_id=:ptID,
				ct_id=:ctID,
				ptc_data=:ptcData,
				ptc_description=:ptcDescription,
				ptc_status=:ptcStatus 
				WHERE ptc_id = :ptcID");

		updateContact.execute();
		var structupdateContact = structNew();
		structupdateContact.RETVAL = 1; // create
		structupdateContact.RETDESC = 'Информация пациента изменена!';
		return structupdateContact;

	}

	function createDMS( required numeric ptID, required numeric cdmsID, required ptdmsPolisNumber, ptdmsDescription, ptdmsStatus ) {
		// дописать время создания и ip
		createDMS = new Query();
		createDMS.setDatasource("#instance.datasource.getDSName()#");
		createDMS.setName("createDMS");
		createDMS.setTimeout("5");
		createDMS.addParam(name = "ptID", value = "#arguments.ptID#", cfsqltype = "cf_sql_integer" );
		createDMS.addParam(name = "cdmsID", value = "#arguments.cdmsID#", cfsqltype = "cf_sql_integer" );
		createDMS.addParam(name = "ptdmsPolisNumber", value = "#arguments.ptdmsPolisNumber#", cfsqltype = "cf_sql_varchar" );
		createDMS.addParam(name = "ptdmsDescription", value = "#arguments.ptdmsDescription#", cfsqltype = "cf_sql_varchar" );
		createDMS.addParam(name = "ptdmsStatus", value = "#arguments.ptdmsStatus#", cfsqltype = "cf_sql_integer" );
			
		createDMS.setSQL("INSERT INTO patients_dms ( pt_id, cdms_id, ptdms_polis_number, ptdms_description, ptdms_status )
			VALUES ( :ptID, :cdmsID, :ptdmsPolisNumber, :ptdmsDescription, :ptdmsStatus )
			");

		createDMS.execute(); // вся структура и result и prefix
		var structCreateDMS=structNew();
		structCreateDMS.RETVAL = 1; //REG
		structCreateDMS.RETDESC = 'Информация о ДМС добавлена!';
		return structCreateDMS;
	}

	function updateDMS( required numeric ptdmsID, required numeric ptID, required numeric cdmsID, required ptdmsPolisNumber, ptdmsDescription, ptdmsStatus ){

		updateDMS = new Query();
		updateDMS.setDatasource("#instance.datasource.getDSName()#");
		updateDMS.setName("updateDMS");
		updateDMS.setTimeout("5");

		updateDMS.addParam(name = "ptdmsID", value = "#arguments.ptdmsID#", cfsqltype = "cf_sql_integer" );
		updateDMS.addParam(name = "ptID", value = "#arguments.ptID#", cfsqltype = "cf_sql_integer" );
		updateDMS.addParam(name = "cdmsID", value = "#arguments.cdmsID#", cfsqltype = "cf_sql_integer" );
		updateDMS.addParam(name = "ptdmsPolisNumber", value = "#arguments.ptdmsPolisNumber#", cfsqltype = "cf_sql_varchar" );
		updateDMS.addParam(name = "ptdmsDescription", value = "#arguments.ptdmsDescription#", cfsqltype = "cf_sql_varchar" );
		updateDMS.addParam(name = "ptdmsStatus", value = "#arguments.ptdmsStatus#", cfsqltype = "cf_sql_integer" );

		updateDMS.setSQL("UPDATE patients_dms 
				SET 
				pt_id=:ptID,
				cdms_id=:cdmsID,
				ptdms_polis_number=:ptdmsPolisNumber,
				ptdms_description=:ptdmsDescription,
				ptdms_status=:ptdmsStatus 
				WHERE ptdms_id = :ptdmsID");

		updateDMS.execute();
		var structUpdateDMS = structNew();
		structUpdateDMS.RETVAL = 1; // create
		structUpdateDMS.RETDESC = 'Информация о ДМС изменена!';
		return structUpdateDMS;

	}

	function updateAnamnez( ptID, ptAnamnez ){

		updateAnamnez = new Query();
		updateAnamnez.setDatasource("#instance.datasource.getDSName()#");
		updateAnamnez.setName("updateAnamnez");
		updateAnamnez.setTimeout("5");

		updateAnamnez.addParam(name = "ptID", value = "#arguments.ptID#", cfsqltype = "cf_sql_integer" );
		updateAnamnez.addParam(name = "ptAnamnez", value = "#arguments.ptAnamnez#", cfsqltype = "cf_sql_varchar" );

		updateAnamnez.setSQL("UPDATE patients 
				SET 
				pt_anamnez=:ptAnamnez 
				WHERE pt_id = :ptID");

		updateAnamnez.execute();
		var structUpdateAnamnez = structNew();
		structUpdateAnamnez.RETVAL = 1; // create
		structUpdateAnamnez.RETDESC = 'Анамнез жизни пациента изменён!';
		return structUpdateAnamnez;

	}

	function createDocument( ptID, ptdDocument, ptdNumber, ptdIssued, ptdDate, ptdSc, ptdStatus ) {
		// дописать время создания и ip
		createDocument = new Query();
		createDocument.setDatasource("#instance.datasource.getDSName()#");
		createDocument.setName("createDocument");
		createDocument.setTimeout("5");
		createDocument.addParam(name = "ptID", value = "#arguments.ptID#", cfsqltype = "cf_sql_integer" );
		createDocument.addParam(name = "ptdDocument", value = "#arguments.ptdDocument#", cfsqltype = "cf_sql_varchar" );
		createDocument.addParam(name = "ptdNumber", value = "#arguments.ptdNumber#", cfsqltype = "cf_sql_varchar" );
		createDocument.addParam(name = "ptdIssued", value = "#arguments.ptdIssued#", cfsqltype = "cf_sql_varchar" );
		createDocument.addParam(name = "ptdDate", value = "#arguments.ptdDate#", cfsqltype = "cf_sql_date" );
		createDocument.addParam(name = "ptdSc", value = "#arguments.ptdSc#", cfsqltype = "cf_sql_varchar" );
		createDocument.addParam(name = "ptdStatus", value = "#arguments.ptdStatus#", cfsqltype = "cf_sql_integer" );
			
		createDocument.setSQL("INSERT INTO patients_documents ( pt_id, ptd_document, ptd_number, ptd_issued, ptd_date, ptd_sc, ptd_status )
			VALUES ( :ptID, :ptdDocument, :ptdNumber, :ptdIssued, :ptdDate, :ptdSc, :ptdStatus )
			");

		ret = createDocument.execute(); // вся структура и result и prefix
		//writeDump(ss);
		var structCreateDocument=structNew();
		structCreateDocument.RETVAL = 1; //REG
		structCreateDocument.RETDESC = 'Документ добавлен!';
		return structCreateDocument;
	}

	function updateDocument( ptdID, ptID, ptdDocument, ptdNumber, ptdIssued, ptdDate, ptdSc, ptdStatus ){

		updateDocument = new Query();
		updateDocument.setDatasource("#instance.datasource.getDSName()#");
		updateDocument.setName("updateDocument");
		updateDocument.setTimeout("5");

		updateDocument.addParam(name = "ptdID", value = "#arguments.ptdID#", cfsqltype = "cf_sql_integer" );
		updateDocument.addParam(name = "ptID", value = "#arguments.ptID#", cfsqltype = "cf_sql_integer" );
		updateDocument.addParam(name = "ptdDocument", value = "#arguments.ptdDocument#", cfsqltype = "cf_sql_varchar" );
		updateDocument.addParam(name = "ptdNumber", value = "#arguments.ptdNumber#", cfsqltype = "cf_sql_varchar" );
		updateDocument.addParam(name = "ptdIssued", value = "#arguments.ptdIssued#", cfsqltype = "cf_sql_varchar" );
		updateDocument.addParam(name = "ptdDate", value = "#arguments.ptdDate#", cfsqltype = "cf_sql_date" );
		updateDocument.addParam(name = "ptdSc", value = "#arguments.ptdSc#", cfsqltype = "cf_sql_varchar" );
		updateDocument.addParam(name = "ptdStatus", value = "#arguments.ptdStatus#", cfsqltype = "cf_sql_integer" );

		updateDocument.setSQL("UPDATE patients_documents 
				SET 
				pt_id=:ptID,
				ptd_document=:ptdDocument,
				ptd_number=:ptdNumber,
				ptd_issued=:ptdIssued,
				ptd_date=:ptdDate,
				ptd_sc=:ptdSc,
				ptd_status=:ptdStatus 
				WHERE ptd_id = :ptdID");

		updateDocument.execute();
		var structUpdateDocument = structNew();
		structUpdateDocument.RETVAL = 1; // create
		structUpdateDocument.RETDESC = 'Информация изменена!';
		return structUpdateDocument;

	}

	function createAddress( ptID, ptaType, ptaFirmData, ptaCountry, ptaRegion, ptaCity, ptaLocality, ptaStreet, ptaIndex, ptaHouse, ptaBuilding, ptaFlat, ptaDescription, ptaStatus ) {
		// дописать время создания и ip
		createAddress = new Query();
		createAddress.setDatasource("#instance.datasource.getDSName()#");
		createAddress.setName("createAddress");
		createAddress.setTimeout("5");

		createAddress.addParam(name = "ptID", value = "#arguments.ptID#", cfsqltype = "cf_sql_integer" );
		createAddress.addParam(name = "ptaType", value = "#arguments.ptaType#", cfsqltype = "cf_sql_integer" );
		createAddress.addParam(name = "ptaFirmData", value = "#arguments.ptaFirmData#", null=yesNoFormat(NOT len(trim(arguments.ptaFirmData))), cfsqltype = "cf_sql_varchar" );
		createAddress.addParam(name = "ptaCountry", value = "#arguments.ptaCountry#", null=yesNoFormat(NOT len(trim(arguments.ptaCountry))), cfsqltype = "cf_sql_varchar" );
		createAddress.addParam(name = "ptaRegion", value = "#arguments.ptaRegion#", null=yesNoFormat(NOT len(trim(arguments.ptaRegion))), cfsqltype = "cf_sql_varchar" );
		createAddress.addParam(name = "ptaCity", value = "#arguments.ptaCity#", null=yesNoFormat(NOT len(trim(arguments.ptaCity))), cfsqltype = "cf_sql_varchar" );
		createAddress.addParam(name = "ptaLocality", value = "#arguments.ptaLocality#", null=yesNoFormat(NOT len(trim(arguments.ptaLocality))), cfsqltype = "cf_sql_varchar" );
		createAddress.addParam(name = "ptaStreet", value = "#arguments.ptaStreet#", null=yesNoFormat(NOT len(trim(arguments.ptaStreet))), cfsqltype = "cf_sql_varchar" );
		createAddress.addParam(name = "ptaIndex", value = "#arguments.ptaIndex#", null=yesNoFormat(NOT len(trim(arguments.ptaIndex))), cfsqltype = "cf_sql_varchar" );
		createAddress.addParam(name = "ptaHouse", value = "#arguments.ptaHouse#", null=yesNoFormat(NOT len(trim(arguments.ptaHouse))), cfsqltype = "cf_sql_varchar" );
		createAddress.addParam(name = "ptaBuilding", value = "#arguments.ptaBuilding#", null=yesNoFormat(NOT len(trim(arguments.ptaBuilding))), cfsqltype = "cf_sql_varchar" );
		createAddress.addParam(name = "ptaFlat", value = "#arguments.ptaFlat#", null=yesNoFormat(NOT len(trim(arguments.ptaFlat))), cfsqltype = "cf_sql_varchar" );
		createAddress.addParam(name = "ptaDescription", value = "#arguments.ptaDescription#", null=yesNoFormat(NOT len(trim(arguments.ptaDescription))), cfsqltype = "cf_sql_varchar" );
		createAddress.addParam(name = "ptaStatus", value = "#arguments.ptaStatus#", cfsqltype = "cf_sql_integer" );
			
		createAddress.setSQL("INSERT INTO patients_addresses ( pt_id, pta_type, pta_firmdata, pta_country, pta_region, pta_city, pta_locality, pta_street, pta_index, pta_house, pta_building, pta_flat, pta_description, pta_status )
			VALUES ( :ptID, :ptaType, :ptaFirmData, :ptaCountry, :ptaRegion, :ptaCity, :ptaLocality, :ptaStreet, :ptaIndex, :ptaHouse, :ptaBuilding, :ptaFlat, :ptaDescription, :ptaStatus )
			");

		createAddress.execute(); // вся структура и result и prefix
		var structCreateAddress=structNew();
		structCreateAddress.RETVAL = 1; //REG
		structCreateAddress.RETDESC = 'Адрес добавлен!';
		return structCreateAddress;
	}

	function updateAddress( ptaID, ptID, ptaType, ptaFirmdata, ptaCountry, ptaRegion, ptaCity, ptaLocality, ptaStreet, ptaIndex, ptaHouse, ptaBuilding, ptaFlat, ptaDescription, ptaStatus ){

		updateAddress = new Query();
		updateAddress.setDatasource("#instance.datasource.getDSName()#");
		updateAddress.setName("updateAddress");
		updateAddress.setTimeout("5");

		updateAddress.addParam(name = "ptaID", value = "#arguments.ptaID#", cfsqltype = "cf_sql_integer" );
		updateAddress.addParam(name = "ptID", value = "#arguments.ptID#", cfsqltype = "cf_sql_integer" );
		updateAddress.addParam(name = "ptaType", value = "#arguments.ptaType#", cfsqltype = "cf_sql_integer" );
		updateAddress.addParam(name = "ptaFirmData", value = "#arguments.ptaFirmData#", null=yesNoFormat(NOT len(trim(arguments.ptaFirmData))), cfsqltype = "cf_sql_varchar" );
		updateAddress.addParam(name = "ptaCountry", value = "#arguments.ptaCountry#", null=yesNoFormat(NOT len(trim(arguments.ptaCountry))), cfsqltype = "cf_sql_varchar" );
		updateAddress.addParam(name = "ptaRegion", value = "#arguments.ptaRegion#", null=yesNoFormat(NOT len(trim(arguments.ptaRegion))), cfsqltype = "cf_sql_varchar" );
		updateAddress.addParam(name = "ptaCity", value = "#arguments.ptaCity#", null=yesNoFormat(NOT len(trim(arguments.ptaCity))), cfsqltype = "cf_sql_varchar" );
		updateAddress.addParam(name = "ptaLocality", value = "#arguments.ptaLocality#", null=yesNoFormat(NOT len(trim(arguments.ptaLocality))), cfsqltype = "cf_sql_varchar" );
		updateAddress.addParam(name = "ptaStreet", value = "#arguments.ptaStreet#", null=yesNoFormat(NOT len(trim(arguments.ptaStreet))), cfsqltype = "cf_sql_varchar" );
		updateAddress.addParam(name = "ptaIndex", value = "#arguments.ptaIndex#", null=yesNoFormat(NOT len(trim(arguments.ptaIndex))), cfsqltype = "cf_sql_varchar" );
		updateAddress.addParam(name = "ptaHouse", value = "#arguments.ptaHouse#", null=yesNoFormat(NOT len(trim(arguments.ptaHouse))), cfsqltype = "cf_sql_varchar" );
		updateAddress.addParam(name = "ptaBuilding", value = "#arguments.ptaBuilding#", null=yesNoFormat(NOT len(trim(arguments.ptaBuilding))), cfsqltype = "cf_sql_varchar" );
		updateAddress.addParam(name = "ptaFlat", value = "#arguments.ptaFlat#", null=yesNoFormat(NOT len(trim(arguments.ptaFlat))), cfsqltype = "cf_sql_varchar" );
		updateAddress.addParam(name = "ptaDescription", value = "#arguments.ptaDescription#", null=yesNoFormat(NOT len(trim(arguments.ptaDescription))), cfsqltype = "cf_sql_varchar" );
		updateAddress.addParam(name = "ptaStatus", value = "#arguments.ptaStatus#", cfsqltype = "cf_sql_integer" );

		updateAddress.setSQL("UPDATE patients_addresses 
				SET 
				pt_id=:ptID,
				pta_type=:ptaType,
				pta_firmdata=:ptaFirmData,
				pta_country=:ptaCountry,
				pta_region=:ptaRegion,
				pta_city=:ptaCity,
				pta_locality=:ptaLocality,
				pta_street=:ptaStreet,
				pta_index=:ptaIndex,
				pta_house=:ptaHouse,
				pta_building=:ptaBuilding,
				pta_flat=:ptaFlat,
				pta_description=:ptaDescription,
				pta_status=:ptaStatus 
				WHERE pta_id = :ptaID");

		updateAddress.execute();
		var structUpdateAddress = structNew();
		structUpdateAddress.RETVAL = 1; // create
		structUpdateAddress.RETDESC = 'Адрес изменён!';
		return structUpdateAddress;

	}


}