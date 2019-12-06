component displayName='companysDmsDAO'{

	// Псевдо конструктор
	instance = {datasource = ''} ; // объект
	instance.datasource = createObject('component', 'core.db.Datasource').init();


	function Init (){
		return this;
	}

	function readCompanysDmsList(){

		qCompanysDmsList = new Query();
		qCompanysDmsList.setName("readCompanysDmsList");
		qCompanysDmsList.setTimeout("5");
		qCompanysDmsList.setDatasource("#variables.instance.datasource.getDSName()#");

		qCompanysDmsList.setSQL("SELECT * , ( SELECT COUNT(*) as cnt FROM patients_dms WHERE ptdms_status > 0 AND cdms_id = a.cdms_id) as cnt
					FROM companysdms a ORDER BY a.cdms_name asc");
	
		var execute = qCompanysDmsList.execute(); // вся структура и result и prefix
		var result = execute.getResult();
		return result; //query
	}

	function readCompanysDmsReport( ReportdateStart, ReportdateEnd, cdmsID ){

		qCompanysDmsReport = new Query();
		qCompanysDmsReport.setName("readCompanysDmsReport");
		qCompanysDmsReport.setTimeout("5");
		qCompanysDmsReport.setDatasource("#variables.instance.datasource.getDSName()#");

		qCompanysDmsReport.setSQL("
						SELECT a.pt_id, a.cdms_id, a.ptdms_polis_number, b.rp_id, b.rp_date, b.user_id, c.pt_family, c.pt_firstname, c.pt_lastname, d.sv_id, d.sv_name, d.sv_price, d.pls_id, d.st_id, e.emp_family, e.emp_firstname, e.emp_lastname
						FROM patients_dms a, reception b, patients c, services d, bbs_users e
						WHERE a.ptdms_status > 0 
							AND a.cdms_id = #arguments.cdmsID#
							AND a.pt_id = b.pt_id
							AND a.pt_id = c.pt_id
							AND b.rp_id = d.rp_id
							AND b.user_id = e.user_id
							AND b.rp_status > 0
							AND b.rp_date >= #arguments.ReportdateStart#
							AND b.rp_date <= #arguments.ReportdateEnd#
						ORDER BY a.pt_id, b.rp_id, b.rp_date, d.st_id asc

					");
	
		var execute = qCompanysDmsReport.execute(); // вся структура и result и prefix
		var DATA = execute.getResult();

		var structCompanyDMSReport = structNew();
		structCompanyDMSReport.RETVAL = 1; // create
		structCompanyDMSReport.RETDESC = 'Отчёт создан!';
		structCompanyDMSReport.RETDATA = DATA;
		return structCompanyDMSReport;
	}

	function readCompanyDms( cdmsid ){
		qCompanyDms = new Query();
		qCompanyDms.setName("readCompanyDms");
		qCompanyDms.setTimeout("5");
		qCompanyDms.setDatasource("#variables.instance.datasource.getDSName()#");

		qCompanyDms.setSQL("SELECT * FROM companysdms WHERE cdms_id = '#arguments.cdmsid#' ");
	
		var execute = qCompanyDms.execute(); // вся структура и result и prefix
		var result = execute.getResult();
		return result; //query
	}

	function createCompanyDMS( required string cdmsName, cdmsContractNumber, cdmsDateStart, cdmsDateEnd, string cdmsDescription , numeric cdmsStatus ) {
		// дописать время создания и ip
		createCompanyDMS = new Query();
		createCompanyDMS.setDatasource("#instance.datasource.getDSName()#");
		createCompanyDMS.setName("createCompanyDMS");
		createCompanyDMS.setTimeout("5");
		createCompanyDMS.addParam(name = "cdmsName", value = "#arguments.cdmsName#", cfsqltype = "cf_sql_varchar" );
		createCompanyDMS.addParam(name = "cdmsContractNumber", value = "#arguments.cdmsContractNumber#", null=yesNoFormat(NOT len(trim(arguments.cdmsContractNumber))), cfsqltype = "cf_sql_varchar" );
		createCompanyDMS.addParam(name = "cdmsDateStart", value = "#arguments.cdmsDateStart#", null=yesNoFormat(NOT len(trim(arguments.cdmsDateStart))), cfsqltype = "cf_sql_date" );
		createCompanyDMS.addParam(name = "cdmsDateEnd", value = "#arguments.cdmsDateEnd#", null=yesNoFormat(NOT len(trim(arguments.cdmsDateEnd))), cfsqltype = "cf_sql_date" );
		createCompanyDMS.addParam(name = "cdmsDescription", value = "#arguments.cdmsDescription#", cfsqltype = "cf_sql_varchar" );
		createCompanyDMS.addParam(name = "cdmsStatus", value = "#arguments.cdmsStatus#", cfsqltype = "cf_sql_integer" );
			
		createCompanyDMS.setSQL("INSERT INTO companysdms ( cdms_name, cdms_contract_number, cdms_date_start, cdms_date_end, cdms_description, cdms_status )
			VALUES ( :cdmsName, :cdmsContractNumber, :cdmsDateStart, :cdmsDateEnd, :cdmsDescription, :cdmsStatus )
			");

		createCompanyDMS.execute(); // вся структура и result и prefix

		var structCreateCompanyDMS = structNew();
		structCreateCompanyDMS.RETVAL = 1; // create
		structCreateCompanyDMS.RETDESC = 'Компания ДМС создана!';
		return structCreateCompanyDMS;
	}

	function updateCompanyDms(required numeric cdmsID, required string cdmsName, cdmsContractNumber, cdmsDateStart, cdmsDateEnd, string cdmsDescription, numeric cdmsStatus ){

		updateCompanyDMS = new Query();
		updateCompanyDMS.setDatasource("#instance.datasource.getDSName()#");
		updateCompanyDMS.setName("updateCompanyDms");
		updateCompanyDMS.setTimeout("5");

		updateCompanyDMS.addParam(name = "cdmsID", value = "#arguments.cdmsID#", cfsqltype = "cf_sql_integer" );
		updateCompanyDMS.addParam(name = "cdmsName", value = "#arguments.cdmsName#", cfsqltype = "cf_sql_varchar" );
		updateCompanyDMS.addParam(name = "cdmsContractNumber", value = "#arguments.cdmsContractNumber#", null=yesNoFormat(NOT len(trim(arguments.cdmsContractNumber))), cfsqltype = "cf_sql_varchar" );
		updateCompanyDMS.addParam(name = "cdmsDateStart", value = "#arguments.cdmsDateStart#", null=yesNoFormat(NOT len(trim(arguments.cdmsDateStart))), cfsqltype = "cf_sql_date" );
		updateCompanyDMS.addParam(name = "cdmsDateEnd", value = "#arguments.cdmsDateEnd#", null=yesNoFormat(NOT len(trim(arguments.cdmsDateEnd))), cfsqltype = "cf_sql_date" );
		updateCompanyDMS.addParam(name = "cdmsDescription", value = "#arguments.cdmsDescription#", cfsqltype = "cf_sql_varchar" );
		updateCompanyDMS.addParam(name = "cdmsStatus", value = "#arguments.cdmsStatus#", cfsqltype = "cf_sql_integer" );

		updateCompanyDMS.setSQL("UPDATE companysdms 
				SET 
				cdms_name=:cdmsName,
				cdms_contract_number=:cdmsContractNumber,
				cdms_date_start=:cdmsDateStart,
				cdms_date_end=:cdmsDateEnd,
				cdms_description=:cdmsDescription,
				cdms_status=:cdmsStatus 
				WHERE cdms_id = :cdmsID ");

		updateCompanyDMS.execute();
		var structUpdateCompanyDMS = structNew();
		structUpdateCompanyDMS.RETVAL = 1; // create
		structUpdateCompanyDMS.RETDESC = 'Компания ДМС изменена!';
		return structUpdateCompanyDMS;

	}

}