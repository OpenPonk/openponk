Class {
	#name : #OPRSSelectionDraggable,
	#superclass : #RSDraggable,
	#instVars : [
		'draggedShapes',
		'allowedInnerShapesBlock'
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
OPRSSelectionDraggable class >> thatDragsInnerShapesProvidedBy: aBlock [

	^ self new
		  allowedInnerShapesBlock: aBlock;
		  yourself
]

{ #category : #'instance creation' }
OPRSSelectionDraggable class >> wantsUniqueInstance [

	^ false
]

{ #category : #initialization }
OPRSSelectionDraggable >> allowedInnerShapesBlock: aBlock [

	"When a shape is dragged, move also all other selected shapes, plus shapes returned by this block that meet all following conditions: 
	- has not the same position and extent as the 'container' shape itself
	- is actually positioned fully inside the 'container' shape
	- is not selected along with the 'container' (because it is then moved separately)
	- is not fixed
	- have SelectionDraggable interaction"

	allowedInnerShapesBlock := aBlock
]

{ #category : #initialization }
OPRSSelectionDraggable >> doNotDragInnerShapes [

	"when dragged, do not drag any shapes inside me"

	self allowedInnerShapesBlock: [ :allNodes :outerShape | #(  ) ]
]

{ #category : #initialization }
OPRSSelectionDraggable >> dragAllInnerShapes [

	"when dragged, drag also all shapes inside me that have also SelectionDraggable - default behavior"

	self allowedInnerShapesBlock: [ :allNodes :outerShape | allNodes ]
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
OPRSSelectionDraggable >> shapesToDragInside: aContainerShape [

	"When a shape is dragged, move also all other selected shapes, plus shapes returned by allowedInnerShapesBlock that meet all following conditions: 
	- has not the same position and extent as the 'container' shape itself
	- is actually positioned fully inside the 'container' shape
	- is not selected along with the 'container' (because it is then moved separately)
	- is not fixed
	- have SelectionDraggable interaction"

	| shapeEncompassingRectangle |
	shapeEncompassingRectangle := aContainerShape encompassingRectangle.

	^ ((allowedInnerShapesBlock
		    cull: aContainerShape canvas nodes
		    cull: aContainerShape) select: [ :each | 
		   each isFixed not and: [ 
			   (aContainerShape isSelected not or: [ each isSelected not ]) 
				   and: [ 
					   (shapeEncompassingRectangle containsRect:
						    each encompassingRectangle) and: [ 
						   shapeEncompassingRectangle ~= each encompassingRectangle ] ] ] ]) 
		  flatCollectAsSet: [ :each | 
			  each
				  propertyAt: self propertyKey
				  ifPresent: [ :innerInteraction | 
					  (Set with: each) , (innerInteraction shapesToDragInside: each) ]
				  ifAbsent: [ Set empty ] ]
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

	draggedShapes := selectedShapesToMove flatCollectAsSet: [ 
		                 :eachSelectedShape | 
		                 (Set with: eachSelectedShape)
		                 , (self shapesToDragInside: eachSelectedShape) ].

	event := OPRSDragFromSelectionStart fromEvent: anEvent.
	event
		position: anEvent position;
		morph: anEvent morph.
	(draggedShapes copyWithout: anEvent shape) do: [ :each | 
		each announce: event ]
]
