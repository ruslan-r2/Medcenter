component attributeName='factoryWidget' {

	function Init() {
		instance.widget=StructNew();
		return this;
	}

	function GetWidget(widget) {
		if (!StructKeyExists(instance.widget,arguments.widget)) {
			//instance.widget[arguments.widget]=CreateObject('component','core.builder.modules.#arguments.widget#').Init();
			instance.widget[arguments.widget]=CreateObject('component','core.builder.modules.#arguments.widget#');
		}
		return instance.widget[arguments.widget];
	}

	function getMemento(){
		return instance;
	}

}