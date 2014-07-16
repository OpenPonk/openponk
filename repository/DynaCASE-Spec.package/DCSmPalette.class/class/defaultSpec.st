specs
defaultSpec
	^ SpecLayout composed
		newColumn: [ :c | 
					c
						newRow: #pseudostatesGroup;
						newRow: #statesGroup;
						newRow: #transitionsGroup ];
		yourself