private
childrenFor: anObject
	| col |
	col := OrderedCollection new.
	(anObject isKindOf: DCDiagram)
		ifTrue: [ col addAll: anObject elements ].
	(anObject isKindOf: DCNamedElement)
		ifTrue: [ 
			"responsibility of subclasses"
			 ].
	^ col