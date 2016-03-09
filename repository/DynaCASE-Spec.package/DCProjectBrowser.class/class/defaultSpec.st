specs
defaultSpec
	^ SpecLayout composed
		newRow:
				[ :row | 
			row
				newColumn:
						[ :col | 
					col
						add: #recentLabel height: self buttonHeight;
						add: #recentList ];
				newColumn:
						[ :col | 
					col add: #quickStartLabel height: self buttonHeight.
					col add: #projectNameInput height: self buttonHeight.
					self addDiagramButtons: col.
					col add: #createProjectButton height: self buttonHeight.
					col add: #openProjectButton height: self buttonHeight.
					col newRow: [ :r |  ] ] ];
		yourself