Class {
	#name : #OPRSSelectionDraggable,
	#superclass : #RSDraggable,
	#instVars : [
		'draggedShapes'
	],
	#category : #'OpenPonk-Roassal3-Interactions'
}

{ #category : #'instance creation' }
OPRSSelectionDraggable class >> wantsUniqueInstance [

	^ false
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
		  each isSelected not and: [ 
			  each isFixed not and: [ 
				  (shapeEncompassingRectangle containsRect:
					   each encompassingRectangle) and: [ 
					  shapeEncompassingRectangle ~= each encompassingRectangle and: [ 
						  each isSelectionDraggable ] ] ] ] ]
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
