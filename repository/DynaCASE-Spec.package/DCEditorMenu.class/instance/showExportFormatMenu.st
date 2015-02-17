as yet unclassified
showExportFormatMenu
	| menu fileName |
	menu := MenuMorph new.
	fileName := self workbench projectController project projectName , ' - DynaCASE'.
	menu
		add: 'PNG'
			target: self canvasModel
			selector: #exportAsPng:
			argument: fileName;
		add: 'JPEG'
			target: self canvasModel
			selector: #exportAsJpg:
			argument: fileName;
		add: 'BMP'
			target: self canvasModel
			selector: #exportAsBmp:
			argument: fileName;
		add: 'GIF'
			target: self canvasModel
			selector: #exportAsGif:
			argument: fileName.
	menu addTitle: 'Select picture format'.
	menu popUpInWorld