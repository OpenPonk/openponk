"
I am a draggable interation that snaps to a grid.
When shift is pressed during the dragging, the snap is disabled.
"
Class {
	#name : #OPRTDraggableSnapToGrid,
	#superclass : #RTAbstractDraggable,
	#instVars : [
		'strategy',
		'gridSize',
		'totalDistance'
	],
	#category : 'OpenPonk-Roassal2-Interactivity'
}

{ #category : #configuration }
OPRTDraggableSnapToGrid >> center [
	strategy := #center
]

{ #category : #accessing }
OPRTDraggableSnapToGrid >> defaultGridSize [
	^ 10
]

{ #category : #accessing }
OPRTDraggableSnapToGrid >> gridSize [
	^ gridSize ifNil: [ gridSize := self defaultGridSize ]
]

{ #category : #accessing }
OPRTDraggableSnapToGrid >> gridSize: anInteger [
	gridSize := anInteger
]

{ #category : #accessing }
OPRTDraggableSnapToGrid >> gridSizeFor: anElement [
	anElement view
		ifNotNil: [ :v | 
			(v hasAttribute: #RTGridView)
				ifTrue: [ ^ (v attributeAt: #RTGridView) gridSize ] ].
	^ self gridSize
]

{ #category : #initialization }
OPRTDraggableSnapToGrid >> groupToDragFor: aView [
	^ aView attributes at: OPRTSelectableView ifAbsent: [ RTGroup new ]
]

{ #category : #initialization }
OPRTDraggableSnapToGrid >> initialize [
	super initialize.
	self topLeft
]

{ #category : #hooks }
OPRTDraggableSnapToGrid >> initializeElement: element [
	element when: TRMouseDragStart do: [ :event | totalDistance := 0 @ 0 ].
	element
		when: TRMouseDragging
		do: [ :e | 
			| d t |
			t := RTGroup withAll: (self groupToDragFor: element view).
			(t includes: element)
				ifFalse: [ t add: element ].
			d := element view canvas camera distanceFromPixelToSpace: e step.
			t translateBy: (self transformDistance: d forElement: element).
			self constraintIfNecessary: element.
			e signalUpdate ]
]

{ #category : #testing }
OPRTDraggableSnapToGrid >> isSnapDisabled [
	^ World activeHand shiftPressed
]

{ #category : #configuration }
OPRTDraggableSnapToGrid >> topLeft [
	strategy := #topLeft
]

{ #category : #hooks }
OPRTDraggableSnapToGrid >> transformDistance: distanceAsPoint forElement: anElement [
	| d spacing referencePoint |
	spacing := self gridSizeFor: anElement.
	self isSnapDisabled
		ifTrue: [ ^ distanceAsPoint ].
	referencePoint := strategy value: anElement encompassingRectangle.
	d := distanceAsPoint.
	d := d + referencePoint.
	totalDistance := totalDistance + d.
	d := spacing
		* ((totalDistance x / spacing) rounded @ (totalDistance y / spacing) rounded).
	totalDistance := totalDistance - d.
	d := d - referencePoint.
	^ d
]
