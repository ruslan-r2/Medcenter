/* 
*/

component attributeName='temp' output='false'{
	// ������ �����������
	factoryService = request.factoryService;

	instance.view = '';

	//instance.userName = '';

	instance.message = '';


	function Init(string section, string action) {
		section = arguments.section;
		action = arguments.action;

		myArray[1] = structNew();
		myArray[1].name = '����������������';
		myArray[1].data = '� ������ ������������� �������.';
		myArray[1].pos = 1;

		myArray[2] = structNew();
		myArray[2].name = '�������� ���������';
		myArray[2].data = '�������';
		myArray[2].pos = 2;

		myArray[3] = structNew();
		myArray[3].name = '�������� �������';
		myArray[3].data = '2-3 ���� � ����.';
		myArray[3].pos = 3;

		myArray[4] = structNew();
		myArray[4].name = '������������';
		myArray[4].data = arrayNew(1);
		myArray[4].data[1] = structNew();
		myArray[4].data[1].name = '�����';
		myArray[4].data[1].data = '������������.';
		myArray[4].data[1].pos = 1;
		myArray[4].data[2] = structNew();
		myArray[4].data[2].name = '�����';
		myArray[4].data[2].data = '1, �� �������. ����������� ������ ���������.';
		myArray[4].data[2].pos = 2;
		myArray[4].pos = 4;

		//writeDump(myArray);
		_myArray = SerializeJSON( myArray );
		//writeDump(_myArray);
		__myArray = DeserializeJSON( _myArray );
		//writeDump(__myArray);

		/*
		factorJSON = '{
				"����������������":"� ������ ������������� �������.",
				"�������� ���������":"�������.",
				"�������� �������":"2-3 ���� � ����.",
				"������� ��������":"��������.",
				"����������� �����������":"�.�������.",
				"����������� ������ � ������������� �������������":"1991 �. ��������������� ������ ��������. 1995 �. ����������� ������������. 2006 �. ����������� �����.",
				"����������� ����� � ����������������":"1995 �. ������������ ����������� �����.",
				"����������������� �������":"�� ��������.",
				"�����-�� �����":
					{
						"����":"� �������, ����� ��� ��������� ������.",
						"��������":" "
					}
				}';
		*/

		//theJSON = DeserializeJSON( factorJSON );
		instance.view = '<div class="grid_16">
				<div class="signin-box">
					<h2>TEMP</h2>
					';
		//
		instance.view &= '<b>������� �����</b><br>';
		/*
		for (key in theJSON){
			instance.view &= '<ul><b>#key#:</b> ';
			if ( isStruct(StructFind(theJSON,key)) ){
				//
				_struct = StructFind(theJSON,key);
				for (_key in _struct){
					instance.view &= '<li><b>#_key#:</b> #StructFind(_struct,_key)#</li>';

				}
				instance.view &= '';
			}else{
				instance.view &= '#StructFind(theJSON,key)#<br>';
			}
			
		}*/
/*
		for (i=1; i<=arrayLen(myArray); i++){
			instance.view &= '<b>#myArray[i].name#: </b>';
			if ( IsSimpleValue( myArray[i].data ) ){
				instance.view &= '#myArray[i].data#<br>';
			}else if( isArray(myArray[i].data) ){
				//instance.view &= 'Yes';
				for(j=1; j<=arrayLen(myArray[i].data); j++){
					instance.view &= '<br>#myArray[i].data[j].name#: #myArray[i].data[j].data#';
				}
			}
			//writeDump(myArray[i]);
		}
*/
		instance.view &= '</ul>
				</div></div>';

		instance.view &= '
			<div class="grid_5">
				<textarea id="OutPut" rows="6" cols="30">#now()#</textarea>
			</div>

			<div class="grid_5">
				<select id="TextSelect" multiple>
					<option selected>�������� ���� (��).</option>
					<option>������ � �����.</option>
					<option>������ ���� � ����.</option>
				</select>
				<br>
				<input id="TextInsert" type="button" value="copy" />
			</div>';




		return this;

	}

	function View() {
		return instance.view;
  	}

}

/*
[	{"NAME":"������","POS":1.0,"DATA":""},
	{"NAME":"�������������� �������","POS":2.0,"DATA":""},
	{"NAME":"������������� ������","POS":3.0,"DATA":""},
	{"NAME":"���������","POS":3.0,"DATA":""},
	{"NAME":"����������","POS":3.0,"DATA":""},
	{"NAME":"������������","POS":4.0,"DATA":
		[	{"NAME":"�����","POS":1.0,"DATA":"������������."},
			{"NAME":"�����","POS":2.0,"DATA":"1, �� �������. ����������� ������ ���������."}
		]
	}
]
*/

