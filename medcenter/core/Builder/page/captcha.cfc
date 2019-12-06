/*
 *	контроллер страници капча 
 **/
component attributeName='captcha' {

	// для виджетов
	request.factoryWidget=createObject('component','core.builder.factoryWidget').Init();

	function Init() {
		widget.meta=request.factoryWidget.GetWidget('meta').Init();
		widget.logo=request.factoryWidget.GetWidget('logo').Init(active=false);
		widget.info=request.factoryWidget.GetWidget('info').Init(pageName='captcha');
		widget.captcha=request.factoryWidget.GetWidget('captcha').Init();
		return this;
	}

	function Render() {
		page = '';
		page &= '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">';
		page &= '<HTML>';
		page &= '	<HEAD>';
			page &= widget.meta.View();
		page &= '	</HEAD>';
		page &= '	<BODY>';
		page &= '		<div class="container_16">';
		// header
			page &= widget.logo.View();
		// header

		//body
			page &= widget.info.View();
			page &= '<div id="block">К сожалению, или к счастью, Вы попали под подозрение. Если Вы не робот введите контрольные цифры с картинки и продолжите работу!</div>';
			page &= widget.captcha.View();
		//body

		page &= '		</div>';
		page &= '	</BODY>';
		page &= '</HTML>';

		writeOutPut(page);
	}

}