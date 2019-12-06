// скрипт подгружает все необходимы скрипты
function getxmlhttp(){
	var xmlhttp;
	try { xmlhttp = new ActiveXObject("Msxml2.XMLHTTP"); }
	catch(e){ try { xmlhttp = new ActiveXObject("Microsoft.XMLHTTP"); } catch(e) { xmlhttp = false; } }
	if(!xmlhttp && typeof XMLHttpRequest != 'undefined') { xmlhttp = new XMLHttpRequest(); }
	return xmlhttp;
}

// можно потом добавить флаги рендом и может быть SSL
function updateURL(inURL){
	var urlParams = parseGetParams();
	var outURL = '';
	outURL += inURL;
	if ( urlParams.page != undefined){outURL += '&page='+urlParams.page;}
	if ( urlParams.CFID != undefined){outURL += '&CFID='+urlParams.CFID;}
	if ( urlParams.CFTOKEN != undefined){outURL += '&CFTOKEN='+urlParams.CFTOKEN;}
	outURL += '&r='+Math.random();
	return outURL;
}

function getJScripts() {
	var urlParams = parseGetParams();
	var xmlhttp;
	xmlhttp = getxmlhttp();

	xmlhttp.open('GET', updateURL('ajax.cfc?method=javaScripts&returnFormat=JSON'), true);
	//xmlhttp.open('GET', _URL, true);
	xmlhttp.onreadystatechange = function() {
	  if (xmlhttp.readyState == 4) {
	     if(xmlhttp.status == 200) {
		// дл€ разбора ответа
		var list = xmlhttp.responseText; // list
		list = list.replace( /"|\\/g ,''); // /"|\\/g
		var mass = list.split(",");
		//console.log(mass); // дл€ fireBug в эксплорере скрипты стрел€ютс€ если эту строчку раскоментить !!!!!!!!
		//alert(mass[0]+mass[1]+mass[2]);
		for(var i=0; i<mass.length; i++) { 
			dhtmlLoadScript(mass[i]);
			//console.log(mass[i]);
		}                                                 	
	     }
	  }
	};
	//xmlhttp.setRequestHeader("If-Modified-Since", "Thu, 01 Sep 2012 00:00:00 GMT" );
	xmlhttp.setRequestHeader('Content-Type', 'text/xml; charset=UTF-8');
	xmlhttp.setRequestHeader('Accept', 'application/json');
	xmlhttp.send(null);
}


function dhtmlLoadScript(url)
{
	var e = document.createElement("script");
	e.setAttribute("src",url); //e.src = url;
	e.setAttribute("type","text/javascript"); //e.type="text/javascript";
	document.getElementsByTagName("head")[0].appendChild(e);
}

function parseGetParams() { 
   var $_GET = {}; 
   var __GET = window.location.search.substring(1).split("&"); 
   for(var i=0; i<__GET.length; i++) { 
      var getVar = __GET[i].split("="); 
      $_GET[getVar[0]] = typeof(getVar[1])=="undefined" ? "" : getVar[1]; 
   } 
   return $_GET; 
} 

onload = function(){getJScripts();}