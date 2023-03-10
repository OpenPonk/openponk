Class {
	#name : #OPRSSelectionDraggable,
	#superclass : #RSDraggable,
	#instVars : [
		'draggedShapes',
		'innerShapesProvider'
	],
	#category : #'OpenPonk-Roassal3-Interactions'
}

{ #category : #'instance creation' }
OPRSSelectionDraggable class >> thatAlsoDragsContainedShapes [

	^ self new
		  dragAlsoContainedShapes;
		  yourself
]

{ #category : #'instance creation' }
OPRSSelectionDraggable class >> thatAlsoDragsShapesProvidedByBlock: aBlock [

	^ self new
		  dragAlsoShapesProvidedByBlock: aBlock;
		  yourself
]

{ #category : #'instance creation' }
OPRSSelectionDraggable class >> thatAlsoDragsSmallerOverlappingShapes [

	^ self new
		  dragAlsoSmallerOverlappingShapes;
		  yourself
]

{ #category : #'instance creation' }
OPRSSelectionDraggable class >> thatDoesNotDragAnyInnerShapes [

	"default"

	^ self new
]

{ #category : #'instance creation' }
OPRSSelectionDraggable class >> wantsUniqueInstance [

	^ false
]

{ #category : #'inner shapes' }
OPRSSelectionDraggable >> dragAlsoContainedShapes [

	self innerShapesProvider: OPRSSelectionDraggableContainedShapesProvider new
]

{ #category : #'inner shapes' }
OPRSSelectionDraggable >> dragAlsoShapesProvidedByBlock: aBlock [

	"When a shape is dragged, move also all other selected shapes, plus shapes that meet all following conditions: 
	- is returned by innerShapesProvider
	- is not selected along with the 'container' (because it is then moved separately)
	- have SelectionDraggable interaction"

	self innerShapesProvider:
		(OPRSSelectionDraggableCustomShapesProvider withBlock: aBlock)
]

{ #category : #'inner shapes' }
OPRSSelectionDraggable >> dragAlsoSmallerOverlappingShapes [

	self innerShapesProvider: OPRSSelectionDraggableSmallerOverlappingShapesProvider new
]

{ #category : #'inner shapes' }
OPRSSelectionDraggable >> dragNoInnerShapes [

	self innerShapesProvider: OPRSSelectionDraggableNoInnerShapesProvider new
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
	self dragNoInnerShapes
]

{ #category : #accessing }
OPRSSelectionDraggable >> innerShapesProvider: anInnerShapesProvider [

	innerShapesProvider := anInnerShapesProvider
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
	draggedShapes ifNil: [ ^ self ].
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

	"When a shape is dragged, move also all other selected shapes, plus shapes that meet all following conditions: 
	- is returned by innerShapesProvider
	- is not selected along with the 'container' (because it is then moved separately)
	- have SelectionDraggable interaction"

	^ ((innerShapesProvider innerShapesFor: aContainerShape) select: [ 
		   :each | 
		   aContainerShape isSelected not or: [ each isSelected not ] ]) 
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
	selectedShapesToMove := OPWorkbench isDevelopmentMode
		                        ifTrue: [ 
			                        (selectedShapes includes: anEvent shape)
				                        ifTrue: [ 
					                        selectedShapes select: [ :each | 
						                        each hasProperty: self propertyKey ] ]
				                        ifFalse: [ { anEvent shape } ] ]
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
