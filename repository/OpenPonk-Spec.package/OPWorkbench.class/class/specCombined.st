specs
specCombined
	<spec: #combined>
	^ SpecLayout composed
		newRow: [ :row | row newColumn: [ :col | col add: #topToolbar height: self toolbarHeight ] ]
			height: self toolbarHeight;
		newRow: [ :row | 
			row
				newColumn: [ :col | 
					col
						add: #diagramWidget height: 200;
						add: #modelTree ]
					width: 200;
				addSplitter;
				newColumn: [ :col | col add: #tabManager ] ]
			top: self toolbarHeight;
		yourself