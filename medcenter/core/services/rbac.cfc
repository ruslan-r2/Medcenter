/*
	Role Based Access Control - ���������� �������� �� ������ �����.
*/
component attributeName='RBACService' output='false'{

	// ������ �����������
	instance.rbacDAO = createObject('component', 'core.db.rbacDAO' ).Init();

	lock scope="session" type="exclusive" timeout="5" {
		instance.user = session.sessionStorage.getObject('user'); // ��������� ������
	}

	instance.groups = {};
	instance.roles = {};
	instance.prms = {};
	// ���� ������������� ���� �������� ��� ��������
	//instance.obs = {};
	//instance.ops = {};	


	function init(){
		//instance.user.setUserGroups('2');
		setGroups();
		setRoles();
		setPermissions();
		return this;
	}

	// ����������� ������ ������������. ���������� ������ id ����
	function AssignedGroups(){
		return instance.user.getUserGroups();
	}

	function setGroups(){
		structGroups = instance.rbacDAO.readGroups( AssignedGroups() );
		structAppend(instance.groups,structGroups);
	}
	function getRolesId(){
		groupName = structKeyList(instance.groups); // ����� ������� ������, �� ���� ���������� ������ �� ������ ��������
		return instance.groups[groupName];
	}

	function setRoles(){
		structRoles = instance.rbacDAO.readRoles( getRolesId() );
		//structRoles = {};
		structAppend(instance.roles,structRoles);
	}

	function getRoles(){
		return instance.roles;
	}

	function getPermissionsId(){

		listRolesName = structKeyList(instance.roles);

		listPermissionsId = '';

		for (x=1; x<=listLen(listRolesName, ','); x=x+1) {
			var tempListPermissionsId = instance.roles[listGetAt(listRolesName,x,',')];
			for (z=1; z<=listLen(tempListPermissionsId, ','); z=z+1){
				prms = '#listGetAt( tempListPermissionsId , z, ',')#';
				listPermissionsId = listAppend(listPermissionsId, prms, ',');
			}
		}
		return listPermissionsId;
	}

	function setPermissions(){
		structPermissions = instance.rbacDAO.readPermissions( getPermissionsId() );
		structAppend(instance.prms,structPermissions);
	}
	function getPermissions(){
		return instance.prms;
	}


	// ���� �� ����� ����������� ����� ��������� ����. ���������� true\false
	function findAssignedRoles( string roles ){
		var structRoles =  getRoles();
		return structKeyExists(structRoles,arguments.roles);
	}

	function CheckAccess(object,operation) {
		var structPrms = getPermissions();
		var listPrms = structKeyList(structPrms);
		var result = false;
		for (x=1; x<=listLen(listPrms,','); x=x+1) {
			var prm = structFind( structPrms, listGetAt( listPrms , x, ',') );
			if ( prm.obs == arguments.object ){
				if ( prm.ops == arguments.operation ){
					result = true;
				}
			}
		}
		return result;
	}

	function getMemento(){
		return instance;
	}

	function getUserId(){ return instance.user.getUserId(); }

/*
	-CreateSession ( user:NAME; ars:2 names ; session:NAME )
	-DeleteSession ( user,session:NAME )
	-AddActiveRole ( user,session,role:NAME )
	-DropActiveRole( user,session,role:NAME )
	-CheckAccess ( session,operation,object:NAME; out result:BOOLEAN )

	// ������� ������ ��� ���� RBAC
	Review Functions for Core RBAC
	-AssignedUsers ( role:NAME; out result: 2 USERS )
	-AssignedRoles ( user:NAME; result: 2 ROLES )

	Review Functions for General Role Hierarchies
	-AuthorizedUsers ( role:NAME; out result: 2 USERS )
	-AuthorizedRoles ( user:NAME; result: 2 ROLES )

	// ������� ������������ ������ ��� ���� RBAC
	Advanced Review Functions for Core RBAC
	-RolePermissions ( role: NAME; result: 2 PERMS )
	-UserPermissions ( user: NAME: result: 2 PERMS )
	-SessionRoles ( session: NAME; out result: 2 ROLES )
	-SessionPermissions ( session: NAME; out result: 2 PERMS )
	-RoleOperationsOnObject ( role: NAME; obj:NAME; result: 2 OPS )
	-UserOperationsOnObject ( user: NAME; obj:NAME; result: 2 OPS )

	Advanced Review Functions for General Role Hierarchies
	-RolePermissions ( role: NAME; result: 2 PERMS )
	-UserPermissions ( user: NAME; result: 2 PERMS )
	-RoleOperationsOnObject ( role:NAME; obj:NAME; result: 2 OPS )
	-UserOperationsOnObject ( user:NAME; obj:NAME; result: 2 OPS )

*/
}