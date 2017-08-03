specs
defaultSpec
	^ SpecRowLayout composed
		newColumn: [ :c | c newRow: [ :r |  ] ];
		yourself