building widgets
dynamicLayout
	| keys |
	keys := self widgets keys.
	^ SpecRowLayout composed
		newColumn: [ :c | 
			keys do: [ :key | c newRow: key height: self class buttonHeight ].
			c newRow: [ :r |  ] ];
		yourself