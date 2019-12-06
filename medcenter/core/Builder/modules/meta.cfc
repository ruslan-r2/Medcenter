/*
	Добавить возможно отображения canonical при необходимости
*/

component attributeName='meta' {

	instance.title = '';
	instance.description = '';
	instance.keywords = '';

	instance.language='RU';
	instance.charset='utf-8'; // UTF-8 windows-1251
	instance.lastModified = DateFormat(DateConvert('local2Utc', '#now()#'), 'ddd, d mmm yyyy ') & TimeFormat(DateConvert('local2Utc', '#now()#'), 'HH:mm:ss ') & 'GMT'; //Thu, 1 Sep 2012 23:55:55 GMT
	instance.generator='digann.ru v.2';
	instance.robots='index,follow';

	instance.verification.yandex='5f3ee613c12d76a5';
	instance.verification.google='KP5Di0uBFp3iLzBq2PZGar75WK3iejUPzEBKIXSbEyg';
	instance.verification.wot='97791b4f988babbd59bc';
	instance.verification.webmoney='webmoney attestation label##84F70486-F7FC-4116-9749-2CB945D31A4F';

	instance.stylesheet1='/css/reset.css';
	instance.stylesheet2='/css/text.css';
	instance.stylesheet3='/css/grid.css';
	instance.stylesheet4='/css/demo.css';
	instance.stylesheet5='/css/main.css';
	instance.stylesheet6='/css/pickmeup.min.css';
	instance.stylesheet7='/css/tooltipster.css';



	instance.shortcut='favicon.ico';


	function Init( title = '', description = '', keywords = '') {

		instance.title = arguments.title;
		instance.description = arguments.description;
		instance.keywords = arguments.keywords;
		
		return this;
	}

	// PRIVATE ---------------------------------------------------------------------
	function View() {
		meta = '';

		meta &= '
	<title>#instance.title#</title>
	<meta name="description" content="#instance.description#">
	<meta name="keywords" content="#instance.keywords#">

	<meta http-equiv="Accept" content="text/html, application/xhtml+xml, */*">
	<meta http-equiv="Accept-Language" content="#instance.language#">
	<meta http-equiv="Accept-Charset" content="#instance.charset#">
	<meta http-equiv="Content-Language" content="#instance.language#">
	<meta http-equiv="Content-Type" content=" application/xhtml+xml; charset=#instance.charset# ">
	<meta name="Last-Modified" content="#instance.lastModified#">
	<meta name="generator" content="#instance.generator#">
	<meta name="robots" content="#instance.robots#">';

		if ( request.CRequest.checkUrlEmpty() ){
		meta &= '
	<meta name="yandex-verification" content="#instance.verification.yandex#">
	<meta name="google-site-verification" content="#instance.verification.google#">
	<meta name="wot-verification" content="#instance.verification.wot#">
	<meta name="webmoney.attestation.label" content="#instance.verification.webmoney#">';
		}

		meta &= '
	<link rel="stylesheet" type="text/css" href="#instance.stylesheet1#" media="all">
	<link rel="stylesheet" type="text/css" href="#instance.stylesheet2#" media="all">
	<link rel="stylesheet" type="text/css" href="#instance.stylesheet3#" media="all">
	<link rel="stylesheet" type="text/css" href="#instance.stylesheet5#" media="all">
	<link rel="stylesheet" type="text/css" href="#instance.stylesheet6#" media="all">
	<link rel="stylesheet" type="text/css" href="#instance.stylesheet7#" media="all">
	<link rel="shortcut icon" href="#instance.shortcut#" type="image/x-icon">';

		// проверка на включение у пользователя ява или нет
		if ( request.CClient.getClient('javascript') ){
		meta &= '
			<script src="/js/scripts.js?CFID=#client.CFID#&CFTOKEN=#client.CFTOKEN#" type="text/javascript"></script>';
		}

		// нужно передавать в яваскрипт CFID и CFTOKEN и все ява запросы делать с этими параметрами без исключения
		// как это сделать пока не знаю.

		// добавление тега каноникал
		//meta &= '';
			/*
			<cfset canonical="">
			<cfif isdefined('url.start')>
				<cfset canonical ="http://www.digann.ru/?#rereplace(cgi.query_string,"&start.*","","all")#">
			</cfif>
			<cfif url.opf is not "">
				<cfset canonical ="http://www.digann.ru/?#rereplace(cgi.query_string,"&opf.*","","all")#">
			</cfif>
			*/

	
			return meta;
	}

}