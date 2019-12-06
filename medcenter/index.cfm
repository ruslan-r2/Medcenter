<!--- проверка мыльного сервака
<cfscript>
mailService=request.factoryService.getService('mailService');
mailService.Send('support@digann.ru','subject','Праверко отправки мыла!');
</cfscript>
--->

<!--- Дамп --->
<!---
JavaScript: <cfdump var="#request.factoryService.getService('CJavaScript').getStateJS()#"> <br>
--->

<!---

form:
<cfdump var="#form#"> <br>

Список сервисов:
<cfdump var="#request.factoryService.getMemento()#"> <br>
--->

<!---
#request.factoryService.getService('CCaptcha').generateCaptcha()#
--->

<!---
CGI:
<cfdump var="#cgi#"> <br>

Cokie:
<cfdump var="#cookie#"> <br>

session:
<cfdump var="#session#"> <br>

sessionStorage:<br>
<cfscript>
	lock scope="session" type="readonly" timeout="5" {
		sessionStorage = session.sessionStorage;
	}
</cfscript>
UserIP:<br>
<cfdump var="#sessionStorage.getObject('UserIP').getMemento()#"> <br>
User:<br>
<cfdump var="#sessionStorage.getObject('user').getMemento()#"> <br>
captcha:<br>
<cfdump var="#sessionStorage.getObject('captcha').getMemento()#"> <br>

Application:
<cfdump var="#application#"> <br>
<cfdump var="#application.applicationStorage.getObject('settings').getSettings()#"> <br>

FireWall:
<cfdump var="#request.factoryService.getService('CFireWall').getRole()#"> <br>
<cfdump var="#request.factoryService.getService('CFireWall').getMemento()#"> <br>

Client:
<cfdump var="#client#"> <br>

URL:
<cfdump var="#url#"> <br>

CRequest headers:
<cfdump var="#request.CRequest.getRequest().HttpRequestData#"> <br>
<cfdump var="#request.CRequest.isAjax()#"> <br>
<cfdump var="#request.CRequest.addUrlToken()#"> <br>

--->

<!---
<cfoutput>
<cfdump var="#getpagecontext().getResponse()#">
</cfoutput>
--->
<!---
<cfscript>
	option['force_show_code'] = true;
	if (!isDefined('_SAPE_USER')){ _SAPE_USER = 'd9730df79810be1ed36278294faf309b'; }
	objSape = createObject('component',"#_SAPE_USER#.SAPE_client").SAPE_client(option);
	//writeDump( objSape.getMemento() );
</cfscript>
<cfoutput>
#objSape.return_links()#
</cfoutput>
--->

<!---
<cfheader name="Content-Disposition" value="inline; filename=acmesalesQ1.xls"> 
<cfcontent type="application/vnd.msexcel;charset=windows-1251" > 
 
<table border="1"> 
<tr><td>Month</td><td>Quantity</td><td>$ Sales</td></tr> 
<tr><td>January</td><td>80</td><td >245</td></tr> 
<tr><td>February</td><td>100</td><td>699</td></tr> 
<tr><td>March</td><td>230</td><td >2036</td></tr> 
<tr><td>Total</td><td>=����(B2..B4)</td><td>=����(C2..C4)</td></tr> 
</table>
--->