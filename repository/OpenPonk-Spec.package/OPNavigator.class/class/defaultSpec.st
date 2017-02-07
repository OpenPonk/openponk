specs
defaultSpec
	^ SpecLayout composed
		newRow: [ :row | row add: #tree ];
		yourself