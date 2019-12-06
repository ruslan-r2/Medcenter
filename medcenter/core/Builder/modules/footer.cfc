component attributeName = 'footer' {

	function Init() {
		return this;
	}

	function View() {
	footer = '';
	footer &= '<div class="grid_16"><div class="block" style="text-align:right;background:##f1f1f1">&nbsp;АлРус@2005-2014 г.&nbsp;</div></div>';

/*			<div class="grid_5">О нас<br>
				<a href = "#request.CRequest.updateURL(false,"/?page=help&did=100001")#">Контакты</a><br>
				<a href = "#request.CRequest.updateURL(false,"/?page=help&did=100000")#">О нас</a>
			</div>
			<div class="grid_6">Основные разделы<br>
				<a href = "#request.CRequest.updateURL(false,"/?page=help&did=200000")#">Пользовательское соглашение.</a>
			</div>
			<div class="grid_5">Помощь<br>
				<a href = "#request.CRequest.updateURL(false,"/?page=quest")#">Форма обратной связи</a><br>
				<a href = "#request.CRequest.updateURL(false,"/?page=help&did=300000")#">ЧаВо\FAQ</a>
			</div>';
*/
		return footer;
	}
}