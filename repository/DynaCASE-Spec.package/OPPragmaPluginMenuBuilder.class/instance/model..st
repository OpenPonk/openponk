as yet unclassified
model: anObject
	super model: anObject.
	(anObject isKindOf: OPCanvasModel)
		ifTrue: [ ^ testBlock := [ :prg | prg arguments first = self model editor plugin className ] ].
	(anObject isKindOf: OPEditor)
		ifTrue: [ ^ testBlock := [ :prg | prg arguments first = self model plugin className ] ].
	self error: 'Unrecognized model'