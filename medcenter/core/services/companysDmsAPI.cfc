/*
	companysDmsAPI - список услуг.
*/

component attributeName='companysDmsAPI' output='false'{

	// Псевдо конструктор
	instance.companysDmsDAO = createObject('component', 'core.db.companysDmsDAO' ).Init();

	//instance.companysDms = {};

	function init(){
		return this;
	}

	function getCompanysDmsList(){
		qCompanysDms = instance.companysDmsDAO.readCompanysDmsList();
		return qCompanysDms;
	}

	function getCompanysDmsReport( reportDateStart, reportDateEnd, cdmsID ){

		reportDateStart = arguments.reportDateStart;
		reportDateEnd = arguments.reportDateEnd;
		//reportDateStart = CreateODBCDate(arguments.reportDateStart);
		//reportDateEnd = CreateODBCDate(arguments.reportDateEnd);
		cdmsID = arguments.cdmsID;

		var result = structNew();
		result.RETVAL = 0;
		result.RETDESC = "";
		result.STRUCT = structNew(); // для валидации полей

		validator = request.factoryService.getService('Validator');
		var struct_ = validator.checkInput('#cdmsID#',true,'isNumeric',1,1000000);
		if ( !struct_.retval ){
			structInsert(result.struct, 'cdmsID','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#reportDateStart#',true,'isDate',0,100);
		if ( !struct_.retval ){
			structInsert(result.struct, 'reportDateStart','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#reportDateEnd#',true,'isDate',0,100);
		if ( !struct_.retval ){
			structInsert(result.struct, 'reportDateEnd','#struct_.retdesc#');
		}

		if ( structIsEmpty(result.struct) ){

			qCompanysDmsReport = instance.companysDmsDAO.readCompanysDmsReport( CreateODBCDate(reportDateStart), CreateODBCDate(reportDateEnd), cdmsID );

			if (qCompanysDmsReport.RETVAL == 1){
				result.RETVAL = qCompanysDmsReport.RETVAL;
				result.RETDESC = qCompanysDmsReport.RETDESC;
				result.RETDATA = qCompanysDmsReport.RETDATA;
			}else {
				result.RETVAL = 0;
				result.RETDESC = 'Ошибка при обращении к базе!';
			}

		}
		return result;

		qCompanysDmsReport = instance.companysDmsDAO.readCompanysDmsReport( arguments.reportDateStart, arguments.reportDateEnd, arguments.cdmsID );
		return qCompanysDmsReport;
	}

	function getCompanyDms( cdmsid ){
		qCompanyDms = instance.companysDmsDAO.readCompanyDms( arguments.cdmsid );
		return qCompanyDms;
	}

	function addCompanyDMS( cdmsName, cdmsContractNumber, cdmsDateStart, cdmsDateEnd, cdmsDescription, cdmsStatus ){

		cdmsName = arguments.cdmsName;
		cdmsContractNumber = arguments.cdmsContractNumber;
		cdmsDateStart = arguments.cdmsDateStart;
		cdmsDateEnd = arguments.cdmsDateEnd;
		cdmsDescription = arguments.cdmsDescription;
		cdmsStatus = arguments.cdmsStatus;

		var result = structNew();
		result.RETVAL = 0;
		result.RETDESC = "";
		result.STRUCT = structNew(); // для валидации полей

		validator = request.factoryService.getService('Validator');
		                                               //required
		var struct_ = validator.checkInput('#cdmsName#',true,'checkString',2,250);
		if ( !struct_.retval ){
			structInsert(result.struct, 'cdmsName','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#cdmsContractNumber#',false,'checkString',0,50);
		if ( !struct_.retval ){
			structInsert(result.struct, 'cdmsContractNumber','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#cdmsDateStart#',false,'isDate',0,100);
		if ( !struct_.retval ){
			structInsert(result.struct, 'cdmsDateStart','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#cdmsDateEnd#',false,'isDate',0,100);
		if ( !struct_.retval ){
			structInsert(result.struct, 'cdmsDateEnd','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#cdmsDescription#',false,'checkString',0,250);
		if ( !struct_.retval ){
			structInsert(result.struct, 'cdmsDescription','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#cdmsStatus#',false,'isNumeric',1,2);
		if ( !struct_.retval ){
			structInsert(result.struct, 'cdmsStatus','#struct_.retdesc#');
		}
		//--------------------------------------------------------------------
		rbac = request.RBAC;
		if ( !rbac.CheckAccess('companysDMS','create') ){
			structInsert(result.struct, 'RBAC','У вас недостаточно прав!');
		}
		//--------------------------------------------------------------------


	        // если обнаружены ошибки
		if ( structIsEmpty(result.struct) ){

			structCreateCompanyDMS = instance.companysDmsDAO.createCompanyDms( cdmsName, cdmsContractNumber, cdmsDateStart, cdmsDateEnd, cdmsDescription, cdmsStatus );

			if (structCreateCompanyDMS.RETVAL == 1){
				result.RETVAL = structCreateCompanyDMS.RETVAL;
				result.RETDESC = structCreateCompanyDMS.RETDESC;
			}else {
				result.RETVAL = structCreateCompanyDMS.RETVAL;
				result.RETDESC = structCreateCompanyDMS.RETDESC;
			}

		}
		return result;
	}

	function editeCompanyDMS( cdmsID, cdmsName, cdmsContractNumber, cdmsDateStart, cdmsDateEnd, cdmsDescription, cdmsStatus ){

		cdmsID = arguments.cdmsID;
		cdmsName = arguments.cdmsName;
		cdmsContractNumber = arguments.cdmsContractNumber;
		cdmsDateStart = arguments.cdmsDateStart;
		cdmsDateEnd = arguments.cdmsDateEnd;
		cdmsDescription = arguments.cdmsDescription;
		cdmsStatus = arguments.cdmsStatus;

		var result = structNew();
		result.RETVAL = 0;
		result.RETDESC = "";
		result.STRUCT = structNew(); // для валидации полей

		validator = request.factoryService.getService('Validator');
		                                               //required
		var struct_ = validator.checkInput('#cdmsName#',true,'checkString',2,250);
		if ( !struct_.retval ){
			structInsert(result.struct, 'cdmsName','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#cdmsContractNumber#',false,'checkString',0,50);
		if ( !struct_.retval ){
			structInsert(result.struct, 'cdmsContractNumber','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#cdmsDateStart#',false,'isDate',0,100);
		if ( !struct_.retval ){
			structInsert(result.struct, 'cdmsDateStart','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#cdmsDateEnd#',false,'isDate',0,100);
		if ( !struct_.retval ){
			structInsert(result.struct, 'cdmsDateEnd','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#cdmsDescription#',false,'checkString',0,250);
		if ( !struct_.retval ){
			structInsert(result.struct, 'cdmsDescription','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#cdmsStatus#',false,'isNumeric',1,2);
		if ( !struct_.retval ){
			structInsert(result.struct, 'cdmsStatus','#struct_.retdesc#');
		}
		//--------------------------------------------------------------------
		rbac = request.RBAC;
		if ( !rbac.CheckAccess('companysDMS','create') ){
			structInsert(result.struct, 'RBAC','У вас недостаточно прав!');
		}
		//--------------------------------------------------------------------


	        // если обнаружены ошибки
		if ( structIsEmpty(result.struct) ){

			structUpdateCompanyDMS = instance.companysDmsDAO.updateCompanyDms( cdmsID, cdmsName, cdmsContractNumber, cdmsDateStart, cdmsDateEnd, cdmsDescription, cdmsStatus );

			if (structUpdateCompanyDMS.RETVAL == 1){
				result.RETVAL = structUpdateCompanyDMS.RETVAL;
				result.RETDESC = structUpdateCompanyDMS.RETDESC;
			}else {
				result.RETVAL = structUpdateCompanyDMS.RETVAL;
				result.RETDESC = structUpdateCompanyDMS.RETDESC;
			}

		}
		return result;
	}

}