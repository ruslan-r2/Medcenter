component attributeName='warning' {

	// ��� ��������
	request.factoryWidget=createObject('component','core.builder.factoryWidget').Init();

	function Init() {

		widget.meta=request.factoryWidget.GetWidget('meta').Init();
		widget.logo=request.factoryWidget.GetWidget('logo').Init();
		widget.auth=request.factoryWidget.GetWidget('auth').Init();
		widget.menu=request.factoryWidget.GetWidget('menu').Init('warning');
		widget.info=request.factoryWidget.GetWidget('info').Init();
		widget.footer=request.factoryWidget.GetWidget('footer').Init();
		return this;
	}


	function Render() {
		page = '';
		page &= '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">';
		page &= '<HTML>';
		page &= '<HEAD>';
		page &= widget.meta.View();
		page &= '</HEAD>';
		page &= '<BODY>';
		page &= '<div class="container_16">';
		// header
			page &= widget.logo.View();
			page &= widget.auth.View();
			page &= '<div class="clear"></div>';
		// header
			page &= widget.menu.View();
			page &= '<div class="clear"></div>';

			page &= widget.info.View();
			page &= '<div class="clear"></div>';

			page &= '<div id="block"><br><br><br><br><br><b>������!</b><hr>#url.message#<br><br><br><br><br></div></body></html>';
			page &= '<div class="clear"></div>';

			page &= widget.footer.View();
			page &= '<div class="clear"></div>';

		page &= '</div>';
		page &= '</BODY>';
		page &= '</HTML>';

		writeOutPut(page);
	}

}