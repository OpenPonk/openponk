Class {
	#name : #OPRSSelectionDraggable,
	#superclass : #RSDraggable,
	#instVars : [
		'unusedStep',
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

	| dragAttachmentShapeAmount originalDragStep dragStep primaryShapeRectangle primaryShapePosition closestShapes lines attachmentMargin |
	draggedNodes ifNil: [ ^ self ].
	attachmentMargin := 10.
	dragAttachmentShapeAmount := evt altKeyPressed
		                             ifTrue: [ 0 ]
		                             ifFalse: [ 5 ].
	originalDragStep := (evt camera distanceFromPixelToSpace: evt step)
	                    + unusedStep.
	unusedStep := 0 @ 0.
	primaryShapeRectangle := evt shape encompassingRectangle
		                         translateBy: originalDragStep.
	primaryShapePosition := primaryShapeRectangle center.
	closestShapes := SortedCollection new sortBlock:
		                 [ :each |
		                 each position distanceTo: primaryShapePosition ]
			                 ascending.
	evt canvas shapes
		select: [ :each |
			each isSelectionDraggable and: [ (draggedNodes includes: each) not ] ]
		thenDo: [ :each |
			closestShapes add: each.
			closestShapes size > dragAttachmentShapeAmount ifTrue: [
				closestShapes removeLast ] ].
	lines := SortedCollection sortBlock: #adaptationDistance ascending.
	closestShapes
		collect: [ :each |
			primaryShapeRectangle
				bestAlignmentLineTo: each encompassingRectangle
				margin: attachmentMargin ]
		thenDo: [ :each | each ifNotNil: [ lines add: each ] ].
	dragStep := originalDragStep.
	lines ifNotEmpty: [ :all |
		| adaptationLine |
		adaptationLine := all first.
		dragStep := originalDragStep + adaptationLine adaptationOffset.
		unusedStep := adaptationLine adaptationOffset negated ].
	self translateLinesBy: dragStep.
	self translateShapesBy: dragStep.
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
	
	unusedStep := 0@0.

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
		each innerControlPoints:
			(each innerControlPoints collect: [ :eachPoint |
				 eachPoint + anOffset ]) ]
]

{ #category : #events }
OPRSSelectionDraggable >> translateShapesBy: anOffset [

	draggedNodes do: [ :each | each translateBy: anOffset ]
]
