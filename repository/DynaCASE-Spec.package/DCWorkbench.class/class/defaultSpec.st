specs
defaultSpec
	^ SpecLayout composed
		newRow: [ :row | row newColumn: [ :col | col add: #topToolbar height: self toolbarHeight ] ]
			height: self toolbarHeight;
		newRow: [ :row | 
					row
						newColumn: [ :col | col add: #navigatorModel ] origin: 0 @ 0 corner: 0.2 @ 1;
						addSplitter;
						newColumn: [ :col | col add: #tabManager ] origin: 0.2 @ 0 corner: 0.85 @ 1;
						addSplitter;
						newColumn: [ :col | col add: #formModel ] origin: 0.85 @ 0 corner: 1 @ 1 ]
			top: self toolbarHeight;
		yourself