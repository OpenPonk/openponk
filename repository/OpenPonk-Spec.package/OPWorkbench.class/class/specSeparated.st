specs
specSeparated
	<spec: #separated>
	<useEditorForm>
	^ SpecLayout composed
		newRow: [ :row | row newColumn: [ :col | col add: #topToolbar height: self toolbarHeight ] ]
			height: self toolbarHeight;
		newRow: [ :row | 
			row
				newColumn: [ :col | 
					col
						add: #diagramWidget;
						add: #navigatorModel ]
					width: 200;
				addSplitter;
				newColumn: [ :col | col add: #tabManager ];
				addSplitter;
				newColumn: [ :col | col add: #formModel ] width: 150 ]
			top: self toolbarHeight;
		yourself