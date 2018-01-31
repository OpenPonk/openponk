building widgets
dynamicLayout
	| keys |
	keys := self widgets keys.
	^ SpecRowLayout composed
		newColumn: [ :c | 
			c add: #heading height: self class toolbarHeight.
			keys do: [ :key | c newRow: key height: self class buttonHeight ].
			c newRow: [ :r |  ] ];
		yourself