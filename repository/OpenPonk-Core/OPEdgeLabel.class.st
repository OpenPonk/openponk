"
Specialized label designed to be attached to an OPEdge. 
Manages positioning by calculating anchors and distances relative to the routing path of its parent edge.
"
Class {
	#name : 'OPEdgeLabel',
	#superclass : 'OPLabel',
	#category : 'OpenPonk-Core-DiagramElements',
	#package : 'OpenPonk-Core',
	#tag : 'DiagramElements'
}

{ #category : 'adding' }
OPEdgeLabel >> anchorToEdge [

	OPRSAnchorConstraint new
		minDistanceToLine: self defaultMinDistance;
		positionReference: self defaultAnchorConstraintPosition;
		stick: roassalShape on: self owningElement roassalShape
]

{ #category : 'adding' }
OPEdgeLabel >> defaultAnchorConstraintPosition [

	^ self subclassResponsibility
]

{ #category : 'adding' }
OPEdgeLabel >> defaultMinDistance [

	^ self subclassResponsibility
]

{ #category : 'rendering' }
OPEdgeLabel >> renderShapeDetails [

	super renderShapeDetails.
	self anchorToEdge
]

{ #category : 'initialization' }
OPEdgeLabel >> updateFromRender [

	self bounds: (OPNodeBounds
			 withPosition: roassalShape position
			 extent: roassalShape extent).
	super updateFromRender
]

{ #category : 'rendering' }
OPEdgeLabel >> updateRenderFromModel [

	roassalShape text: self defaultText.

	(roassalShape propertyAt: OPRSAnchorConstraint) moveShape.

	super updateRenderFromModel
]

{ #category : 'rendering' }
OPEdgeLabel >> updateRenderFromSelf [

	self isRendered ifFalse: [ ^ self ].
	super updateRenderFromSelf.
	bounds ifNil: [ ^ self ].
	(roassalShape propertyAt: OPRSAnchorConstraint) saveShapePosition
]
