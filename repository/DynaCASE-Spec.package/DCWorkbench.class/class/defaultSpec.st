specs
defaultSpec
	^ SpecLayout composed
		newRow: [ :row | row newColumn: [ :col | col add: #topMenuModel height: self toolbarHeight ] ]
			height: self toolbarHeight;
		newRow: [ :row | 
					row
						newColumn: [ :col | col add: #navigatorModel ] origin: 0 @ 0 corner: 0.2 @ 1;
						addSplitter;
						newColumn: [ :col | col add: #editorModel ] origin: 0.2 @ 0 corner: 0.8 @ 1;
						addSplitter;
						newColumn: [ :col | col add: #formModel ] origin: 0.8 @ 0 corner: 1 @ 1 ]
			top: self toolbarHeight;
		yourself