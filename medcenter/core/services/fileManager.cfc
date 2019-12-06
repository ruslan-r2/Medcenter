component attributeName='fileManager' output='false' {

	function init(){
		return this;
	}

	function addToTextFile(required fileName, required data) {

		charset='utf-8';
		//charset='windows-1251';

		PathFile=expandPath(arguments.fileName);

		if (fileExists(PathFile)) {

			temp=fileOpen(PathFile,'append',charset);
			fileWrite(temp,arguments.data);
			fileClose(temp);

		} else {

			fileWrite(PathFile,arguments.data,charset);

		}
	}
	
	function readTxtFile(required filename){
		charset='utf-8';

		PathFile=expandPath(arguments.fileName);

			//temp=fileOpen(PathFile,'read',charset);
			//result = fileRead(temp);
			//fileClose(temp);
			result = fileRead(PathFile,charset);

		return result;

	}
	
}