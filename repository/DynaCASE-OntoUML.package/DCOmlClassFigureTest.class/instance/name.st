as yet unclassified
name
	^ figure hasStereotype
		ifTrue: [ figure figures second ]
		ifFalse: [ figure figures first ]