Class {
	#name : #OPEdgeLabel,
	#superclass : #OPLabel,
	#category : #'OpenPonk-Core-DiagramInterchange'
}

{ #category : #'as yet unclassified' }
OPEdgeLabel >> anchorToEdge [

	roassalShape @ RSDraggable.
	OPRSAnchorConstraint new
		minDistance: self defaultMinDistance;
		position: self defaultAnchorConstraintPosition;
		stick: roassalShape on: self owningElement roassalShape
]

{ #category : #'as yet unclassified' }
OPEdgeLabel >> defaultAnchorConstraintPosition [

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

	roassalShape text: self defaultText.

	(roassalShape propertyAt: OPRSAnchorConstraint) moveShape.

	super updateRenderFromModel
]

{ #category : #roassal }
OPEdgeLabel >> updateRenderFromSelf [

	self isRendered ifFalse: [ ^ self ].
	super updateRenderFromSelf.
	bounds ifNil: [ ^ self ].
	(roassalShape propertyAt: OPRSAnchorConstraint) saveShapePosition
]
