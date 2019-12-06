<cfcomponent displayname="CCookie" output="false" >

<cfscript>

	//instance._cookie = {};
	
	function init(){
		
		//instance._cookie = cookie;
		
		for (key in cookie){
			if ( !structKeyExists(cookie, 'CFID') || cookie['CFID'] is ''){
				setCookie(name='CFID', value=cookie.CFID, expires='NEVER', domain='#cgi.REMOTE_ADDR#');
				//instance._cookie['CFID'] = cookie.CFID;
			}else if(!structKeyExists(cookie, 'CFTOKE') || cookie['CFTOKEN'] is ''){
				setCookie(name='CFTOKEN', value=cookie.CFTOKEN, expires='NEVER', domain='#cgi.REMOTE_ADDR#');
				//instance._cookie['CFTOKEN'] = cookie.CFTOKEN;
			
			}
			// все что приходит из COOKIES кроме CFID и CFTOKEN нужно удалять.
			// JSESSIONID создается колдой для форм, как отключить или обойтись пока не знаю.
			if ( key != 'CFID' AND key != 'CFTOKEN' AND key != 'JSESSIONID'){
				setCookie(name='#key#', value='', expires='NOW', domain='#cgi.REMOTE_ADDR#');

				// лишнее что пришло в кукисах можно сохранять в текстовый файл, в базу опасно.
				request.factoryService.getService('Clog').AddLogging(ssection='CCookie', type='event', description='Недопустимые символы в Cookie');
				// фаерволл
       				// почему то при каждом запросе попадаем в этот иф
				request.factoryService.getService('CFireWall').addWarnings(1);
			}
		}
		return this;
	}

	function getCookie(varCookie='') {
		if (varCookie=='') {
			return cookie;
		} else {
			return cookie[varCookie];
		}
	}
</cfscript>	

	<cffunction name="setCookie" access="public" returnType="void" output="false">
		<cfargument name="name" type="string" required="true">
		<cfargument name="value" type="string" required="false">
		<cfargument name="expires" type="string" required="false">
		<cfargument name="domain" type="string" required="false">
		<!---
		<cfargument name="httpOnly" type="boolean" required="false">
		<cfargument name="path" type="string" required="false">
		<cfargument name="secure" type="boolean" required="false">
		--->
			<cfcookie name="#arguments.name#" value="#arguments.value#" expires="#arguments.expires#" DOMAIN="#arguments.domain#">
	</cffunction>

</cfcomponent>