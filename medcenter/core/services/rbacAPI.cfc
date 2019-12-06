/*
	Role Based Access Control - Управление доступом на основе ролей.
*/

component attributeName='RBACServiceAPI' output='false'{

	// Псевдо конструктор
	instance.rbacDAO = createObject('component', 'core.db.rbacDAO' ).Init();

	instance.groups = {};
	instance.roles = {};
	instance.prms = {};
	instance.obs = {};
	instance.ops = {};	


	function init(){
		setGroupList();
		setRoleList();
		setPermissionList();
		setObjectList();
		setOperationList();
		return this;
	}

	// список пользовательских групп
	function setGroupList(){
		qGroups = instance.rbacDAO.readGroupList();
		instance.groups = qGroups;
	}
	function getGroupList() { return instance.groups; }

	function getGroup( groupid, type ){
		qGroup = instance.rbacDAO.readGroups(arguments.groupid, arguments.type );
		return qGroup;
	}

	function addGroup( groupName, groupDescription, rolesID, groupStatus ){

		groupName = arguments.groupName;
		groupDescription = arguments.groupDescription;
		rolesID = arguments.rolesID;
		groupStatus = arguments.groupStatus;

		var result = structNew();
		result.RETVAL = 0;
		result.RETDESC = "";
		result.STRUCT = structNew(); // для валидации полей

		validator = request.factoryService.getService('Validator');
		                                                 //required                 //DB
		var struct_ = validator.checkInput('#groupName#',true,'isAllowSimbolRusEn',2,20, true, 'bbs_rbac_groups', 'group_name','Имя пользовательской группы');
		if ( !struct_.retval ){
			structInsert(result.struct, 'groupName','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.groupDescription#',false,'checkString',0,250);
		if ( !struct_.retval ){
			structInsert(result.struct, 'groupDescription','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.rolesID#',false,'checkString',0,250);
		if ( !struct_.retval ){
			structInsert(result.struct, 'rolesID','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.groupStatus#',false,'isNumeric',0,2);
		if ( !struct_.retval ){
			structInsert(result.struct, 'groupStatus','#struct_.retdesc#');
		}

		//--------------------------------------------------------------------

	        // если обнаружены ошибки
		if ( structIsEmpty(result.struct) ){

			structCreateGroup = instance.rbacDAO.createGroup( groupName, groupDescription, rolesID, groupStatus );

			if (structCreateGroup.RETVAL == 1){
				result.RETVAL = structCreateGroup.RETVAL;
				result.RETDESC = structCreateGroup.RETDESC;
			}else {
				result.RETVAL = structCreateGroup.RETVAL;
				result.RETDESC = structCreateGroup.RETDESC;
			}

		}
		return result;
	}

	function editeGroup( groupID, groupName, groupDescription, rolesID, groupStatus ){

	        groupID = arguments.groupID;
		groupName = arguments.groupName;
		groupDescription = arguments.groupDescription;
		rolesID = arguments.rolesID;
		groupStatus = arguments.groupStatus;

		var result = structNew();
		result.RETVAL = 0;
		result.RETDESC = "";
		result.STRUCT = structNew(); // для валидации полей

		validator = request.factoryService.getService('Validator');
		                                                 //required                 //DB
		var struct_ = validator.checkInput('#groupName#',true,'isAllowSimbolRusEn',2,20, false, 'bbs_rbac_groups', 'group_name','Имя пользовательской группы');
		if ( !struct_.retval ){
			structInsert(result.struct, 'groupName','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.groupDescription#',false,'checkString',0,250);
		if ( !struct_.retval ){
			structInsert(result.struct, 'groupDescription','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.rolesID#',false,'checkString',0,250);
		if ( !struct_.retval ){
			structInsert(result.struct, 'rolesID','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.groupStatus#',false,'isNumeric',0,2);
		if ( !struct_.retval ){
			structInsert(result.struct, 'groupStatus','#struct_.retdesc#');
		}

		//--------------------------------------------------------------------

	        // если обнаружены ошибки
		if ( structIsEmpty(result.struct) ){

			structUpdateGroup = instance.rbacDAO.updateGroup( groupID, groupName, groupDescription, rolesID, groupStatus );

			if (structUpdateGroup.RETVAL == 1){
				result.RETVAL = structUpdateGroup.RETVAL;
				result.RETDESC = structUpdateGroup.RETDESC;
			}else {
				result.RETVAL = structUpdateGroup.RETVAL;
				result.RETDESC = structUpdateGroup.RETDESC;
			}

		}
		return result;
	}

	function getRoles( rolesid, type ){
		qRoles = instance.rbacDAO.readRoles( #arguments.rolesid#, #arguments.type# );
		return qRoles;
	}

	function addRole( roleName, roleDescription, roleChild, roleParent, prmsIDs, roleStatus ){

		roleName = arguments.roleName;
		roleDescription = arguments.roleDescription;
		roleChild = arguments.roleChild;
		roleParent = arguments.roleParent;
		prmsIDs = arguments.prmsIDs;
		roleStatus = arguments.roleStatus;

		var result = structNew();
		result.RETVAL = 0;
		result.RETDESC = "";
		result.STRUCT = structNew(); // для валидации полей

		validator = request.factoryService.getService('Validator');
		                                                 //required                 //DB
		var struct_ = validator.checkInput('#roleName#',true,'isAllowSimbolRusEn',2,20, true, 'bbs_rbac_roles', 'role_name','Имя пользовательской роли');
		if ( !struct_.retval ){
			structInsert(result.struct, 'roleName','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.roleDescription#',false,'checkString',0,250);
		if ( !struct_.retval ){
			structInsert(result.struct, 'roleDescription','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.roleChild#',false,'isNumeric',0,2);
		if ( !struct_.retval ){
			structInsert(result.struct, 'roleChild','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.roleParent#',false,'isNumeric',0,2);
		if ( !struct_.retval ){
			structInsert(result.struct, 'roleParent','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.prmsIDs#',false,'checkString',0,250);
		if ( !struct_.retval ){
			structInsert(result.struct, 'prmsIDs','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.roleStatus#',false,'isNumeric',0,2);
		if ( !struct_.retval ){
			structInsert(result.struct, 'roleStatus','#struct_.retdesc#');
		}

		//--------------------------------------------------------------------

	        // если обнаружены ошибки
		if ( structIsEmpty(result.struct) ){

			structCreateRole = instance.rbacDAO.createRole( roleName, roleDescription, roleChild, roleParent, prmsIDs, roleStatus );

			if (structCreateRole.RETVAL == 1){
				result.RETVAL = structCreateRole.RETVAL;
				result.RETDESC = structCreateRole.RETDESC;
			}else {
				result.RETVAL = structCreateRole.RETVAL;
				result.RETDESC = structCreateRole.RETDESC;
			}

		}
		return result;
	}

	function editeRole( roleID, roleName, roleDescription, roleChild, roleParent, prmsIDs, roleStatus ){

	        roleID = arguments.roleID;
		roleName = arguments.roleName;
		roleDescription = arguments.roleDescription;
		roleChild = arguments.roleChild;
		roleParent = arguments.roleParent;
		prmsIDs = arguments.prmsIDs;
		roleStatus = arguments.roleStatus;

		var result = structNew();
		result.RETVAL = 0;
		result.RETDESC = "";
		result.STRUCT = structNew(); // для валидации полей

		validator = request.factoryService.getService('Validator');
		                                                 //required                 //DB
		var struct_ = validator.checkInput('#roleName#',true,'isAllowSimbolRusEn',2,20, false, 'bbs_rbac_roles', 'role_name','Имя пользовательской группы');
		if ( !struct_.retval ){
			structInsert(result.struct, 'roleName','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.roleDescription#',false,'checkString',0,250);
		if ( !struct_.retval ){
			structInsert(result.struct, 'roleDescription','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.roleChild#',false,'isNumeric',0,2);
		if ( !struct_.retval ){
			structInsert(result.struct, 'roleChild','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.roleParent#',false,'isNumeric',0,2);
		if ( !struct_.retval ){
			structInsert(result.struct, 'roleParent','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.prmsIDs#',false,'checkString',0,250);
		if ( !struct_.retval ){
			structInsert(result.struct, 'prmsIDs','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.roleStatus#',false,'isNumeric',0,2);
		if ( !struct_.retval ){
			structInsert(result.struct, 'roleStatus','#struct_.retdesc#');
		}

		//--------------------------------------------------------------------

	        // если обнаружены ошибки
		if ( structIsEmpty(result.struct) ){
			structUpdateRole = instance.rbacDAO.updateRole( roleID, roleName, roleDescription, roleChild, roleParent, prmsIDs, roleStatus );
			if (structUpdateRole.RETVAL == 1){
				result.RETVAL = structUpdateRole.RETVAL;
				result.RETDESC = structUpdateRole.RETDESC;
			}else {
				result.RETVAL = structUpdateRole.RETVAL;
				result.RETDESC = structUpdateRole.RETDESC;
			}
		}
		return result;
	}

	function getPermissions( prmsid, type ){
		qPermissions = instance.rbacDAO.readPermissions( #arguments.prmsid#, #arguments.type# );
		return qPermissions;
	}

	function addPermission( prmsName, prmsDescription, obsID, opsID, prmsStatus ){

		prmsName = arguments.prmsName;
		prmsDescription = arguments.prmsDescription;
		obsID = arguments.obsID;
		opsID = arguments.opsID;
		prmsStatus = arguments.prmsStatus;

		var result = structNew();
		result.RETVAL = 0;
		result.RETDESC = "";
		result.STRUCT = structNew(); // для валидации полей

		validator = request.factoryService.getService('Validator');
		                                                 //required                 //DB
		var struct_ = validator.checkInput('#prmsName#',true,'isAllowSimbolRusEn',2,50, true, 'bbs_rbac_prms', 'prms_name','Имя разрешения');
		if ( !struct_.retval ){
			structInsert(result.struct, 'prmsName','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.prmsDescription#',false,'checkString',0,250);
		if ( !struct_.retval ){
			structInsert(result.struct, 'prmsDescription','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.obsID#',true,'isNumeric',0,2);
		if ( !struct_.retval ){
			structInsert(result.struct, 'obsID','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.opsID#',true,'isNumeric',0,3);
		if ( !struct_.retval ){
			structInsert(result.struct, 'opsID','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.prmsStatus#',false,'isNumeric',0,3);
		if ( !struct_.retval ){
			structInsert(result.struct, 'prmsStatus','#struct_.retdesc#');
		}
		//--------------------------------------------------------------------
	        // если обнаружены ошибки
		if ( structIsEmpty(result.struct) ){
			structCreateRole = instance.rbacDAO.createPermission( prmsName, prmsDescription, obsID, opsID, prmsStatus );
			if (structCreateRole.RETVAL == 1){
				result.RETVAL = structCreateRole.RETVAL;
				result.RETDESC = structCreateRole.RETDESC;
			}else {
				result.RETVAL = structCreateRole.RETVAL;
				result.RETDESC = structCreateRole.RETDESC;
			}
		}
		return result;
	}

	function editePermission( prmsID, prmsName, prmsDescription, obsID, opsID, prmsStatus ){

	        prmsID = arguments.prmsID;
		prmsName = arguments.prmsName;
		prmsDescription = arguments.prmsDescription;
		obsID = arguments.obsID;
		opsID = arguments.opsID;
		prmsStatus = arguments.prmsStatus;

		var result = structNew();
		result.RETVAL = 0;
		result.RETDESC = "";
		result.STRUCT = structNew(); // для валидации полей

		validator = request.factoryService.getService('Validator');
		                                                 //required                 //DB
		var struct_ = validator.checkInput('#prmsName#',true,'isAllowSimbolRusEn',2,50, false, 'bbs_rbac_prms', 'prms_name','Имя разрешения');
		if ( !struct_.retval ){
			structInsert(result.struct, 'prmsName','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.prmsDescription#',false,'checkString',0,250);
		if ( !struct_.retval ){
			structInsert(result.struct, 'prmsDescription','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.obsID#',true,'isNumeric',0,3);
		if ( !struct_.retval ){
			structInsert(result.struct, 'obsID','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.opsID#',true,'isNumeric',0,3);
		if ( !struct_.retval ){
			structInsert(result.struct, 'opsID','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.prmsStatus#',false,'isNumeric',0,2);
		if ( !struct_.retval ){
			structInsert(result.struct, 'prmsStatus','#struct_.retdesc#');
		}

		//--------------------------------------------------------------------
	        // если обнаружены ошибки
		if ( structIsEmpty(result.struct) ){
			structUpdatePermission = instance.rbacDAO.updatePermission( prmsID, prmsName, prmsDescription, obsID, opsID, prmsStatus );
			if (structUpdatePermission.RETVAL == 1){
				result.RETVAL = structUpdatePermission.RETVAL;
				result.RETDESC = structUpdatePermission.RETDESC;
			}else {
				result.RETVAL = structUpdatePermission.RETVAL;
				result.RETDESC = structUpdatePermission.RETDESC;
			}
		}
		return result;
	}

	function getObject( obsid ){
		qObject = instance.rbacDAO.readObject( #arguments.obsid# );
		return qObject;
	}

	function addObject( obsName, obsType, obsDescription, obsStatus ){

		obsName = arguments.obsName;
		obsType = arguments.obsType;
		obsDescription = arguments.obsDescription;
		obsStatus = arguments.obsStatus;

		var result = structNew();
		result.RETVAL = 0;
		result.RETDESC = "";
		result.STRUCT = structNew(); // для валидации полей

		validator = request.factoryService.getService('Validator');
		                                                 //required                 //DB
		var struct_ = validator.checkInput('#obsName#',true,'isAllowSimbolRusEn',2,50, true, 'bbs_rbac_obs', 'obs_name','Имя объекта');
		if ( !struct_.retval ){
			structInsert(result.struct, 'obsName','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.obsType#',true,'checkString',2,50);
		if ( !struct_.retval ){
			structInsert(result.struct, 'obsType','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.obsDescription#',false,'checkString',0,250);
		if ( !struct_.retval ){
			structInsert(result.struct, 'obsDescription','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.obsStatus#',false,'isNumeric',0,2);
		if ( !struct_.retval ){
			structInsert(result.struct, 'obsStatus','#struct_.retdesc#');
		}

		//--------------------------------------------------------------------
	        // если обнаружены ошибки
		if ( structIsEmpty(result.struct) ){

			structCreateObject = instance.rbacDAO.createObject( obsName, obsType, obsDescription, obsStatus );

			if (structCreateObject.RETVAL == 1){
				result.RETVAL = structCreateObject.RETVAL;
				result.RETDESC = structCreateObject.RETDESC;
			}else {
				result.RETVAL = structCreateObject.RETVAL;
				result.RETDESC = structCreateObject.RETDESC;
			}

		}
		return result;
	}

	function editeObject( obsID, obsName, obsType, obsDescription, obsStatus ){

	        obsID = arguments.obsID;
		obsName = arguments.obsName;
		obsType = arguments.obsType;
		obsDescription = arguments.obsDescription;
		obsStatus = arguments.obsStatus;

		var result = structNew();
		result.RETVAL = 0;
		result.RETDESC = "";
		result.STRUCT = structNew(); // для валидации полей

		validator = request.factoryService.getService('Validator');
		                                                 //required                 //DB
		var struct_ = validator.checkInput('#obsName#',true,'isAllowSimbolRusEn',2,50, false, 'bbs_rbac_obs', 'obs_name','Имя объекта');
		if ( !struct_.retval ){
			structInsert(result.struct, 'obsName','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.obsType#',true,'checkString',2,50);
		if ( !struct_.retval ){
			structInsert(result.struct, 'obsType','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.obsDescription#',false,'checkString',0,250);
		if ( !struct_.retval ){
			structInsert(result.struct, 'obsDescription','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.obsStatus#',false,'isNumeric',0,2);
		if ( !struct_.retval ){
			structInsert(result.struct, 'obsStatus','#struct_.retdesc#');
		}

		//--------------------------------------------------------------------
	        // если обнаружены ошибки
		if ( structIsEmpty(result.struct) ){
			structUpdateObject = instance.rbacDAO.updateObject( obsID, obsName, obsType, obsDescription, obsStatus );
			if (structUpdateObject.RETVAL == 1){
				result.RETVAL = structUpdateObject.RETVAL;
				result.RETDESC = structUpdateObject.RETDESC;
			}else {
				result.RETVAL = structUpdateObject.RETVAL;
				result.RETDESC = structUpdateObject.RETDESC;
			}
		}
		return result;
	}

	function getOperation( opsid ){
		qOperation = instance.rbacDAO.readOperation( #arguments.opsid# );
		return qOperation;
	}

	function addOperation( opsName, opsType, opsDescription, opsStatus ){

		opsName = arguments.opsName;
		opsType = arguments.opsType;
		opsDescription = arguments.opsDescription;
		opsStatus = arguments.opsStatus;

		var result = structNew();
		result.RETVAL = 0;
		result.RETDESC = "";
		result.STRUCT = structNew(); // для валидации полей

		validator = request.factoryService.getService('Validator');
		                                                 //required                 //DB
		var struct_ = validator.checkInput('#opsName#',true,'isAllowSimbolRusEn',2,50, true, 'bbs_rbac_ops', 'ops_name','Имя операции');
		if ( !struct_.retval ){
			structInsert(result.struct, 'opsName','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.opsType#',true,'checkString',2,50);
		if ( !struct_.retval ){
			structInsert(result.struct, 'opsType','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.opsDescription#',false,'checkString',0,250);
		if ( !struct_.retval ){
			structInsert(result.struct, 'opsDescription','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.opsStatus#',false,'isNumeric',0,2);
		if ( !struct_.retval ){
			structInsert(result.struct, 'opsStatus','#struct_.retdesc#');
		}

		//--------------------------------------------------------------------
	        // если обнаружены ошибки
		if ( structIsEmpty(result.struct) ){

			structCreateOperation = instance.rbacDAO.createOperation( opsName, opsType, opsDescription, opsStatus );

			if (structCreateOperation.RETVAL == 1){
				result.RETVAL = structCreateOperation.RETVAL;
				result.RETDESC = structCreateOperation.RETDESC;
			}else {
				result.RETVAL = structCreateOperation.RETVAL;
				result.RETDESC = structCreateOperation.RETDESC;
			}

		}
		return result;
	}

	function editeOperation( opsID, opsName, opsType, opsDescription, opsStatus ){

	        opsID = arguments.opsID;
		opsName = arguments.opsName;
		opsType = arguments.opsType;
		opsDescription = arguments.opsDescription;
		opsStatus = arguments.opsStatus;

		var result = structNew();
		result.RETVAL = 0;
		result.RETDESC = "";
		result.STRUCT = structNew(); // для валидации полей

		validator = request.factoryService.getService('Validator');
		                                                 //required                 //DB
		var struct_ = validator.checkInput('#opsName#',true,'isAllowSimbolRusEn',2,50, false, 'bbs_rbac_ops', 'ops_name','Имя операции');
		if ( !struct_.retval ){
			structInsert(result.struct, 'opsName','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.opsType#',true,'checkString',2,50);
		if ( !struct_.retval ){
			structInsert(result.struct, 'opsType','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.opsDescription#',false,'checkString',0,250);
		if ( !struct_.retval ){
			structInsert(result.struct, 'opsDescription','#struct_.retdesc#');
		}

		var struct_ = validator.checkInput('#arguments.opsStatus#',false,'isNumeric',0,2);
		if ( !struct_.retval ){
			structInsert(result.struct, 'opsStatus','#struct_.retdesc#');
		}

		//--------------------------------------------------------------------
	        // если обнаружены ошибки
		if ( structIsEmpty(result.struct) ){
			structUpdateOperation = instance.rbacDAO.updateOperation( opsID, opsName, opsType, opsDescription, opsStatus );
			if (structUpdateOperation.RETVAL == 1){
				result.RETVAL = structUpdateOperation.RETVAL;
				result.RETDESC = structUpdateOperation.RETDESC;
			}else {
				result.RETVAL = structUpdateOperation.RETVAL;
				result.RETDESC = structUpdateOperation.RETDESC;
			}
		}
		return result;
	}

	function setRoleList(){
		qRoles = instance.rbacDAO.readRoleList();
		instance.roles = qRoles;
	}
	function getRoleList(){ return instance.roles; }

	function setPermissionList(){
		qPermissions = instance.rbacDAO.readPermissionList();
		instance.prms = qPermissions;
	}
	function getPermissionList(){ return instance.prms; }

	function setObjectList(){
		qObjects = instance.rbacDAO.readObjectList();
		instance.obs = qObjects;
	}
	function getObjectList(){ return instance.obs; }

	function setOperationList(){
		qOperations = instance.rbacDAO.readOperationList();
		instance.ops = qOperations;
	}
	function getOperationList(){ return instance.ops; }


	function getMemento(){
		return instance;
	}
}