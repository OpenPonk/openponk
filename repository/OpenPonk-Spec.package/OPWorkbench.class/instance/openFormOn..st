opening
openFormOn: aController
"	editors values
		detect: [ :tuple | tuple second selectedHolder value ]
		ifFound: [ :tuple | tuple first openFormOn: aController ]."
	formModel editController: aController