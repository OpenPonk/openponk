specs
defaultSpec
	^ SpecLayout composed
		newRow: [ :row | 
					row
						newColumn: [ :col | 
									col
										add: #canvasModel origin: 0 @ 0 corner: 1 @ 0.8;
										addSplitter;
										add: #textEditorModel origin: 0 @ 0.8 corner: 1 @ 1 ]
							origin: 0 @ 0
							corner: 0.8 @ 1;
						addSplitter;
						newColumn: [ :col | col add: #paletteModel ] origin: 0.8 @ 0 corner: 1 @ 1 ];
		yourself