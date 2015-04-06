as yet unclassified
iconFor: anObject
	| symbol |
	symbol := anObject className asSymbol.
	^ (Icons
		at: symbol
		ifAbsent: [ 
			(anObject isKindOf: ElementClass)
				ifTrue: [ ^ Smalltalk ui icons dcOmlBoxIcon ].
			(anObject isKindOf: Relationship)
				ifTrue: [ ^ Smalltalk ui icons dcFsmTransitionIcon ].
			(symbol beginsWith: #Borm)
				ifTrue: [ ^ #BormEditorIcons asClass current perform: ((symbol copyFrom: 5 to: symbol size) uncapitalized , '16Icon') asSymbol ].
			^ nil ]) ifNotNil: [ :selector | Smalltalk ui icons perform: selector ]