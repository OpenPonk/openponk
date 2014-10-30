private
labelFor: anObject
	| res |
	res := anObject.
	(anObject isKindOf: DCNamedElement)
		ifTrue: [ res := anObject name , ' (' , anObject class name , ')' ].
	(anObject isKindOf: DCDiagram)
		ifTrue: [ res := anObject name , ' (' , anObject class name , ')' ].
	^ res