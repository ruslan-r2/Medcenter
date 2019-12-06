component displayName='info' {


	service.notifier=request.factoryService.GetService('notifier');


	function Init(pageName = '', sniplet = '') {

		instance.globalInfo = GetGlobalInfo();
		instance.localInfo = GetLocalInfo( arguments.pageName, arguments.sniplet );

		return this;
	}


	function GetGlobalInfo() {

		currentDay = Day(now());
		currentMonth = Month(now());
		currentYear = Year(now());

		gInfo = '<span>Сегодня: <b>#currentDay# #MonthAsString(currentMonth)# #currentYear#</b></span>';
		return gInfo;
	}

	function GetLocalInfo(pageName, sniplet = '') {
		//работаем с базой через ДАО
		lInfo = '';

		if (sniplet != ''){
			lInfo &= '<span>#arguments.sniplet#</span>';
		}

		//lInfo &= '<span><b>#arguments.pageName#</b></span>';

		return lInfo;
	}

	function CheckJava() {
		result = "<div>Включите javascript <a href='http://support.google.com/bin/answer.py?hl=ru&answer=23852'>как?</a></div>";
		return result;
	}

	function getNote(){

		view = '';
		note = service.notifier.GetNote();

		if (note != '') {
			view &= '<noscript>#CheckJava()#</noscript>';
			// нужно для уведомлений сделать вывод может в div
			view &= note;
		} else {
			view &= '<noscript>#CheckJava()#</noscript>';
		}

		return view;
	}


	function View() {
		info = '';

		if (instance.localInfo != '') {
			info &= '
			<div class="grid_8">
				<div class="signin-box">#instance.localInfo#</div>
			</div>';
		}

		if (instance.globalInfo != '') {
			info &= '
			<div class="grid_8">
				<div class="signin-box">
					#getNote()#
					#instance.globalInfo#
				</div>
			</div>';
		 }

		return info;

	}

}