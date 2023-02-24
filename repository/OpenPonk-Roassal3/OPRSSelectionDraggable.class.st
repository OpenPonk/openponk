Class {
	#name : #OPRSSelectionDraggable,
	#superclass : #RSDraggable,
	#instVars : [
		'draggedShapes',
		'shouldDragInnerShapeBlock'
	],
	#category : #'OpenPonk-Roassal3-Interactions'
}

{ #category : #'instance creation' }
OPRSSelectionDraggable class >> thatDoesNotDragInnerShapes [

	^ self new
		  doNotDragInnerShapes;
		  yourself
]

{ #category : #'instance creation' }
OPRSSelectionDraggable class >> thatDragsAllInnerShapes [

	"default behavior"

	^ self new
]

{ #category : #'instance creation' }
OPRSSelectionDraggable class >> thatDragsInnerShapesOnCondition: aBlock [

	^ self new
		  shouldDragInnerShapesBlock: aBlock;
		  yourself
]

{ #category : #'instance creation' }
OPRSSelectionDraggable class >> wantsUniqueInstance [

	^ false
]

{ #category : #initialization }
OPRSSelectionDraggable >> doNotDragInnerShapes [

	"when dragged, do not drag any shapes inside me"

	self shouldDragInnerShapesBlock: [ :innerShape | false ]
]

{ #category : #initialization }
OPRSSelectionDraggable >> dragAllInnerShapes [

	"when dragged, drag also all shapes inside me that have also SelectionDraggable - default behavior"

	self shouldDragInnerShapesBlock: [ :innerShape | true ]
]

{ #category : #events }
OPRSSelectionDraggable >> endDrag: anEvent [

	| event |
	event := OPRSDragFromSelectionEnd fromEvent: anEvent.
	event
		position: anEvent position;
		morph: anEvent morph.
	(draggedShapes copyWithout: anEvent shape) do: [ :each | 
		each announce: event ].

	draggedShapes := #(  )
]

{ #category : #initialization }
OPRSSelectionDraggable >> initialize [

	super initialize.
	self dragAllInnerShapes
]

{ #category : #hooks }
OPRSSelectionDraggable >> onShape: aShape [

	super onShape: aShape.
	aShape when: RSMouseDragStart do: [ :event | self startDrag: event ].
	aShape when: RSMouseDragEnd do: [ :event | self endDrag: event ].
	aShape propertyAt: self propertyKey put: self
]

{ #category : #events }
OPRSSelectionDraggable >> processDrag: evt [

	| d |
	d := evt camera distanceFromPixelToSpace: evt step.
	draggedShapes do: [ :each | each translateBy: d ].
	evt signalUpdate
]

{ #category : #'accessing - keys' }
OPRSSelectionDraggable >> propertyKey [

	^ OPRSSelectionDraggable
]

{ #category : #events }
OPRSSelectionDraggable >> shapesToDragInside: aShape [

	| shapeEncompassingRectangle |
	shapeEncompassingRectangle := aShape encompassingRectangle.
	^ aShape canvas nodes select: [ :each | 
		  (shouldDragInnerShapeBlock value: each) and: [ 
			  each isSelected not and: [ 
				  each isFixed not and: [ 
					  (shapeEncompassingRectangle containsRect:
						   each encompassingRectangle) and: [ 
						  shapeEncompassingRectangle ~= each encompassingRectangle and: [ 
							  each isSelectionDraggable ] ] ] ] ] ]
]

{ #category : #initialization }
OPRSSelectionDraggable >> shouldDragInnerShapesBlock: aBlock [

	"when dragged, drag also all shapes inside me that have also SelectionDraggable and the block returns true when given the inner shape"

	shouldDragInnerShapeBlock := aBlock
]

{ #category : #events }
OPRSSelectionDraggable >> startDrag: anEvent [

	| selectedShapes selectedShapesToMove event |
	selectedShapes := anEvent canvas selectedShapes ifEmpty: [ 
		                  { anEvent shape } ].
	selectedShapesToMove := (selectedShapes includes: anEvent shape)
		                        ifTrue: [ 
			                        selectedShapes select: [ :each | 
				                        each hasProperty: self propertyKey ] ]
		                        ifFalse: [ { anEvent shape } ].

	draggedShapes := selectedShapesToMove flatCollect: [ 
		                 :eachSelectedShape | 
		                 { eachSelectedShape }
		                 , (self shapesToDragInside: eachSelectedShape) ].

	event := OPRSDragFromSelectionStart fromEvent: anEvent.
	event
		position: anEvent position;
		morph: anEvent morph.
	(draggedShapes copyWithout: anEvent shape) do: [ :each | 
		each announce: event ]
]
