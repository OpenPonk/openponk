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
							height: self toolbarHeight - 1 ]
					origin: 0 @ 0
					corner: 0.8 @ 1;
				addSplitter;
				newColumn: [ :col | col add: #paletteModel ] origin: 0.8 @ 0 corner: 1 @ 1 ];
		yourself