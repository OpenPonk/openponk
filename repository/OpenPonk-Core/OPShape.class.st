Class {
	#name : #OPShape,
	#superclass : #OPDiagramElement,
	#traits : 'RSTPositionable',
	#classTraits : 'RSTPositionable classTrait',
	#instVars : [
		'bounds'
	],
	#category : #'OpenPonk-Core-DiagramInterchange'
}

{ #category : #accessing }
OPShape >> bounds [

	^ bounds
]

{ #category : #accessing }
OPShape >> bounds: anObject [

	bounds := anObject
]

{ #category : #accessing }
OPShape >> encompassingRectangle [

	^ roassalShape encompassingRectangle
]

{ #category : #accessing }
OPShape >> extent [

	^ roassalShape extent
]

{ #category : #accessing }
OPShape >> height [

	^ roassalShape height
]

{ #category : #accessing }
OPShape >> position [

	^ roassalShape position
]

{ #category : #actions }
OPShape >> translateBy: deltaAsPoint [

	"Move a shape by a delta value, expressed as a point"

	roassalShape translateBy: deltaAsPoint
]

{ #category : #actions }
OPShape >> translateTo: aPoint [

	"Translate a shape to a new position, expressed as a point"

	roassalShape translateTo: aPoint
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

{ #category : #accessing }
OPShape >> width [

	^ roassalShape width
]
