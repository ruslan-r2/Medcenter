component displayName='rbacDAO'{

	// Псевдо конструктор
	instance = {datasource = ''} ; // объект
	instance.datasource = createObject('component', 'core.db.Datasource').init();


	function Init (){
		return this;
	}

	function readGroupList(){
		qGroupList = new Query();
		qGroupList.setName("readGroupList");
		qGroupList.setTimeout("5");
		qGroupList.setDatasource("#variables.instance.datasource.getDSName()#");

		qGroupList.setSQL("SELECT * FROM bbs_rbac_groups");
	
		var execute = qGroupList.execute(); // вся структура и result и prefix
		var result = execute.getResult();
		return result; //query
	}

	function createGroup( required string groupName, required string groupDescription , string rolesID, numeric groupStatus) {
		// дописать время создания и ip
		createGroup = new Query();
		createGroup.setDatasource("#instance.datasource.getDSName()#");
		createGroup.setName("createGroup");
		createGroup.setTimeout("5");
		createGroup.addParam(name = "groupName", value = "#arguments.groupName#", cfsqltype = "cf_sql_varchar" );
		createGroup.addParam(name = "groupDescription", value = "#arguments.groupDescription#", cfsqltype = "cf_sql_varchar" );
		createGroup.addParam(name = "rolesID", value = "#arguments.rolesID#", cfsqltype = "cf_sql_varchar" );
		createGroup.addParam(name = "groupStatus", value = "#arguments.groupStatus#", cfsqltype = "cf_sql_integer" );
			
		createGroup.setSQL("INSERT INTO bbs_rbac_groups ( group_name, group_description, roles_id, group_status )
			VALUES ( :groupName, :groupDescription, :rolesID, :groupStatus )
			");

		createGroup.execute(); // вся структура и result и prefix

		var structCreateGroup = structNew();
		structCreateGroup.RETVAL = 1; // create
		structCreateGroup.RETDESC = 'Пользовательская группа создана!';
		return structCreateGroup;
	}

	function updateGroup(required groupID, required string groupName, required string groupDescription , string rolesID, numeric groupStatus){

		updateGroup = new Query();
		updateGroup.setDatasource("#instance.datasource.getDSName()#");
		updateGroup.setName("updateGroup");
		updateGroup.setTimeout("5");

		updateGroup.addParam(	name = "groupID", value = "#arguments.groupID#", cfsqltype = "cf_sql_integer" );
		updateGroup.addParam(	name = "groupName", value = "#arguments.groupName#", cfsqltype = "cf_sql_varchar" );
		updateGroup.addParam(	name = "groupDescription", value = "#arguments.groupDescription#", cfsqltype = "cf_sql_varchar" );
		updateGroup.addParam(	name = "rolesID", value = "#arguments.rolesID#", cfsqltype = "cf_sql_varchar" );
		updateGroup.addParam(	name = "groupStatus", value = "#arguments.groupStatus#", cfsqltype = "cf_sql_integer" );

		updateGroup.setSQL("UPDATE bbs_rbac_groups 
				SET 
				group_name=:groupName,
				group_description=:groupDescription,
				roles_id=:rolesID,
				group_status=:groupStatus 
				WHERE group_id = :groupID");

		updateGroup.execute();
		var structUpdateGroup = structNew();
		structUpdateGroup.RETVAL = 1; // create
		structUpdateGroup.RETDESC = 'Пользовательская группа изменена!';
		return structUpdateGroup;

	}

	function createRole( required string roleName, required string roleDescription , roleChild, roleParent, string prmsIDs, numeric roleStatus) {
		// дописать время создания и ip
		createRole = new Query();
		createRole.setDatasource("#instance.datasource.getDSName()#");
		createRole.setName("createRole");
		createRole.setTimeout("5");
		createRole.addParam(name = "roleName", value = "#arguments.roleName#", cfsqltype = "cf_sql_varchar" );
		createRole.addParam(name = "roleDescription", value = "#arguments.roleDescription#", cfsqltype = "cf_sql_varchar" );
		createRole.addParam(name = "roleChild", value = "#arguments.roleChild#", null=yesNoFormat(NOT len(trim(arguments.roleChild))), cfsqltype = "cf_sql_integer" );
		createRole.addParam(name = "roleParent", value = "#arguments.roleParent#", null=yesNoFormat(NOT len(trim(arguments.roleParent))), cfsqltype = "cf_sql_integer" );
		createRole.addParam(name = "prmsIDs", value = "#arguments.prmsIDs#", cfsqltype = "cf_sql_varchar" );
		createRole.addParam(name = "roleStatus", value = "#arguments.roleStatus#", cfsqltype = "cf_sql_integer" );
			
		createRole.setSQL("INSERT INTO bbs_rbac_roles ( role_name, role_description, role_child, role_parent, prms_ids, role_status )
			VALUES ( :roleName, :roleDescription, :roleChild, :roleParent, :prmsIDs, :roleStatus )
			");

		createRole.execute(); // вся структура и result и prefix

		var structCreateRole = structNew();
		structCreateRole.RETVAL = 1; // create
		structCreateRole.RETDESC = 'Пользовательская роль создана!';
		return structCreateRole;
	}

	function updateRole(required roleID, required string roleName, required string roleDescription, roleChild, roleParent, string prmsIDs, numeric roleStatus){

		updateRole = new Query();
		updateRole.setDatasource("#instance.datasource.getDSName()#");
		updateRole.setName("updateRole");
		updateRole.setTimeout("5");

		updateRole.addParam(	name = "roleID", value = "#arguments.roleID#", cfsqltype = "cf_sql_integer" );
		updateRole.addParam(	name = "roleName", value = "#arguments.roleName#", cfsqltype = "cf_sql_varchar" );
		updateRole.addParam(	name = "roleDescription", value = "#arguments.roleDescription#", cfsqltype = "cf_sql_varchar" );
		updateRole.addParam(	name = "roleChild", value = "#arguments.roleChild#", null=yesNoFormat(NOT len(trim(arguments.roleChild))), cfsqltype = "cf_sql_integer" );
		updateRole.addParam(	name = "roleParent", value = "#arguments.roleParent#", null=yesNoFormat(NOT len(trim(arguments.roleParent))), cfsqltype = "cf_sql_integer" );
		updateRole.addParam(	name = "prmsIDs", value = "#arguments.prmsIDs#", cfsqltype = "cf_sql_varchar" );
		updateRole.addParam(	name = "roleStatus", value = "#arguments.roleStatus#", cfsqltype = "cf_sql_integer" );

		updateRole.setSQL("UPDATE bbs_rbac_roles 
				SET 
				role_name=:roleName,
				role_description=:roleDescription,
				role_child=:roleChild,
				role_parent=:roleParent,
				prms_ids=:prmsIDs,
				role_status=:roleStatus 
				WHERE role_id = :roleID");

		updateRole.execute();
		var structUpdateRole = structNew();
		structUpdateRole.RETVAL = 1; // create
		structUpdateRole.RETDESC = 'Пользовательская роль изменена!';
		return structUpdateRole;

	}

	function createPermission( required string prmsName, required string prmsDescription , obsID, opsID, numeric prmsStatus) {
		// дописать время создания и ip
		createPermission = new Query();
		createPermission.setDatasource("#instance.datasource.getDSName()#");
		createPermission.setName("createPermission");
		createPermission.setTimeout("5");
		createPermission.addParam(name = "prmsName", value = "#arguments.prmsName#", cfsqltype = "cf_sql_varchar" );
		createPermission.addParam(name = "prmsDescription", value = "#arguments.prmsDescription#", cfsqltype = "cf_sql_varchar" );
		createPermission.addParam(name = "obsID", value = "#arguments.obsID#", cfsqltype = "cf_sql_integer" );
		createPermission.addParam(name = "opsID", value = "#arguments.opsID#", cfsqltype = "cf_sql_integer" );
		createPermission.addParam(name = "prmsStatus", value = "#arguments.prmsStatus#", cfsqltype = "cf_sql_integer" );
			
		createPermission.setSQL("INSERT INTO bbs_rbac_prms ( prms_name, prms_description, obs_id, ops_id, prms_status )
			VALUES ( :prmsName, :prmsDescription, :obsID, :opsID, :prmsStatus )
			");

		createPermission.execute(); // вся структура и result и prefix

		var structCreatePermission = structNew();
		structCreatePermission.RETVAL = 1; // create
		structCreatePermission.RETDESC = 'Пользовательская роль создана!';
		return structCreatePermission;
	}

	function updatePermission(required prmsID, required string prmsName, required string prmsDescription, obsID, opsID, numeric prmsStatus){

		updatePermission = new Query();
		updatePermission.setDatasource("#instance.datasource.getDSName()#");
		updatePermission.setName("updatePermission");
		updatePermission.setTimeout("5");

		updatePermission.addParam(	name = "prmsID", value = "#arguments.prmsID#", cfsqltype = "cf_sql_integer" );
		updatePermission.addParam(	name = "prmsName", value = "#arguments.prmsName#", cfsqltype = "cf_sql_varchar" );
		updatePermission.addParam(	name = "prmsDescription", value = "#arguments.prmsDescription#", cfsqltype = "cf_sql_varchar" );
		updatePermission.addParam(	name = "obsID", value = "#arguments.obsID#", cfsqltype = "cf_sql_integer" );
		updatePermission.addParam(	name = "opsID", value = "#arguments.opsID#", cfsqltype = "cf_sql_integer" );
		updatePermission.addParam(	name = "prmsStatus", value = "#arguments.prmsStatus#", cfsqltype = "cf_sql_integer" );

		updatePermission.setSQL("UPDATE bbs_rbac_prms 
				SET 
				prms_name=:prmsName,
				prms_description=:prmsDescription,
				obs_id=:obsID,
				ops_id=:opsID,
				prms_status=:prmsStatus 
				WHERE prms_id = :prmsID");

		updatePermission.execute();
		var structUpdatePermission = structNew();
		structUpdatePermission.RETVAL = 1; // create
		structUpdatePermission.RETDESC = 'Пользовательская роль изменена!';
		return structUpdatePermission;

	}

	function readRoleList(){
		qRoleList = new Query();
		qRoleList.setName("readRoleList");
		qRoleList.setTimeout("5");
		qRoleList.setDatasource("#variables.instance.datasource.getDSName()#");

		qRoleList.setSQL("SELECT * FROM bbs_rbac_roles");
	
		var execute = qRoleList.execute(); // вся структура и result и prefix
		var result = execute.getResult();
		return result; //query
	}

	function readPermissionList(){
		qPrmsList = new Query();
		qPrmsList.setName("readPermissionList");
		qPrmsList.setTimeout("5");
		qPrmsList.setDatasource("#variables.instance.datasource.getDSName()#");

		qPrmsList.setSQL("SELECT * FROM bbs_rbac_prms");
	
		var execute = qPrmsList.execute(); // вся структура и result и prefix
		var result = execute.getResult();
		return result; //query
	}

	function readObjectList(){
		qObjList = new Query();
		qObjList.setName("readObjectList");
		qObjList.setTimeout("5");
		qObjList.setDatasource("#variables.instance.datasource.getDSName()#");

		qObjList.setSQL("SELECT * FROM bbs_rbac_obs");
	
		var execute = qObjList.execute(); // вся структура и result и prefix
		var result = execute.getResult();
		return result; //query
	}

	function readOperationList(){
		qOpList = new Query();
		qOpList.setName("readOperationList");
		qOpList.setTimeout("5");
		qOpList.setDatasource("#variables.instance.datasource.getDSName()#");

		qOpList.setSQL("SELECT * FROM bbs_rbac_ops");
	
		var execute = qOpList.execute(); // вся структура и result и prefix
		var result = execute.getResult();
		return result; //query
	}


	function readGroups( required groupid , type = 'struct'){ // нужно передать id группы

		qReadGroups=new Query();
		if (arguments.type == 'struct' ){
			qReadGroups.SetName('sReadGroups');
		}else if(arguments.type == 'query'){
			qReadGroups.SetName('qReadGroups');
		}
		qReadGroups.SetDatasource('#instance.datasource.getDSName()#');
		qReadGroups.SetSql("
				SELECT group_id, group_name, group_description, roles_id, group_status
				FROM bbs_rbac_groups
				WHERE group_id = '#arguments.groupid#'
				");

		var execute=qReadGroups.Execute();
		var result=execute.GetResult();

		if (arguments.type == 'struct'){
			var structGroups = {};
			if (result.RecordCount gt 0) {
				for (x=1; x<=result.RecordCount; x=x+1) {
				setVariable('structGroups.#result.group_name[x]#',result.roles_id[x]);
				}
			}
			return structGroups; //

		}else if ( arguments.type == 'query'){
			return result;
		}
	}

	function readRoles( required rolesid, type = 'struct' ) {

		qReadRoles=new Query();
		if (arguments.type == 'struct' ){
			qReadRoles.SetName('sReadRoles');
		}else if(arguments.type == 'query'){
			qReadRoles.SetName('qReadRoles');
		}
		qReadRoles.SetDatasource('#instance.datasource.getDSName()#');
		qReadRoles.SetSql("

				with x (role_id,role_name,role_description,role_child,role_parent,prms_ids,role_status)
				as (
				select role_id,role_name,role_description,role_child,role_parent,prms_ids,role_status 
				from bbs_rbac_roles
				where role_id in (#arguments.rolesid#) 
				union all
				select e.role_id,e.role_name,e.role_description,e.role_child,e.role_parent,e.prms_ids,e.role_status 
				from bbs_rbac_roles e, x
				where x.role_child = e.role_id 
				)
				select role_id,role_name,role_description,role_child,role_parent,prms_ids,role_status 
				from x

				");

		var execute=qReadRoles.Execute();
		var result=execute.GetResult();

		if (arguments.type == 'struct'){
		var structRoles = {};
			if (result.RecordCount gt 0) {
				for (x=1; x<=result.RecordCount; x=x+1) {
				setVariable('structRoles.#result.role_name[x]#',result.prms_ids[x]);
				}
			}
	
			return structRoles; //
		}else if ( arguments.type == 'query'){
			return result;
		}
	}

	function readPermissions( required prmsid , type = 'struct' ){
		qReadPrms=new Query();
		if (arguments.type == 'struct' ){
			qReadPrms.SetName('sReadPrms');
		}else if(arguments.type == 'query'){
			qReadPrms.SetName('qReadPrms');
		}
		qReadPrms.SetDatasource('#instance.datasource.getDSName()#');
		qReadPrms.SetSql(" 
					SELECT a.prms_id, a.prms_name, a.prms_description, a.obs_id, a.ops_id, a.prms_status, b.obs_name, c.ops_name
					FROM bbs_rbac_prms a, bbs_rbac_obs b, bbs_rbac_ops c
					WHERE prms_id in (#arguments.prmsid#) 
						AND a.obs_id = b.obs_id
						AND a.ops_id = c.ops_id
				");

		var execute=qReadPrms.Execute();
		var result=execute.GetResult();
		//writeDump(result);

		if (arguments.type == 'struct'){
			var temp = {};
			temp.obs = '';
			temp.ops = '';
			var structPrms = {};
				if (result.RecordCount gt 0) {
					for (x=1; x<=result.RecordCount; x=x+1) {
					setVariable('structPrms.#result.prms_name[x]#', {obs='#result.obs_name[x]#',ops='#result.ops_name[x]#'});
					}
				}
			return structPrms;
		}else if (arguments.type == 'query'){
			return result;
		}
	}

	function createObject( required string obsName, required string obsType, string obsDescription , numeric obsStatus) {
		// дописать время создания и ip
		createObject = new Query();
		createObject.setDatasource("#instance.datasource.getDSName()#");
		createObject.setName("createObject");
		createObject.setTimeout("5");
		createObject.addParam(name = "obsName", value = "#arguments.obsName#", cfsqltype = "cf_sql_varchar" );
		createObject.addParam(name = "obsType", value = "#arguments.obsType#", cfsqltype = "cf_sql_varchar" );
		createObject.addParam(name = "obsDescription", value = "#arguments.obsDescription#", cfsqltype = "cf_sql_varchar" );
		createObject.addParam(name = "obsStatus", value = "#arguments.obsStatus#", cfsqltype = "cf_sql_integer" );
			
		createObject.setSQL("INSERT INTO bbs_rbac_obs ( obs_name, obs_type, obs_description, obs_status )
			VALUES ( :obsName, :obsType, :obsDescription, :obsStatus )
			");

		createObject.execute(); // вся структура и result и prefix

		var structCreateObject = structNew();
		structCreateObject.RETVAL = 1; // create
		structCreateObject.RETDESC = 'Объект создан!';
		return structCreateObject;
	}

	function updateObject(required obsID, required string obsName, required string obsType, required string obsDescription, numeric obsStatus){

		updateObject = new Query();
		updateObject.setDatasource("#instance.datasource.getDSName()#");
		updateObject.setName("updateObject");
		updateObject.setTimeout("5");

		updateObject.addParam(	name = "obsID", value = "#arguments.obsID#", cfsqltype = "cf_sql_integer" );
		updateObject.addParam(	name = "obsName", value = "#arguments.obsName#", cfsqltype = "cf_sql_varchar" );
		updateObject.addParam(	name = "obsType", value = "#arguments.obsType#", cfsqltype = "cf_sql_varchar" );
		updateObject.addParam(	name = "obsDescription", value = "#arguments.obsDescription#", cfsqltype = "cf_sql_varchar" );
		updateObject.addParam(	name = "obsStatus", value = "#arguments.obsStatus#", cfsqltype = "cf_sql_integer" );

		updateObject.setSQL("UPDATE bbs_rbac_obs 
				SET 
				obs_name=:obsName,
				obs_type=:obsType,
				obs_description=:obsDescription,
				obs_status=:obsStatus 
				WHERE obs_id = :obsID");

		updateObject.execute();
		var structUpdateObject = structNew();
		structUpdateObject.RETVAL = 1; // create
		structUpdateObject.RETDESC = 'Объект изменён!';
		return structUpdateObject;

	}

	function readObject( required obsid){ // нужно передать id группы

		qReadObject=new Query();
		qReadObject.SetName('qReadObject');
		qReadObject.SetDatasource('#instance.datasource.getDSName()#');
		qReadObject.SetSql("
				SELECT obs_id, obs_name, obs_type, obs_description, obs_status
				FROM bbs_rbac_obs
				WHERE obs_id = '#arguments.obsid#'
				");

		var execute=qReadObject.Execute();
		var result=execute.GetResult();

		return result;
	}

	function createOperation( required string opsName, required string opsType, string opsDescription , numeric opsStatus) {
		// дописать время создания и ip
		createOperation = new Query();
		createOperation.setDatasource("#instance.datasource.getDSName()#");
		createOperation.setName("createOperation");
		createOperation.setTimeout("5");
		createOperation.addParam(name = "opsName", value = "#arguments.opsName#", cfsqltype = "cf_sql_varchar" );
		createOperation.addParam(name = "opsType", value = "#arguments.opsType#", cfsqltype = "cf_sql_varchar" );
		createOperation.addParam(name = "opsDescription", value = "#arguments.opsDescription#", cfsqltype = "cf_sql_varchar" );
		createOperation.addParam(name = "opsStatus", value = "#arguments.opsStatus#", cfsqltype = "cf_sql_integer" );
			
		createOperation.setSQL("INSERT INTO bbs_rbac_ops ( ops_name, ops_type, ops_description, ops_status )
			VALUES ( :opsName, :opsType, :opsDescription, :opsStatus )
			");

		createOperation.execute(); // вся структура и result и prefix

		var structCreateOperation = structNew();
		structCreateOperation.RETVAL = 1; // create
		structCreateOperation.RETDESC = 'Операция создана!';
		return structCreateOperation;
	}

	function updateOperation(required opsID, required string opsName, required string opsType, required string opsDescription, numeric opsStatus){

		updateOperation = new Query();
		updateOperation.setDatasource("#instance.datasource.getDSName()#");
		updateOperation.setName("updateOperation");
		updateOperation.setTimeout("5");

		updateOperation.addParam(	name = "opsID", value = "#arguments.opsID#", cfsqltype = "cf_sql_integer" );
		updateOperation.addParam(	name = "opsName", value = "#arguments.opsName#", cfsqltype = "cf_sql_varchar" );
		updateOperation.addParam(	name = "opsType", value = "#arguments.opsType#", cfsqltype = "cf_sql_varchar" );
		updateOperation.addParam(	name = "opsDescription", value = "#arguments.opsDescription#", cfsqltype = "cf_sql_varchar" );
		updateOperation.addParam(	name = "opsStatus", value = "#arguments.opsStatus#", cfsqltype = "cf_sql_integer" );

		updateOperation.setSQL("UPDATE bbs_rbac_ops 
				SET 
				ops_name=:opsName,
				ops_type=:opsType,
				ops_description=:opsDescription,
				ops_status=:opsStatus 
				WHERE ops_id = :opsID");

		updateOperation.execute();
		var structUpdateOperation = structNew();
		structUpdateOperation.RETVAL = 1; // create
		structUpdateOperation.RETDESC = 'Операция изменена!';
		return structUpdateOperation;

	}

	function readOperation( required opsid){ // нужно передать id группы

		qReadOperation=new Query();
		qReadOperation.SetName('qReadOperation');
		qReadOperation.SetDatasource('#instance.datasource.getDSName()#');
		qReadOperation.SetSql("
				SELECT ops_id, ops_name, ops_type, ops_description, ops_status
				FROM bbs_rbac_ops
				WHERE ops_id = '#arguments.opsid#'
				");

		var execute=qReadOperation.Execute();
		var result=execute.GetResult();

		return result;
	}
}