building widgets
dynamicLayout
	| keys |
	keys := self widgets keys.
	^ (SpecLayout composed)
		newColumn: [ :c | 
					keys do: [ :key | c newRow: key height: (self perform: key) height ].
					c newRow: [ :r |  ] ];
		yourself