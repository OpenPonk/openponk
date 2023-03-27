Class {
	#name : #OPEdgeLabel,
	#superclass : #OPLabel,
	#category : #'OpenPonk-Core-DiagramInterchange'
}

{ #category : #adding }
OPEdgeLabel >> addInteractions [

	roassalShape @ RSDraggable
]

{ #category : #adding }
OPEdgeLabel >> anchorToEdge [

	OPRSAnchorConstraint new
		minDistance: self defaultMinDistance;
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

	self addInteractions.
	self anchorToEdge
]

{ #category : #'as yet unclassified' }
OPEdgeLabel >> updateFromRender [

	OPWorkbench isDevelopmentMode ifFalse: [ 
		^ self ownedElements do: #updateFromRender ].
	
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
