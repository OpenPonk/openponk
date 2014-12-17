as yet unclassified
iconFor: anObject
	^ (Icons
		at: anObject className asSymbol
		ifAbsent: [ 
			(anObject isKindOf: ElementClass)
				ifTrue: [ ^ Smalltalk ui icons dcOmlBoxIcon ].
			(anObject isKindOf: Relationship)
				ifTrue: [ ^ Smalltalk ui icons dcFsmTransitionIcon ].
			^ nil ]) ifNotNil: [ :selector | Smalltalk ui icons perform: selector ]