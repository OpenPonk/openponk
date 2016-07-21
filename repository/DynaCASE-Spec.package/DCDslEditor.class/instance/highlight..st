accessing - spec
highlight: aText
	| tokens |
	highlighter ifNil: [ ^ aText ].
	tokens := (highlighter parse: aText) flattened.
	tokens flattened
		select: [ :each | each isKindOf: Association ]
		thenDo: [ :each | 
			((each key isKindOf: Association) and: [ each value isKindOf: Association ])
				ifTrue: [ aText makeColor: each key value from: each key key start to: each key key stop.
					aText makeColor: each value value from: each value key start to: each value key stop ]
				ifFalse: [ aText makeColor: each value from: each key start to: each key stop ] ]