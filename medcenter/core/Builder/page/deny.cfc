component attributeName='deny' {

	// для виджетов
	request.factoryWidget=createObject('component','core.builder.factoryWidget').Init();

	function Init() {
		widget.meta=request.factoryWidget.GetWidget('meta').Init();
		widget.logo=request.factoryWidget.GetWidget('logo').Init(active=false);
		widget.info=request.factoryWidget.GetWidget('info').Init(pageName='deny');
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
			page &= '<div id="block"><br><br><br><b>DENY</b> По возможности указать за что deny.<br><br><br><br><br></div>';
		//body

		page &= '		</div>';
		page &= '	</BODY>';
		page &= '</HTML>';

		writeOutPut(page);
	}
}