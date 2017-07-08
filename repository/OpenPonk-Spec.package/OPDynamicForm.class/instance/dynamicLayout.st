private - building widgets
dynamicLayout
	| keys height |
	keys := self widgets keys.
	^ SpecLayout composed
		newColumn: [ :c | 
			keys
				do: [ :key | 
					height := self heightFor: (self perform: key).
					"	((self perform: key) isKindOf: DCSelectEntity)
						ifTrue: [ c newRow: [ :row | row add: key withSpec: #specLayout ] height: height ]"
					"	ifFalse: ["
					height ifNil: [ c add: key ] ifNotNil: [ "]" c add: key height: height ] ].
			c newRow: [ :r | "last row is emtpy to take up all the remaining available space" ] ];
		yourself