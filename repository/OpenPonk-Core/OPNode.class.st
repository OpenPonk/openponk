"
Structural diagram element representing a 2-dimensional node or vertex. 
Manages spatial properties such as position, boundaries, and extent.
"
Class {
	#name : 'OPNode',
	#superclass : 'OPDiagramElement',
	#category : 'OpenPonk-Core-DiagramElements',
	#package : 'OpenPonk-Core',
	#tag : 'DiagramElements'
}

{ #category : 'rendering' }
OPNode >> addedByMouseClickTo: aPoint [

	self translateTo: aPoint
]

{ #category : 'accessing' }
OPNode >> encompassingRectangle [

	^ roassalShape encompassingRectangle
]

{ #category : 'accessing' }
OPNode >> extent [

	^ roassalShape extent
]

{ #category : 'accessing' }
OPNode >> height [

	^ self extent y
]

{ #category : 'testing' }
OPNode >> movesWithOtherShape [

	^ self isRendered not or: [ roassalShape isSelectionDraggable not ]
]

{ #category : 'accessing' }
OPNode >> position [

	^ roassalShape position
]

{ #category : 'rendering' }
OPNode >> renderShapeDetails [

	self flag: 'https://github.com/ObjectProfile/Roassal3/issues/510'.
	roassalShape
		when: RSExtentChangedEvent
		do: [ roassalShape updateConnectedLines ]
		for: self
]

{ #category : 'actions' }
OPNode >> translateBy: deltaAsPoint [

	"Move a shape by a delta value, expressed as a point"

	(roassalShape ifNil: [ ^ self ]) translateBy: deltaAsPoint
]

{ #category : 'actions' }
OPNode >> translateTo: aPoint [

	"Translate a shape to a new position, expressed as a point"

	(roassalShape ifNil: [ ^ self ]) translateTo: aPoint
]

{ #category : 'accessing' }
OPNode >> width [

	^ self extent x
]
