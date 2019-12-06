component attributeName='logo' {

	function Init(active=true) {
		instance.active=arguments.active;
		return this;
	}

	function View() {
		if (instance.active) {
		logo = '
			<div class="grid_8">
				
				<a href="#request.CRequest.updateURL(false,"/?page=reception")#"><img src="/img/gp.gif" alt="logo" border="0"></a>
				
			</div>';
		}else{
		logo = '
			<div class="grid_8">
				
				<img src="/img/gp.gif" alt="logo" border="0">
				
			</div>';
		}

		return logo;

	}
}

// <img src="/img/digann.gif" alt="logo" border="0">
// <img src="/img/digann.gif" alt="logo" border="0">