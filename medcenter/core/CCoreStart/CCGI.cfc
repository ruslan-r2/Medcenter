component displayname="CCGI" output="false" {
	//variables.instance._CGI = {};
	function init(){
		return this;
	}

	function getCGI(varCGI='') {
		if (varCGI=='') {
			return CGI;
		} else {
			return CGI[varCGI];
		}
	}
	
}