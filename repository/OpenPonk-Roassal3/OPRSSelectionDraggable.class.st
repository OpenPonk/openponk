Class {
	#name : #OPRSSelectionDraggable,
	#superclass : #RSDraggable,
	#instVars : [
		'innerShapesProvider',
		'draggedNodes',
		'movedLinesWithControlPoints'
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
	(draggedNodes copyWithout: anEvent shape) do: [ :each | 
		each announce: event ].

	draggedNodes := #(  )
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

{ #category : #events }
OPRSSelectionDraggable >> movedLinesWithControlPointsBy: anEvent [

	^ ((draggedNodes flatCollect: #connectedLines as: Bag)
		   valuesAndCounts associations select: [ :each | each value > 1 ])
		  collect: #key
		  as: Set
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
	draggedNodes ifNil: [ ^ self ].
	d := evt camera distanceFromPixelToSpace: evt step.
	self translateLinesBy: d.
	self translateShapesBy: d.
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

	draggedNodes := selectedShapesToMove flatCollectAsSet: [
		                :eachSelectedShape |
		                (Set with: eachSelectedShape)
		                , (self shapesToDragInside: eachSelectedShape) ].

	movedLinesWithControlPoints := self movedLinesWithControlPointsBy: anEvent.

	event := OPRSDragFromSelectionStart fromEvent: anEvent.
	event
		position: anEvent position;
		morph: anEvent morph.
	(draggedNodes copyWithout: anEvent shape) do: [ :each |
		each announce: event ]
]

{ #category : #events }
OPRSSelectionDraggable >> translateLinesBy: anOffset [

	movedLinesWithControlPoints do: [ :each |
		each controlPoints: { each controlPoints first }
			,
				((each controlPoints copyFrom: 2 to: each controlPoints size - 1)
					 collect: [ :eachPoint | eachPoint + anOffset ])
			, { each controlPoints last } ]
]

{ #category : #events }
OPRSSelectionDraggable >> translateShapesBy: anOffset [

	draggedNodes do: [ :each | each translateBy: anOffset ]
]
