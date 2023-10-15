Class {
	#name : #OPEdgeLabel,
	#superclass : #OPLabel,
	#category : #'OpenPonk-Core-DiagramInterchange'
}

{ #category : #adding }
OPEdgeLabel >> anchorToEdge [

	OPRSAnchorConstraint new
		minDistanceToLine: self defaultMinDistance;
		positionReference: self defaultAnchorConstraintPosition;
		stick: roassalShape on: self owningElement roassalShape
]

{ #category : #adding }
OPEdgeLabel >> defaultAnchorConstraintPosition [

	^ self subclassResponsibility
]

{ #category : #adding }
OPEdgeLabel >> defaultMinDistance [

	^ self subclassResponsibility
]

{ #category : #adding }
OPEdgeLabel >> renderShapeDetails [

	super renderShapeDetails.
	self anchorToEdge
]

{ #category : #interactions }
OPEdgeLabel >> shouldBePositionableByUser [

	^ true
]

{ #category : #'as yet unclassified' }
OPEdgeLabel >> updateFromRender [

	self bounds: (OPDIBounds
			 withPosition: roassalShape position
			 extent: roassalShape extent).
	super updateFromRender
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
