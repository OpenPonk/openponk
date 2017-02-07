as yet unclassified
newCornerAt: aPosition
	| cornerPosition corner |
	cornerPosition := DoubleLink value: aPosition.
	corner := OPRTOrthoCornerHandle positionLink: cornerPosition edge: edge.
	self hasSuccessor
		ifTrue: [ positionLink addSuccessor: cornerPosition.
			self addSuccessor: corner ]
		ifFalse: [ positionLink addPredecessor: cornerPosition.
			self addPredecessor: corner ].
	element ifNotNil: [ corner renderIn: edge view ].
	edge update.
	edge signalUpdate