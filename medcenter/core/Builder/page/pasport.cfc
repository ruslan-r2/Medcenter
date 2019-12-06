component attributeName='pasport' {

	// дл€ виджетов
	request.factoryWidget=createObject('component','core.builder.factoryWidget').Init();

	function Init() {
		widget.meta=request.factoryWidget.GetWidget('meta').Init(type='minimal');
		//widget.logo=request.factoryWidget.GetWidget('logo').Init(active=false);
		widget.auth=request.factoryWidget.GetWidget('auth').Init(mini='false');
		//widget.menu=request.factoryWidget.GetWidget('menu').Init('pasport');
		//widget.info=request.factoryWidget.GetWidget('info').Init(pageName='pasport');
		//widget.footer=request.factoryWidget.GetWidget('footer').Init();
		return this;
	}

	function Render() {
		page = '';
		page &= '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">';
		page &= '<HTML>';
		page &= '	<HEAD>';
			page &= widget.meta.View();
		page &= '	</HEAD>';

		page &= '<BODY>';
		page &= '<div class="container_16">';
		// header
			//page &= widget.logo.View();
			//page &= '<div class="clear"></div>';
		// header
			//page &= widget.menu.View();
			//page &= '<div class="clear"></div>';

			//page &= widget.info.View();
			//page &= '<div class="clear"></div>';

			page &= widget.auth.View();

			//page &= '
			//<div class="grid_10">
			//	<div class="signin-box">
			//		<h2>‘орма авторизации</h2><br>ƒанна€ форма преднозначена дл€ зарегистрированных пользователей.
			//		≈сли вы еще не зарегистрированы, то може перейти по этой ссылке <a href="">ссылка.</a>
			//	</div>
			//</div>';

			page &= '<div class="clear"></div>';

			//page &= widget.footer.View();
			//page &= '<div class="clear"></div>';

		page &= '		</div>';
		page &= '	</BODY>';
		page &= '</HTML>';

		writeOutPut(page);
	}

}