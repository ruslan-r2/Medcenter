component displayname="redirector" {

	// ������ �����������
	//instance.url = '';
	//instance.reason = '';
	// ����� �� ������� �������� ���� ���������� ������
	
	function init(){return this;}

	function redirect(required URL, reason=''){
		UT_flag = false;
		if (arguments.reason == ''){
			location('#arguments.URL#',  UT_flag );
		}else{
			location('#arguments.URL#&#arguments.reason#', UT_flag );
		}
	}
}