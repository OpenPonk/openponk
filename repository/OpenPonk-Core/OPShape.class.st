Class {
	#name : #OPShape,
	#superclass : #OPNode,
	#instVars : [
		'bounds'
	],
	#category : #'OpenPonk-Core-DiagramInterchange'
}

{ #category : #'ston-core' }
OPShape class >> stonAllInstVarNames [

	"Override to encode my instances using a custom set of instance variables or to define their order."

	^ super stonAllInstVarNames , #( #bounds )
]

{ #category : #accessing }
OPShape >> bounds [

	^ bounds
]

{ #category : #accessing }
OPShape >> bounds: anObject [

	bounds := anObject
]

{ #category : #'as yet unclassified' }
OPShape >> updateFromRender [

	self bounds: (OPDIBounds
			 withPosition: roassalShape position
			 extent: roassalShape extent).
	super updateFromRender
]

{ #category : #roassal }
OPShape >> updateRenderFromSelf [

	self isRendered ifFalse: [ ^ self ].
	bounds ifNotNil: [ 
		roassalShape
			extent: bounds extent;
			translateTo: bounds position ].
	super updateRenderFromSelf
]
