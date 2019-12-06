/*	20.02.2012 - AlRus( Repin R.).
* 	������� ��������
* 	���� ������ ��� ������ ���������� ������ � ���� �������,
* 	���� ������ ��� �� �����, ������� � ���������� ������ � ���� �������.
*/

component name='factoryService' output='false'{

	// ������ �����������
	instance.services = structNew();

	function init(){
		// ����� ��� ������ ������� ������� ������ �����, �������� CSettings
		// �� ����� ��������� ������ � ��� ����� ������� ��� ��� �����!!!
		return this;
	}

	function getService(required string service){
	    if (StructKeyExists(instance.services,arguments.service)) {
	      return instance.services[arguments.service];
	    } else {
	      instance.services[arguments.service]=CreateObject('component','core.services.#arguments.service#').init();
	      return instance.services[arguments.service];
	    }
	}

	function getMemento(){
		return instance;
	}


}