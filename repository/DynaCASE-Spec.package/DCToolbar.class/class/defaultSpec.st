specs
defaultSpec
	^ SpecLayout composed
		newRow: [ :row | row add: #menuModel ];
		yourself