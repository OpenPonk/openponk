Class {
	#name : #OPNode,
	#superclass : #OPDiagramElement,
	#category : #'OpenPonk-Core-DiagramInterchange'
}

{ #category : #'as yet unclassified' }
OPNode >> addedByMouseClickTo: aPoint [

	self translateTo: aPoint
]

{ #category : #accessing }
OPNode >> encompassingRectangle [

	^ roassalShape encompassingRectangle
]

{ #category : #accessing }
OPNode >> extent [

	^ roassalShape extent
]

{ #category : #accessing }
OPNode >> height [

	^ self extent y
]

{ #category : #testing }
OPNode >> isPositionableByUser [

	^ self isRendered and: [ 
		  self roassalShape hasInteraction: OPRSSelectionDraggable ]
]

{ #category : #accessing }
OPNode >> position [

	^ roassalShape position
]

{ #category : #actions }
OPNode >> translateBy: deltaAsPoint [

	"Move a shape by a delta value, expressed as a point"

	roassalShape translateBy: deltaAsPoint
]

{ #category : #actions }
OPNode >> translateTo: aPoint [

	"Translate a shape to a new position, expressed as a point"

	roassalShape translateTo: aPoint
]

{ #category : #accessing }
OPNode >> width [

	^ self extent x
]
