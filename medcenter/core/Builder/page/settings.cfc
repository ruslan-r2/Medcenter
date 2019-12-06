component attributeName='settings' {

	// для виджетов
	request.factoryWidget=createObject('component','core.builder.factoryWidget').Init();

	function Init() {
		// -------------------------------------------------------------------------
		instance.title='Пользовательские настройки.';
		instance.description='Пользовательские настройки.';
		instance.keywords='Пользовательские настройки.';

		widget.meta=request.factoryWidget.GetWidget('meta').Init(title=instance.title,description=instance.description,keywords=instance.keywords);
		widget.logo=request.factoryWidget.GetWidget('logo').Init(active=true);
		widget.auth=request.factoryWidget.GetWidget('auth').Init();
		widget.menu=request.factoryWidget.GetWidget('menu').Init('settings');
		widget.info=request.factoryWidget.GetWidget('info').Init(pageName='settings',sniplet=instance.description);
		widget.settings=request.factoryWidget.GetWidget('userSettings').Init();
		widget.footer=request.factoryWidget.GetWidget('footer').Init();
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
		page &= widget.auth.View();
		page &= '<div class="clear"></div>';
		// header
			page &= widget.menu.View();
			page &= '<div class="clear"></div>';

			page &= widget.info.View();
			page &= '<div class="clear"></div>';

			page &= widget.settings.View();
			page &= '<div class="grid_8"><div class="signin-box"><h2>Помощь</h2> <p>Пользовательские настройки.</p> </div></div>';
			page &= '<div class="clear"></div>';

			page &= widget.footer.View();
			page &= '<div class="clear"></div>';


		page &= '		</div>';
		page &= '	</BODY>';
		page &= '</HTML>';

		writeOutPut(page);
	}

}