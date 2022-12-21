Class {
	#name : #OPRSSelectionDraggable,
	#superclass : #RSDraggable,
	#category : #'OpenPonk-Roassal3'
}

{ #category : #'instance creation' }
OPRSSelectionDraggable class >> wantsUniqueInstance [

	^ false
]

{ #category : #hooks }
OPRSSelectionDraggable >> onShape: aShape [

	super onShape: aShape.
	aShape propertyAt: self class put: self
]

{ #category : #events }
OPRSSelectionDraggable >> processDrag: evt [

	| d selectedShapes shapesToMove |
	d := evt camera distanceFromPixelToSpace: evt step.
	selectedShapes := evt canvas selectedShapes ifEmpty: [ { evt shape } ].
	shapesToMove := (selectedShapes includes: evt shape)
		                ifTrue: [ 
		                selectedShapes select: [ :each | 
			                each hasProperty: self class ] ]
		                ifFalse: [ { evt shape } ].
	shapesToMove do: [ :each | self translateShape: each by: d ].
	evt signalUpdate
]

{ #category : #events }
OPRSSelectionDraggable >> translateShape: aShape by: aPoint [

	| shapeEncompassingRectangle draggableNodesInside |
	aShape translateBy: aPoint.
	shapeEncompassingRectangle := aShape encompassingRectangle.
	draggableNodesInside := aShape canvas nodes select: [ :each | 
		                        each isFixed not and: [ 
			                        (shapeEncompassingRectangle containsRect:
				                         each encompassingRectangle) and: [ 
				                        shapeEncompassingRectangle
				                        ~= each encompassingRectangle and: [ 
					                        each isSelectionDraggable ] ] ] ].
	draggableNodesInside
		reject: #isSelected
		thenDo: [ :each | self translateShape: each by: aPoint ]
]
