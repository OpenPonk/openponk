private
shapeOf: aVertex
	| shape |
	shape := nil.
	(aVertex isMemberOf: DCSmFinalState)
		ifTrue: [ shape := 'doublecircle' ].
	(aVertex isMemberOf: DCSmPseudostate)
		ifTrue: [ shape := self shapeOfPseudostate: aVertex ].
	^ shape