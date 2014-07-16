specs
defaultSpec
	^ SpecLayout composed
		newColumn: [ :c | c add: #nameLabel ];
		yourself