specs
defaultSpec
	^ SpecLayout composed
		newColumn: [ :c | 
					c
						add: #nameLabel;
						newRow: [ :row | 
									row
										add: #initialButton;
										add: #forkButton ] ];
		yourself