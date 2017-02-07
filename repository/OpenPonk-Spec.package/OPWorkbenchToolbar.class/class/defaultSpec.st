specs
defaultSpec
	^ SpecLayout composed
		newRow: [ :row | row add: #toolbar ];
		yourself