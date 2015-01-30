as yet unclassified
showExportFormatMenu
	| menu |
	menu := MenuMorph new.
	menu
		add: 'PNG'
			target: self canvasModel
			selector: #exportAs:
			argument: #png;
		add: 'JPEG'
			target: self canvasModel
			selector: #exportAs:
			argument: #jpeg;
		add: 'BMP'
			target: self canvasModel
			selector: #exportAs:
			argument: #bmp;
		add: 'GIF'
			target: self canvasModel
			selector: #exportAs:
			argument: #gif.
	menu addTitle: 'Select picture format'.
	menu popUpInWorld