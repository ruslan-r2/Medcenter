/*
  Сервис PAGER
*/

component displayname="pager" output="false" {

	// Псевдо конструктор
	
	function init(){
		return this;
	}

	function setSettings(startPage, messagePerPage, records, link){
		setStartPage(arguments.startPage);
		setMessagePerPage(arguments.messagePerPage);
		setRecords(arguments.records); //recordcount
		setPages();
		setCurrentPage();
		setLink(arguments.link);
	}

	function setStartPage(startPage){
		instance.startPage = arguments.startPage;
	}

	function setRecords(records){
		instance.records = arguments.records;
	}

	function setMessagePerPage(messagePerPage){
		instance.messagePerPage = arguments.messagePerPage;
	}

	function setPages(){
		instance.pages = ceiling( instance.records / instance.messagePerPage );
	}

	function setCurrentPage(){
		instance.cur_page = startToPage(instance.startPage, instance.messagePerPage);
	}
	function setLink(link){
		instance.link = arguments.link;
	}

	function startToPage(start, size) {
		return ceiling((start + size - 1) / size);
	}

	function pageToStart(page, size) {
		return (page-1) * size + 1;
	}

	//-------------------------------------------------------------------
	function show_page(p,t) {
		if (p is instance.cur_page){
			return " <B>#t#</B>";
		}else{
			pStart = pageToStart(p, instance.messagePerPage);
			return " <a href='#instance.link##pStart#'><font color='0066CC'>#t#</font></a>";
		}
	}

	function view(){
		view = '';
		if (instance.pages gt 1){
			view &= 'Страница <B>#instance.cur_page#</B> из <B>#instance.pages#</B>';
		}
		return view;
	}

	function view1(){
		view = '';

		if (instance.pages gt 1){
			view &= 'Страница:';
 
			if ( instance.cur_page gt 1 ){
				view &= show_page(instance.cur_page-1, "&##171;Пред ");
			}

			if (instance.pages lte 10){
				for (var x=1; x<=instance.pages; x++){
					view &= show_page(x, x);
				}
		        }else{
				start_page = instance.cur_page - 3;
				end_page = instance.cur_page + 3;
				if (start_page lte 1){
					end_page = 8;
					start_page = 1;
				}

				if (end_page gte instance.pages){
					end_page = instance.pages;
					start_page = instance.pages - 7;
				}

				if (start_page is not 1){
					view &= show_page(1, 1);
				}			

				if (start_page gt 2){
					view &= '...';
				}

				for (var x=start_page; x<=end_page; x++){
					view &= show_page(x,x);
				}

				if (end_page lt instance.pages - 1){
					view &= '...';
				}

				if (end_page is not instance.pages){
					view &= show_page(instance.pages, instance.pages);
				}
			}

			if (instance.cur_page lt instance.pages){
				view &= show_page(instance.cur_page+1, "След&##187;");
			}

	      view &= '';
		}
		return view;

	}



}