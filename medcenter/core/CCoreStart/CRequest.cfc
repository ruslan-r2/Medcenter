component displayname="CRequest" {

	// псевдо конструктор
	instance.CRequest = { HttpRequestData='', url = '', form= '' } ;
	instance.CRequest.url = URL;
	instance.CRequest.form = FORM;
	instance.CRequest.HttpRequestData = GetHttpRequestData();
	
	function init(){
		return this;
	}

	// проверка урла запускается после фаервола и редиректа
	function CheckUrl() {
		urlString=cgi.query_string;
		// regular=request.factoryService.getService('cSettings').getSettings('request');
		regular='%D0%[9AB][0-9A-F]|%D1%8[0-9A-F]|%D0%81|%D1%91|%20|%3A%2F%2F|%3F|%3D|[a-zA-Z0-9=&]|[\/\:\.\?\%]';
		check=ReReplace(urlString,regular,'','all');
		if (!check=='') {
			request.factoryService.getService('Clog').AddLogging(ssection='CRequest', type='event', description='Недопустимые символы в урле!');
			request.factoryService.getService('cFireWall').addWarnings(1);

			return false;
		}else{
			return true;
		}
	}

	function checkUrlEmpty(){
		return structIsEmpty(instance.CRequest.url);
	}

	function GetUrl(key) {
	//writeoutput('<br>GetUrl IN #arguments.key#<br>');
		if (StructKeyExists(instance.cRequest.url,arguments.key)) {
	//writeoutput('<br>GetUrl TRUE #arguments.key#<br>');
			return instance.cRequest.url[arguments.key];
		} else {
	//writeoutput('<br>GetUrl FALSE #arguments.key#<br>');
			return false;
		}
	}

	function GetForm(key) {
		if (StructKeyExists(instance.cRequest.form,arguments.key)) {
			return instance.cRequest.form[arguments.key];
		} else {
			return false;
			// return '';
		}
	}

	function GetAllForm() {
		return instance.cRequest.form;
	}

	function isAjax(){
		accept = instance.CRequest.HttpRequestData.headers.accept;
		if ( Find("text/html", accept) ){ return 'html';}
		else if ( Find("application/json", accept) ){ return 'json';}
		else if ( Find("application/xml", accept) ){ return 'xml';}
		else { return 'unknow';}
	}

	function addUrlToken(){
		// и спросить у фаервола роль ip адреса
		if ( CGI.HTTP_COOKIE == ''  AND request.factoryService.getService('CFireWall').getRole() != 'robot'){
			return '&#client.urlToken#';
		} else {
			return '';
		}
	}

	// конструктор URL автоматическая добавка urlToken
	function updateURL(boolian SSL=false, required string inURL ){
		var outURL = '';
		if ( !arguments.SSL ){ outURL &= 'http://'; }
		else{ outURL &= 'https://'; }
		outURL &= #request.factoryService.getService('CSettings').getSettings('system').domainName#;
		//outURL &= 'localhost';
		outURL &= '#arguments.inURL#';
		// и спросить у фаервола роль ip адреса
		if ( CGI.HTTP_COOKIE == ''  AND request.factoryService.getService('CFireWall').getRole() != 'robot'){ outURL &= '&#client.urlToken#';}
		else{ outURL &= '';}
		return outURL;		
	}

	function getRequest() {
		return instance.cRequest;
	}

	function getRequestUrl() {
		return instance.cRequest.url;
	}

}