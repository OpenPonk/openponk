as yet unclassified
iconFor: anObject
	| symbol |
	symbol := anObject className asSymbol.
	((anObject isKindOf: DCFsmState) and: [ anObject isFinal ])
		ifTrue: [ ^ Smalltalk ui icons dcFsmFinalStateIcon ].
	^ (Icons
		at: symbol
		ifAbsent: [ 
			(anObject isKindOf: ElementClass)
				ifTrue: [ ^ Smalltalk ui icons dcOmlBoxIcon ].
			(anObject isKindOf: Relationship)
				ifTrue: [ ^ Smalltalk ui icons dcFsmTransitionIcon ].
			symbol = #DMMindMap
				ifTrue: [ ^ #DMIcons asClass current mindMapIcon ].
			(symbol beginsWith: #Borm)
				ifTrue: [ ^ #BormEditorIcons asClass current perform: ((symbol copyFrom: 5 to: symbol size) uncapitalized , '16Icon') asSymbol ].
			^ nil ]) ifNotNil: [ :selector | Smalltalk ui icons perform: selector ]