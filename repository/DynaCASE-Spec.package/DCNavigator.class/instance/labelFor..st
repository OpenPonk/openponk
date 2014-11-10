private
labelFor: anObject
	(anObject isKindOf: DCNamedElement) | (anObject isKindOf: DCDiagram)
		ifTrue: [ ^ anObject name , ' (' , anObject class name , ')' ].
	^ anObject