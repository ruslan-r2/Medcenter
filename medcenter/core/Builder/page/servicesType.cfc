component attributeName='servicesType' {

	// для виджетов
	request.factoryWidget=createObject('component','core.builder.factoryWidget').Init();

	service.rbac = request.RBAC;

	instance.url.section = request.CRequest.getUrl('section');
	instance.url.action = request.CRequest.getUrl('action');

	function Init() {
		// -------------------------------------------------------------------------

		instance.title = 'Типы услуг';

		instance.description = 'Типы услуг';

		instance.keywords = 'Типы услуг';

		widget.meta=request.factoryWidget.GetWidget('meta').Init( title=instance.title, description=instance.description, keywords=instance.keywords);
		widget.logo=request.factoryWidget.GetWidget('logo').Init(active=true);
		widget.auth=request.factoryWidget.GetWidget('auth').Init();
		widget.menu=request.factoryWidget.GetWidget('menu').Init('servicesType');
		widget.info=request.factoryWidget.GetWidget('info').Init( pageName='servicesType', sniplet=instance.description);

		widget.servicesType=request.factoryWidget.GetWidget('servicesType').init(instance.url.section,instance.url.action);

		widget.footer=request.factoryWidget.GetWidget('footer').Init();
		return this;
	}

	function Render() {
		page = '';
		page &= '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">';
		page &= '<HTML>';
		page &= '	
	<HEAD>';
		page &= widget.meta.View();
		page &= '	
	</HEAD>';
		page &= '
	<BODY>';
		page &= '
		<div class="container_16">';
		// header
			page &= widget.logo.View();
			page &= widget.auth.View();
			page &= '
		<div class="clear"></div>';
		// header
			page &= widget.menu.View();
			page &= '
		<div class="clear"></div>';

			page &= widget.info.View();
			page &= '
		<div class="clear"></div>';

			page &= widget.servicesType.View();
			page &= '
		<div class="clear"></div>';

			page &= '';
			page &= '
		<div class="clear"></div>';

			page &= widget.footer.View();
			page &= '
		<div class="clear"></div>';

		page &= '
		</div>';
		page &= '
	</BODY>';
		page &= '
</HTML>';

		writeOutPut(page);
	}

}