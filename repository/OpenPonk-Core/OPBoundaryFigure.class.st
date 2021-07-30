Class {
	#name : #OPBoundaryFigure,
	#superclass : #OPResizableFigureWithText,
	#instVars : [
		'dragBoxes',
		'positionOfMainRelativeToDragBoxes',
		'dragBoxesByPosition',
		'dragBoxUpdateBlocks'
	],
	#category : #'OpenPonk-Core-CommonElements'
}

{ #category : #accessing }
OPBoundaryFigure >> baseShape [
	| box |
	box := RTBox new
		color: Color transparent;
		borderColor: Color gray;
		width: self defaultWidth;
		height: self defaultHeight;
		yourself.
	box borderStyle dash.
	^ box
]

{ #category : #'creating - subelements' }
OPBoundaryFigure >> createOwnedElements [
	| horizonalBoxShape verticalBoxShape |
	super createOwnedElements.
	horizonalBoxShape := RTBox new
		color: Color transparent;
		borderColor: Color transparent;
		width: self defaultWidth;
		height: 2 * self draggableOffset;
		yourself.
	verticalBoxShape := RTBox new
		color: Color transparent;
		borderColor: Color transparent;
		width: 2 * self draggableOffset;
		height: self defaultHeight;
		yourself.
	dragBoxes := {(horizonalBoxShape elementOn: #top).
	(horizonalBoxShape elementOn: #bottom).
	(verticalBoxShape elementOn: #left).
	(verticalBoxShape elementOn: #right)} asGroup.
	dragBoxesByPosition := (dragBoxes
		collect: [ :each | each model -> each ]) asDictionary.
	self addAll: dragBoxes.
	dragBoxes
		do: [ :each | 
			each
				addInteraction: OPRTDraggableSnapToGrid;
				addCallback: (TRTranslationCallback block: [ self updateAfterDragOf: each ]) ].
	self addCallback: (TRExtentCallback block: [ self updateDragBoxes ]).
	self
		addCallback: (TRTranslationCallback block: [ self updateDragBoxes ])
]

{ #category : #accessing }
OPBoundaryFigure >> defaultHeight [
	^ 400
]

{ #category : #accessing }
OPBoundaryFigure >> defaultWidth [
	^ 500
]

{ #category : #'as yet unclassified' }
OPBoundaryFigure >> dragBoxUpdateBlocks [
	^ dragBoxUpdateBlocks
		ifNil: [ | topDragBox bottomDragBox leftDragBox rightDragBox |
			topDragBox := dragBoxesByPosition at: #top.
			bottomDragBox := dragBoxesByPosition at: #bottom.
			leftDragBox := dragBoxesByPosition at: #left.
			rightDragBox := dragBoxesByPosition at: #right.
			dragBoxUpdateBlocks := {(#top
				-> [ topDragBox trachelShape
						doWithoutCallbacks: [ topDragBox
								width: self width;
								translateTo: self encompassingRectangle topCenter ] ]).
			(#bottom
				-> [ bottomDragBox trachelShape
						doWithoutCallbacks: [ bottomDragBox
								width: self width;
								translateTo: self encompassingRectangle bottomCenter ] ]).
			(#left
				-> [ leftDragBox trachelShape
						doWithoutCallbacks: [ leftDragBox
								height: self height;
								translateTo: self encompassingRectangle leftCenter ] ]).
			(#right
				-> [ rightDragBox trachelShape
						doWithoutCallbacks: [ rightDragBox
								height: self height;
								translateTo: self encompassingRectangle rightCenter ] ])}
				asDictionary ]
]

{ #category : #accessing }
OPBoundaryFigure >> draggableOffset [
	^ 5
]

{ #category : #hooks }
OPBoundaryFigure >> modelTextSelector [
	^ #name
]

{ #category : #'as yet unclassified' }
OPBoundaryFigure >> positionOfMainRelativeToDragBoxes [
	^ positionOfMainRelativeToDragBoxes
		ifNil: [ positionOfMainRelativeToDragBoxes := {(#top
				-> [ (dragBoxesByPosition at: #top) position + (0 @ (self height / 2)) ]).
			(#bottom
				-> [ (dragBoxesByPosition at: #bottom) position - (0 @ (self height / 2)) ]).
			(#left
				-> [ (dragBoxesByPosition at: #left) position + ((self width / 2) @ 0) ]).
			(#right
				-> [ (dragBoxesByPosition at: #right) position - ((self width / 2) @ 0) ])}
				asDictionary ]
]

{ #category : #actions }
OPBoundaryFigure >> pushBack [
	super pushBack.
	dragBoxes pushBack
]

{ #category : #'creating - subelements' }
OPBoundaryFigure >> textOffset [
	^ 0 @ (16 - (self height / 2))
]

{ #category : #'as yet unclassified' }
OPBoundaryFigure >> updateAfterDragOf: draggedBox [
	self
		translateTo: (self positionOfMainRelativeToDragBoxes at: draggedBox model) value.
	self dragBoxUpdateBlocks
		keysAndValuesDo: [ :eachPosition :eachBlock | 
			eachPosition == draggedBox model
				ifFalse: [ eachBlock value ] ].
	self pushBack
]

{ #category : #'as yet unclassified' }
OPBoundaryFigure >> updateDragBoxes [
	self dragBoxUpdateBlocks do: [ :each | each value ].
	self pushBack
]
