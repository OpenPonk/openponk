specs
defaultSpec
	^ SpecLayout composed
		newRow: [ :row | 
			row
				newColumn: [ :col | 
					col
						add: #canvasModel;
						addSplitter;
						newRow: [ :r | 
							r
								add: #canvasMenuModel;
								add: #zoomLabel width: 35 ]
							height: self toolbarHeight - 1 ];
				addSplitter;
				newColumn: [ :col | col add: #paletteModel ] width: 150 ];
		yourself