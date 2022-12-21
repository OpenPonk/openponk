Class {
	#name : #OPEdgeLabel,
	#superclass : #OPLabel,
	#category : #'OpenPonk-Core-DiagramInterchange'
}

{ #category : #'as yet unclassified' }
OPEdgeLabel >> anchorToEdge [

	roassalShape @ RSDraggable.
	OPRSAnchorConstraint new
		balance: self defaultBalance;
		minDistance: self defaultMinDistance;
		stick: roassalShape on: self owningElement roassalShape
]

{ #category : #'as yet unclassified' }
OPEdgeLabel >> defaultBalance [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
OPEdgeLabel >> defaultMinDistance [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
OPEdgeLabel >> renderShapeDetails [

	self anchorToEdge
]

{ #category : #rendering }
OPEdgeLabel >> updateRenderFromModel [

	roassalShape
		text: self text;
		signalUpdate.

	(roassalShape propertyAt: OPRSAnchorConstraint) moveShape
]

{ #category : #roassal }
OPEdgeLabel >> updateRenderFromSelf [

	self isRendered ifFalse: [ ^ self ].
	super updateRenderFromSelf.
	bounds ifNil: [ ^ self ].
	(roassalShape propertyAt: OPRSAnchorConstraint) saveShapePosition
]
