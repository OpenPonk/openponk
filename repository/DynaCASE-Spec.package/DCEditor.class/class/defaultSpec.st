specs
defaultSpec
	^ SpecLayout composed
		newRow:
			[ :row | 
			row
				newColumn: [ :col | col add: #treeModel top: 0.0 bottom: 0.05 ] origin: 0 @ 0 corner: 0.15 @ 1;
				addSplitter;
				newColumn: [ :col | 
							col
								add: #roassalModel origin: 0 @ 0 corner: 1 @ 0.8;
								addSplitter;
								add: #textEditorModel origin: 0 @ 0.8 corner: 1 @ 0.95;
								add: #statusModel origin: 0 @ 0.95 corner: 1 @ 1 ]
					origin: 0.15 @ 0
					corner: 0.8 @ 1;
				addSplitter;
				newColumn: [ :col | 
							col
								add: #paletteModel;
								addSplitter;
								add: #formModel ]
					origin: 0.8 @ 0
					corner: 1 @ 1 ] yourself