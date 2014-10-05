building widgets
dynamicLayout
	| keys height |
	keys := self widgets keys.
	^ SpecLayout composed
		newColumn: [ :c | 
					keys
						do: [ :key | 
							height := self heightFor: (self perform: key).
							c newRow: key height: height ].
					c newRow: [ :r |  ]	"last row is emtpy to take up all the remaining available space" ];
		yourself