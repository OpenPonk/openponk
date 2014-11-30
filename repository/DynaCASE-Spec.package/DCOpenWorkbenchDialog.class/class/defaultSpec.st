specs
defaultSpec
	^ SpecLayout composed
		newRow: [ :row | 
					row
						newColumn: [ :col | 
									col
										add: #recentProjectsLabel height: self buttonHeight;
										add: #recentProjectsList ];
						newColumn: [ :col | 
									col
										add: #quickStartLabel height: self buttonHeight;
										add: #newProjectButton height: self buttonHeight;
										add: #openFromFileButton height: self buttonHeight;
										newRow: [ :r |  ] ] ];
		yourself