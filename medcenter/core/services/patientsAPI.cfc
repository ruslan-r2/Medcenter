/*
	patients API - сервис
*/
component displayname="patientsAPI" output="false" {

	// Псевдо конструктор
	instance.patientsDAO = '';
	instance.patients = '';
	instance.patient = '';
	instance.patient_documents = '';
	instance.patient_addresses = '';
	instance.patient_contacts = '';
	instance.patient_dms = '';
	//instance.patients_uslugi = '';


	instance.patientsDAO = createObject('component', 'core.db.patientsDAO' ).init();


		
	function init(){
		setAllPatientsList();
		return this;
	}

	function setAllPatientsList(){
		instance.patients = instance.patientsDAO.readPatients();
	}

	function setPatient(ptID){
		instance.patient = instance.patientsDAO.readPatient(ptID);
	}

	function getPatient(){
		return instance.patient;
	}

	function setPatientDocuments(ptID){
		instance.patient_documents = instance.patientsDAO.readPatientDocuments(ptID);
	}

	function getPatientDocuments(){
		return instance.patient_documents;
	}

	function getPatientDocument(ptdID){
		patient_document = instance.patientsDAO.readPatientDocument(ptdID);
		return patient_document;
	}

	function setPatientAddresses(ptID){
		instance.patient_addresses = instance.patientsDAO.readPatientAddresses(ptID);
	}

	function getPatientAddress(ptaID){
		patient_add = instance.patientsDAO.readPatientAddress(ptaID);
		return patient_add;
	}

	function getPatientAddresses(){
		return instance.patient_addresses;
	}

	function setPatientContacts(ptID){
		instance.patient_contacts = instance.patientsDAO.readPatientContacts(ptID);
	}

	function getPatientContacts(){
		return instance.patient_contacts;
	}

	function getContact(ptcID){
		return instance.patientsDAO.readContact(arguments.ptcID);
	}

	function getPatientReception(ptID){
		return instance.patientsDAO.readPatientReception(arguments.ptID);
	}

	function getPatientDMS(ptdmsID, ptID){
		return instance.patientsDAO.readPatientDMS(arguments.ptdmsID,arguments.ptID);
	}


	function getAllPatientsList(){
		return instance.patients;
	}

	function searchPatients( _string ){
		return instance.patientsDAO.searchPatients( arguments._string );
	}

	function addPatient( patientFamily, patientFirstName, patientLastName, patientGender, patientDoB, patientStatus ){

		patientFamily = '#Trim(arguments.patientFamily)#';
		if (patientFamily != ''){
			patientFamily = '#UCase(mid(patientFamily, 1,1))##LCase(mid(patientFamily,2,len(patientFamily)-1))#';
		}

		patientFirstName = '#Trim(arguments.patientFirstName)#';
		if (patientFirstName != ''){
			patientFirstName = '#UCase(mid(patientFirstName, 1,1))##LCase(mid(patientFirstName,2,len(patientFirstName)-1))#';
		}

		patientLastName = '#Trim(arguments.patientLastName)#';
		if (patientLastName != ''){
			patientLastName = '#UCase(mid(patientLastName, 1,1))##LCase(mid(patientLastName,2,len(patientLastName)-1))#';
		}

		patientGender = arguments.patientGender;
		patientDoB = arguments.patientDoB;
		patientDateAdd = now();
		patientStatus = arguments.patientStatus;

		var result = structNew();
		result.RETVAL = 0;
		result.RETDESC = "";
		result.STRUCT = structNew(); // для валидации полей

		validator = request.factoryService.getService('Validator');

		var struct_ = validator.checkInput('#patientFamily#',true,'checkString',1,50);
		if ( !struct_.retval ){
			structInsert(result.struct, 'patientFamily','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#patientFirstName#',true,'checkString',1,50);
		if ( !struct_.retval ){
			structInsert(result.struct, 'patientFirstName','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#patientLastName#',true,'checkString',1,50);
		if ( !struct_.retval ){
			structInsert(result.struct, 'patientLastName','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#patientGender#',true,'checkString',0,50);
		if ( !struct_.retval ){
			structInsert(result.struct, 'patientGender','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#patientDoB#',true,'isDate',1,100);
		if ( !struct_.retval ){
			structInsert(result.struct, 'patientDoB','#struct_.retdesc#');
		}
		var struct_ = validator.checkInput('#patientDateAdd#',true,'isDate',0,100);
		if ( !struct_.retval ){
			structInsert(result.struct, 'patientDateAdd','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#patientStatus#',true,'isNumeric',1,2);
		if ( !struct_.retval ){
			structInsert(result.struct, 'patientStatus','#struct_.retdesc#');
		}
		//--------------------------------------------------------------------
		// делаем запрос к базе есть ли такой пациент
		if ( structIsEmpty(result.struct) ){
			chPatient = instance.patientsDAO.checkPatient( patientFamily, patientFirstName, patientLastName, patientDoB );
			if (chPatient.recordcount){
				structInsert(result.struct, 'chPatient','Пациент: #patientFamily# #patientFirstName# #patientLastName# (дата рождения: #patientDoB#) - уже есть в базе.');
			}
		}

	        // если обнаружены ошибки
		if ( structIsEmpty(result.struct) ){

			structCreatePatient = instance.patientsDAO.createPatient( patientFamily, patientFirstName, patientLastName, patientGender, patientDoB, patientDateAdd, patientStatus );

			if (structCreatePatient.RETVAL == 1){
				result.RETVAL = structCreatePatient.RETVAL;
				result.RETDESC = structCreatePatient.RETDESC;
			}else {
				result.RETVAL = structCreatePatient.RETVAL;
				result.RETDESC = structCreatePatient.RETDESC;
			}

		}
		return result;
	}

	function editePatient( patientID, patientFamily, patientFirstName, patientLastName, patientGender, patientDoB, patientStatus ){

		patientID = arguments.patientID;
		patientFamily = '#Trim(arguments.patientFamily)#';
		patientFamily = '#UCase(mid(patientFamily, 1,1))##LCase(mid(patientFamily,2,len(patientFamily)-1))#';
		patientFirstName = '#Trim(arguments.patientFirstName)#';
		patientFirstName = '#UCase(mid(patientFirstName, 1,1))##LCase(mid(patientFirstName,2,len(patientFirstName)-1))#';
		patientLastName = '#Trim(arguments.patientLastName)#';
		patientLastName = '#UCase(mid(patientLastName, 1,1))##LCase(mid(patientLastName,2,len(patientLastName)-1))#';

		patientGender = arguments.patientGender;
		patientDoB = arguments.patientDoB;
		patientDateAdd = now();
		patientStatus = arguments.patientStatus;

		var result = structNew();
		result.RETVAL = 0;
		result.RETDESC = "";
		result.STRUCT = structNew(); // для валидации полей

		validator = request.factoryService.getService('Validator');

		var struct_ = validator.checkInput('#patientFamily#',true,'checkString',0,50);
		if ( !struct_.retval ){
			structInsert(result.struct, 'patientFamily','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#patientFirstName#',true,'checkString',0,50);
		if ( !struct_.retval ){
			structInsert(result.struct, 'patientFirstName','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#patientLastName#',true,'checkString',0,50);
		if ( !struct_.retval ){
			structInsert(result.struct, 'patientLastName','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#patientGender#',true,'checkString',0,50);
		if ( !struct_.retval ){
			structInsert(result.struct, 'patientGender','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#patientDoB#',true,'isDate',0,100);
		if ( !struct_.retval ){
			structInsert(result.struct, 'patientDoB','#struct_.retdesc#');
		}
		var struct_ = validator.checkInput('#patientDateAdd#',true,'isDate',0,100);
		if ( !struct_.retval ){
			structInsert(result.struct, 'patientDateAdd','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#patientStatus#',true,'isNumeric',1,2);
		if ( !struct_.retval ){
			structInsert(result.struct, 'patientStatus','#struct_.retdesc#');
		}
		//--------------------------------------------------------------------
		// делаем запрос к базе есть ли такой пациент
		chPatient = instance.patientsDAO.checkPatient( patientFamily, patientFirstName, patientLastName, patientDoB );
		if (chPatient.recordcount){
			structInsert(result.struct, 'chPatient','Пациент: #patientFamily# #patientFirstName# #patientLastName# (дата рождения: #patientDoB#) - уже есть в базе.');
		}

	        // если обнаружены ошибки
		if ( structIsEmpty(result.struct) ){

			structEditePatient = instance.patientsDAO.updatePatient( patientID, patientFamily, patientFirstName, patientLastName, patientGender, patientDoB, patientDateAdd, patientStatus );

			if (structEditePatient.RETVAL == 1){
				result.RETVAL = structEditePatient.RETVAL;
				result.RETDESC = structEditePatient.RETDESC;
			}else {
				result.RETVAL = structEditePatient.RETVAL;
				result.RETDESC = structEditePatient.RETDESC;
			}

		}
		return result;
	}

	function addContact( ptID, ctID, ptcData, ptcDescription, ptcStatus ){

		ptID = arguments.ptID; 
		ctID = arguments.ctID;
		ptcData = arguments.ptcData;
		ptcDescription = arguments.ptcDescription;
		ptcStatus = arguments.ptcStatus;

		var result = structNew();
		result.RETVAL = 0;
		result.RETDESC = "";
		result.STRUCT = structNew(); // для валидации полей

		validator = request.factoryService.getService('Validator');

		var struct_ = validator.checkInput('#arguments.ptID#',true,'isNumeric',1,1000000);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptID','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.ctID#',true,'isNumeric',1,2);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ctID','#struct_.retdesc#');
		}

		if(ctID == 1){ // email isValidEmail
			var struct_ = validator.checkInput('#ptcData#',true,'isValidEmail',2,35);
			if ( !struct_.retval ){
				structInsert(result.struct, 'ptcData','#struct_.retdesc#');
			}

		}else if(ctID == 2){ //tel_mob
			var struct_ = validator.checkInput('#ptcData#',true,'isValidTelMob',10,10);
			if ( !struct_.retval ){
				structInsert(result.struct, 'ptcData','#struct_.retdesc#');
			}
		
		}else if(ctID == 3){ //tel_gor
			var struct_ = validator.checkInput('#ptcData#',true,'isValidTelGor',10,10);
			if ( !struct_.retval ){
				structInsert(result.struct, 'ptcData','#struct_.retdesc#');
			}
		
		}else if(ctID == 4){ //skype
			var struct_ = validator.checkInput('#ptcData#',true,'isAllowSimbol',2,35);
			if ( !struct_.retval ){
				structInsert(result.struct, 'ptcData','#struct_.retdesc#');
			}

		}else if(ctID == 5){ //icq
			var struct_ = validator.checkInput('#ptcData#',true,'isNumeric',1,15);
			if ( !struct_.retval ){
				structInsert(result.struct, 'ptcData','#struct_.retdesc#');
			}

		}

		/*
		if ( !isDefined('result.struct.ptcData') ){
			chPatientC = instance.patientsDAO.checkContact( ptcData );
			if (chPatientC.recordcount){
				structInsert(result.struct, 'ptcData','Контакт "<b>#ptcData#</b>" уже есть в базе!');
			}
		}
		*/

		var struct_ = validator.checkInput('#arguments.ptcDescription#',false,'checkString',0,250);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptcDescription','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#ptcStatus#',true,'isNumeric',1,2);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptcStatus','#struct_.retdesc#');
		}
		//--------------------------------------------------------------------

	        // если обнаружены ошибки
		if ( structIsEmpty(result.struct) ){

			structCreateContact = instance.patientsDAO.createContact( ptID, ctID, ptcData, ptcDescription, ptcStatus );

			if (structCreateContact.RETVAL == 1){
				result.RETVAL = structCreateContact.RETVAL;
				result.RETDESC = structCreateContact.RETDESC;
			}else {
				result.RETVAL = structCreateContact.RETVAL;
				result.RETDESC = structCreateContact.RETDESC;
			}

		}
		return result;
	}

	function editeContact( ptcID, ptID, ctID, ptcData, ptcDescription, ptcStatus ){

		ptcID = arguments.ptcID; 
		ptID = arguments.ptID; 
		ctID = arguments.ctID;
		ptcData = arguments.ptcData;
		ptcDescription = arguments.ptcDescription;
		ptcStatus = arguments.ptcStatus;

		var result = structNew();
		result.RETVAL = 0;
		result.RETDESC = "";
		result.STRUCT = structNew(); // для валидации полей

		validator = request.factoryService.getService('Validator');

		var struct_ = validator.checkInput('#arguments.ptcID#',true,'isNumeric',1,1000000);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptcID','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.ptID#',true,'isNumeric',1,1000000);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptID','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.ctID#',true,'isNumeric',1,2);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ctID','#struct_.retdesc#');
		}

		if(ctID == 1){ // email isValidEmail
			var struct_ = validator.checkInput('#arguments.ptcData#',true,'isValidEmail',2,35);
			if ( !struct_.retval ){
				structInsert(result.struct, 'ptcData','#struct_.retdesc#');
			}

		}else if(ctID == 2){ //tel_mob
			var struct_ = validator.checkInput('#arguments.ptcData#',true,'isValidTelMob',10,10);
			if ( !struct_.retval ){
				structInsert(result.struct, 'ptcData','#struct_.retdesc#');
			}
		
		}else if(ctID == 3){ //tel_gor
			var struct_ = validator.checkInput('#arguments.ptcData#',true,'isValidTelGor',10,10);
			if ( !struct_.retval ){
				structInsert(result.struct, 'ptcData','#struct_.retdesc#');
			}
		
		}else if(ctID == 4){ //skype
			var struct_ = validator.checkInput('#arguments.ptcData#',true,'isAllowSimbol',2,35);
			if ( !struct_.retval ){
				structInsert(result.struct, 'ptcData','#struct_.retdesc#');
			}

		}else if(ctID == 5){ //icq
			var struct_ = validator.checkInput('#arguments.ptcData#',true,'isNumeric',1,15);
			if ( !struct_.retval ){
				structInsert(result.struct, 'ptcData','#struct_.retdesc#');
			}

		}

		/*
		if ( !isDefined('result.struct.ptcData') ){
			chPatientC = instance.patientsDAO.checkContact( ptcData );
			if (chPatientC.recordcount){
				structInsert(result.struct, 'ptcData','Контакт "<b>#ptcData#</b>" уже есть в базе!');
			}
		}
		*/

		var struct_ = validator.checkInput('#arguments.ptcDescription#',false,'checkString',0,250);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptcDescription','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#ptcStatus#',true,'isNumeric',1,2);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptcStatus','#struct_.retdesc#');
		}
		//--------------------------------------------------------------------

	        // если обнаружены ошибки
		if ( structIsEmpty(result.struct) ){

			structEditeContact = instance.patientsDAO.updateContact( ptcID, ptID, ctID, ptcData, ptcDescription, ptcStatus );

			if (structEditeContact.RETVAL == 1){
				result.RETVAL = structEditeContact.RETVAL;
				result.RETDESC = structEditeContact.RETDESC;
			}else {
				result.RETVAL = structEditeContact.RETVAL;
				result.RETDESC = structEditeContact.RETDESC;
			}

		}
		return result;
	}

	function editeAnamnez( ptID, ptAnamnez ){

		ptID = arguments.ptID;
		ptAnamnez = arguments.ptAnamnez;

		var result = structNew();
		result.RETVAL = 0;
		result.RETDESC = "";
		result.STRUCT = structNew(); // для валидации полей

		validator = request.factoryService.getService('Validator');

		for (var i=1; i<=arrayLen(ptAnamnez); i++){
			var struct_ = validator.checkInput('#ptAnamnez[i].data#',false,'checkString',0,2000);
			if ( !struct_.retval ){
				structInsert(result.struct, '#ptAnamnez[i].name#','#struct_.retdesc#');
			}
		}

		//--------------------------------------------------------------------

	        // если обнаружены ошибки
		if ( structIsEmpty(result.struct) ){

			ptAnamnez = SerializeJSON(ptAnamnez);
			structEditeAnamnez = instance.patientsDAO.updateAnamnez(ptID,ptAnamnez);

			if (structEditeAnamnez.RETVAL == 1){
				result.RETVAL = structEditeAnamnez.RETVAL;
				result.RETDESC = structEditeAnamnez.RETDESC;
			}else {
				result.RETVAL = structEditeAnamnez.RETVAL;
				result.RETDESC = structEditeAnamnez.RETDESC;
			}

		}
		return result;
	}

	function addDocument( ptID, ptdDocument, ptdNumber, ptdNumber1, ptdIssued, ptdDate, ptdSc, ptdSc1, ptdStatus ){

		ptID = arguments.ptID; 
		ptdDocument = arguments.ptdDocument;
		ptdNumber = arguments.ptdNumber;
		ptdNumber1 = arguments.ptdNumber1;
		ptdIssued = arguments.ptdIssued;
		ptdDate = arguments.ptdDate;
		ptdSc = arguments.ptdSc;
		ptdSc1 = arguments.ptdSc1;
		ptdStatus = arguments.ptdStatus;


		var result = structNew();
		result.RETVAL = 0;
		result.RETDESC = "";
		result.STRUCT = structNew(); // для валидации полей

		validator = request.factoryService.getService('Validator');

		var struct_ = validator.checkInput('#ptID#',true,'isNumeric',1,1000000);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptID','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#ptdDocument#',true,'checkString',1,25);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptdDocument','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#ptdNumber#',true,'isNumeric',4,4);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptdNumber','#struct_.retdesc#');
		}
		var struct_ = validator.checkInput('#ptdNumber1#',true,'isNumeric',6,6);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptdNumber1','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#ptdIssued#',true,'checkString',1,50); // нужно изменить
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptdIssued','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#ptdDate#',true,'isDate',1,20);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptdDate','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#ptdSc#',true,'isNumeric',3,3);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptdSc','#struct_.retdesc#');
		}
		var struct_ = validator.checkInput('#ptdSc1#',true,'isNumeric',3,3);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptdSc1','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#ptdStatus#',true,'isNumeric',1,2);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptdStatus','#struct_.retdesc#');
		}
		//--------------------------------------------------------------------

	        // если обнаружены ошибки
		if ( structIsEmpty(result.struct) ){
			ptdNumber = '#arguments.ptdNumber#-#arguments.ptdNumber1#';
			ptdSc = '#ptdSc#-#ptdSc1#';
			structCreateDocument = instance.patientsDAO.createDocument( ptID, ptdDocument, ptdNumber, ptdIssued, ptdDate, ptdSc, ptdStatus );
			
			if (structCreateDocument.RETVAL == 1){
				result.RETVAL = structCreateDocument.RETVAL;
				result.RETDESC = structCreateDocument.RETDESC;
			}else {
				result.RETVAL = structCreateDocument.RETVAL;
				result.RETDESC = structCreateDocument.RETDESC;
			}

		}
		return result;
	}

	function editeDocument( ptdID, ptID, ptdDocument, ptdNumber, ptdNumber1, ptdIssued, ptdDate, ptdSc, ptdSc1, ptdStatus ){

		ptdID = arguments.ptdID; 
		ptID = arguments.ptID; 
		ptdDocument = arguments.ptdDocument;
		ptdNumber = arguments.ptdNumber;
		ptdNumber1 = arguments.ptdNumber1;
		ptdIssued = arguments.ptdIssued;
		ptdDate = arguments.ptdDate;
		ptdSc = arguments.ptdSc;
		ptdSc1 = arguments.ptdSc1;
		ptdStatus = arguments.ptdStatus;


		var result = structNew();
		result.RETVAL = 0;
		result.RETDESC = "";
		result.STRUCT = structNew(); // для валидации полей

		validator = request.factoryService.getService('Validator');

		var struct_ = validator.checkInput('#ptdID#',true,'isNumeric',1,1000000);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptdID','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#ptID#',true,'isNumeric',1,1000000);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptID','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#ptdDocument#',true,'checkString',1,25);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptdDocument','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#ptdNumber#',true,'isNumeric',4,4);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptdNumber','#struct_.retdesc#');
		}
		var struct_ = validator.checkInput('#ptdNumber1#',true,'isNumeric',6,6);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptdNumber1','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#ptdIssued#',true,'checkString',1,50); // нужно изменить
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptdIssued','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#ptdDate#',true,'isDate',1,20);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptdDate','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#ptdSc#',true,'isNumeric',3,3);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptdSc','#struct_.retdesc#');
		}
		var struct_ = validator.checkInput('#ptdSc1#',true,'isNumeric',3,3);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptdSc1','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#ptdStatus#',true,'isNumeric',1,2);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptdStatus','#struct_.retdesc#');
		}
		//--------------------------------------------------------------------

	        // если обнаружены ошибки
		if ( structIsEmpty(result.struct) ){
			ptdNumber = '#arguments.ptdNumber#-#arguments.ptdNumber1#';
			ptdSc = '#ptdSc#-#ptdSc1#';
			structUpdateDocument = instance.patientsDAO.updateDocument( ptdID, ptID, ptdDocument, ptdNumber, ptdIssued, ptdDate, ptdSc, ptdStatus );
			
			if (structUpdateDocument.RETVAL == 1){
				result.RETVAL = structUpdateDocument.RETVAL;
				result.RETDESC = structUpdateDocument.RETDESC;
			}else {
				result.RETVAL = structUpdateDocument.RETVAL;
				result.RETDESC = structUpdateDocument.RETDESC;
			}

		}
		return result;
	}

	function addAddress( ptID, ptaType, ptaFirmData, ptaCountry, ptaRegion, ptaCity, ptaLocality, ptaStreet, ptaIndex, ptaHouse, ptaBuilding, ptaFlat, ptaDescription, ptaStatus ){

		ptID = arguments.ptID;
		ptaType = arguments.ptaType;
		ptaFirmData = arguments.ptaFirmData;
		ptaCountry = arguments.ptaCountry;
		ptaRegion = arguments.ptaRegion;
		ptaCity = arguments.ptaCity;
		ptaLocality = arguments.ptaLocality;
		ptaStreet = arguments.ptaStreet;
		ptaIndex = arguments.ptaIndex;
		ptaHouse = arguments.ptaHouse;
		ptaBuilding = arguments.ptaBuilding;
		ptaFlat = arguments.ptaFlat;
		ptaDescription = arguments.ptaDescription;
		ptaStatus = arguments.ptaStatus;

		var result = structNew();
		result.RETVAL = 0;
		result.RETDESC = "";
		result.STRUCT = structNew(); // для валидации полей

		validator = request.factoryService.getService('Validator');

		var struct_ = validator.checkInput('#ptID#',true,'isNumeric',1,1000000);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptID','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#ptaType#',true,'isNumeric',1,1);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptaType','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#ptaFirmData#',false,'checkString',1,500);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptaFirmData','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#ptaCountry#',false,'checkString',0,50);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptaCountry','#struct_.retdesc#');
		}
		var struct_ = validator.checkInput('#ptaRegion#',false,'checkString',0,50);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptaRegion','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#ptaCity#',false,'checkString',0,50); // нужно изменить
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptaCity','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#ptaLocality#',false,'checkString',0,50);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptaLocality','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#ptaStreet#',false,'checkString',0,50);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptaStreet','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#ptaIndex#',false,'isNumeric',6,6);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptaIndex','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#ptaHouse#',false,'checkString',1,10);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptaHouse','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#ptaBuilding#',false,'checkString',1,10);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptaBuilding','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#ptaFlat#',false,'checkString',1,10);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptaFlat','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#ptaDescription#',false,'checkString',1,250);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptaDescription','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#ptaStatus#',true,'isNumeric',1,2);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptaStatus','#struct_.retdesc#');
		}
		//--------------------------------------------------------------------

	        // если обнаружены ошибки
		if ( structIsEmpty(result.struct) ){

			writeDump(arguments);

			structCreateAddress = instance.patientsDAO.createAddress( ptID, ptaType, ptaFirmData, ptaCountry, ptaRegion, ptaCity, ptaLocality, ptaStreet, ptaIndex, ptaHouse, ptaBuilding, ptaFlat, ptaDescription, ptaStatus );
			
			if (structCreateAddress.RETVAL == 1){
				result.RETVAL = structCreateAddress.RETVAL;
				result.RETDESC = structCreateAddress.RETDESC;
			}else {
				result.RETVAL = structCreateAddress.RETVAL;
				result.RETDESC = structCreateAddress.RETDESC;
			}

		}
		return result;
	}

	function editeAddress( ptaID, ptID, ptaType, ptaFirmData, ptaCountry, ptaRegion, ptaCity, ptaLocality, ptaStreet, ptaIndex, ptaHouse, ptaBuilding, ptaFlat, ptaDescription, ptaStatus ){

		ptaID = arguments.ptaID;
		ptID = arguments.ptID;
		ptaType = arguments.ptaType;
		ptaFirmData = arguments.ptaFirmData;
		ptaCountry = arguments.ptaCountry;
		ptaRegion = arguments.ptaRegion;
		ptaCity = arguments.ptaCity;
		ptaLocality = arguments.ptaLocality;
		ptaStreet = arguments.ptaStreet;
		ptaIndex = arguments.ptaIndex;
		ptaHouse = arguments.ptaHouse;
		ptaBuilding = arguments.ptaBuilding;
		ptaFlat = arguments.ptaFlat;
		ptaDescription = arguments.ptaDescription;
		ptaStatus = arguments.ptaStatus;

		var result = structNew();
		result.RETVAL = 0;
		result.RETDESC = "";
		result.STRUCT = structNew(); // для валидации полей

		validator = request.factoryService.getService('Validator');

		var struct_ = validator.checkInput('#ptaID#',true,'isNumeric',1,1000000);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptaID','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#ptID#',true,'isNumeric',1,1000000);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptID','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#ptaType#',true,'isNumeric',1,1);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptaType','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#ptaFirmData#',false,'checkString',1,500);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptaFirmData','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#ptaCountry#',false,'checkString',0,50);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptaCountry','#struct_.retdesc#');
		}
		var struct_ = validator.checkInput('#ptaRegion#',false,'checkString',0,50);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptaRegion','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#ptaCity#',false,'checkString',0,50); // нужно изменить
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptaCity','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#ptaLocality#',false,'checkString',0,50);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptaLocality','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#ptaStreet#',false,'checkString',0,50);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptaStreet','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#ptaIndex#',false,'isNumeric',6,6);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptaIndex','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#ptaHouse#',false,'checkString',1,10);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptaHouse','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#ptaBuilding#',false,'checkString',1,10);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptaBuilding','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#ptaFlat#',false,'checkString',1,10);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptaFlat','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#ptaDescription#',false,'checkString',1,250);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptaDescription','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#ptaStatus#',true,'isNumeric',1,2);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptaStatus','#struct_.retdesc#');
		}
		//--------------------------------------------------------------------

	        // если обнаружены ошибки
		if ( structIsEmpty(result.struct) ){

			structUpdateAddress = instance.patientsDAO.updateAddress( ptaID, ptID, ptaType, ptaFirmData, ptaCountry, ptaRegion, ptaCity, ptaLocality, ptaStreet, ptaIndex, ptaHouse, ptaBuilding, ptaFlat, ptaDescription, ptaStatus );
			
			if (structUpdateAddress.RETVAL == 1){
				result.RETVAL = structUpdateAddress.RETVAL;
				result.RETDESC = structUpdateAddress.RETDESC;
			}else {
				result.RETVAL = structUpdateAddress.RETVAL;
				result.RETDESC = structUpdateAddress.RETDESC;
			}

		}
		return result;
	}

	function addDMS( ptID, cdmsID, ptdmsPolisNumber, ptdmsDescription, ptdmsStatus ){

		ptID = arguments.ptID; 
		cdmsID = arguments.cdmsID;
		ptdmsPolisNumber = arguments.ptdmsPolisNumber;
		ptdmsDescription = arguments.ptdmsDescription;
		ptdmsStatus = arguments.ptdmsStatus;

		var result = structNew();
		result.RETVAL = 0;
		result.RETDESC = "";
		result.STRUCT = structNew(); // для валидации полей

		validator = request.factoryService.getService('Validator');

		var struct_ = validator.checkInput('#arguments.ptID#',true,'isNumeric',1,1000000);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptID','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.cdmsID#',true,'isNumeric',1,1000000);
		if ( !struct_.retval ){
			structInsert(result.struct, 'cdmsID','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.ptdmsPolisNumber#',true,'checkString',1,50);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptdmsPolisNumber','#struct_.retdesc#');
		}

		/*
		if ( !isDefined('result.struct.ptcData') ){
			chPatientC = instance.patientsDAO.checkContact( ptcData );
			if (chPatientC.recordcount){
				structInsert(result.struct, 'ptcData','Контакт "<b>#ptcData#</b>" уже есть в базе!');
			}
		}
		*/

		var struct_ = validator.checkInput('#arguments.ptdmsDescription#',false,'checkString',0,500);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptdmsDescription','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#ptdmsStatus#',true,'isNumeric',1,2);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptdmsStatus','#struct_.retdesc#');
		}
		//--------------------------------------------------------------------

	        // если обнаружены ошибки
		if ( structIsEmpty(result.struct) ){

			structCreateDMS = instance.patientsDAO.createDMS( ptID, cdmsID, ptdmsPolisNumber, ptdmsDescription, ptdmsStatus );

			if (structCreateDMS.RETVAL == 1){
				result.RETVAL = structCreateDMS.RETVAL;
				result.RETDESC = structCreateDMS.RETDESC;
			}else {
				result.RETVAL = structCreateDMS.RETVAL;
				result.RETDESC = structCreateDMS.RETDESC;
			}

		}
		return result;
	}

	function editeDMS( ptdmsID, ptID, cdmsID, ptdmsPolisNumber, ptdmsDescription, ptdmsStatus ){

		ptdmsID = arguments.ptdmsID; 
		ptID = arguments.ptID; 
		cdmsID = arguments.cdmsID;
		ptdmsPolisNumber = arguments.ptdmsPolisNumber;
		ptdmsDescription = arguments.ptdmsDescription;
		ptdmsStatus = arguments.ptdmsStatus;

		var result = structNew();
		result.RETVAL = 0;
		result.RETDESC = "";
		result.STRUCT = structNew(); // для валидации полей

		validator = request.factoryService.getService('Validator');

		var struct_ = validator.checkInput('#arguments.ptID#',true,'isNumeric',1,1000000);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptID','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.cdmsID#',true,'isNumeric',1,1000000);
		if ( !struct_.retval ){
			structInsert(result.struct, 'cdmsID','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.ptdmsPolisNumber#',true,'checkString',1,50);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptdmsPolisNumber','#struct_.retdesc#');
		}

		/*
		if ( !isDefined('result.struct.ptcData') ){
			chPatientC = instance.patientsDAO.checkContact( ptcData );
			if (chPatientC.recordcount){
				structInsert(result.struct, 'ptcData','Контакт "<b>#ptcData#</b>" уже есть в базе!');
			}
		}
		*/

		var struct_ = validator.checkInput('#arguments.ptdmsDescription#',false,'checkString',0,500);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptdmsDescription','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#ptdmsStatus#',true,'isNumeric',1,2);
		if ( !struct_.retval ){
			structInsert(result.struct, 'ptdmsStatus','#struct_.retdesc#');
		}
		//--------------------------------------------------------------------

	        // если обнаружены ошибки
		if ( structIsEmpty(result.struct) ){

			structUpdateDMS = instance.patientsDAO.updateDMS( ptdmsID, ptID, cdmsID, ptdmsPolisNumber, ptdmsDescription, ptdmsStatus );

			if (structUpdateDMS.RETVAL == 1){
				result.RETVAL = structUpdateDMS.RETVAL;
				result.RETDESC = structUpdateDMS.RETDESC;
			}else {
				result.RETVAL = structUpdateDMS.RETVAL;
				result.RETDESC = structUpdateDMS.RETDESC;
			}

		}
		return result;
	}

	function getMemento(){
		return instance;
	}


}