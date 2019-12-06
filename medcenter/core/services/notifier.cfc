component displayName='notifier' {

	instance.note='';

	function Init() {
		return this;
	}

	function SetNote(note) {
		if (instance.note=='') {
			instance.note=arguments.note;
		} else {
			instance.note='#instance.note# <br> #arguments.note#';
		}
	}

	function GetNote() {
		return instance.note;
	}

}