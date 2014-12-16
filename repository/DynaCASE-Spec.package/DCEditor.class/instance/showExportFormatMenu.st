as yet unclassified
showExportFormatMenu
	| menu |
	menu := MenuMorph new.
	menu
		add: 'PNG'
			target: canvasModel
			selector: #exportAs:
			argument: #png;
		add: 'JPEG'
			target: canvasModel
			selector: #exportAs:
			argument: #jpeg;
		add: 'BMP'
			target: canvasModel
			selector: #exportAs:
			argument: #bmp;
		add: 'GIF'
			target: canvasModel
			selector: #exportAs:
			argument: #gif.
	menu addTitle: 'Select picture format'.
	menu popUpInWorld