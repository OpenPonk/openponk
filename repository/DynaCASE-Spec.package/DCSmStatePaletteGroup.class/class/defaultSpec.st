specs
defaultSpec
	^ SpecLayout composed
		newColumn: [ :c | 
					c
						add: #nameLabel height: 30;
						newRow: [ :row | 
									row
										add: #stateButton;
										add: #finalStateButton ] ];
		yourself