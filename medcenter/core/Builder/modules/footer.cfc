component attributeName = 'footer' {

	function Init() {
		return this;
	}

	function View() {
	footer = '';
	footer &= '<div class="grid_16"><div class="block" style="text-align:right;background:##f1f1f1">&nbsp;�����@2005-2014 �.&nbsp;</div></div>';

/*			<div class="grid_5">� ���<br>
				<a href = "#request.CRequest.updateURL(false,"/?page=help&did=100001")#">��������</a><br>
				<a href = "#request.CRequest.updateURL(false,"/?page=help&did=100000")#">� ���</a>
			</div>
			<div class="grid_6">�������� �������<br>
				<a href = "#request.CRequest.updateURL(false,"/?page=help&did=200000")#">���������������� ����������.</a>
			</div>
			<div class="grid_5">������<br>
				<a href = "#request.CRequest.updateURL(false,"/?page=quest")#">����� �������� �����</a><br>
				<a href = "#request.CRequest.updateURL(false,"/?page=help&did=300000")#">����\FAQ</a>
			</div>';
*/
		return footer;
	}
}