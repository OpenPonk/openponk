Class {
	#name : #OPNoteFigure,
	#superclass : #OPResizableFigureWithText,
	#instVars : [
		'lines',
		'topLeftBox',
		'upperTopRightBox',
		'lowerTopRightBox',
		'bottomLeftBox',
		'bottomRightBox',
		'middleLeftBox',
		'middleBottomBox',
		'leftFillBox',
		'bottomFillBox',
		'triangle',
		'invisibleBoxes'
	],
	#category : #'OpenPonk-Core-CommonElements'
}

{ #category : #rendering }
OPNoteFigure >> addInteractions [
	self @ (RTResizable new minSize: self minWidth @ self minHeight).
	self @ OPRTDraggableSnapToGrid
]

{ #category : #accessing }
OPNoteFigure >> baseShape [
	^ RTBox new
		color: Color transparent;
		borderColor: Color transparent;
		width: 150;
		height: 100;
		yourself
]

{ #category : #'creating - subelements' }
OPNoteFigure >> createOwnedBorderLines [
	| lineShape innerLineShape |
	lineShape := RTLine new
		color: Color darkGray;
		width: 1;
		yourself.
	innerLineShape := RTLine new
		color: Color gray;
		width: 1;
		yourself.
	lines := {(lineShape edgeFrom: upperTopRightBox to: lowerTopRightBox).
	(lineShape edgeFrom: lowerTopRightBox to: bottomRightBox).
	(lineShape edgeFrom: bottomRightBox to: bottomLeftBox).
	(lineShape edgeFrom: bottomLeftBox to: topLeftBox).
	(lineShape edgeFrom: topLeftBox to: upperTopRightBox)} asGroup.
	self addAll: lines
]

{ #category : #'creating - subelements' }
OPNoteFigure >> createOwnedCornerTriangle [
	triangle := RTSVGPath new
		path: 'L20,0L0,-20Z';
		color: Color lightYellow darker;
		borderColor: Color darkGray;
		elementOn: #triangle.
	self
		add: triangle.
]

{ #category : #'creating - subelements' }
OPNoteFigure >> createOwnedElements [
	super createOwnedElements.
	self createOwnedInvisibleBoxes.
	self createOwnedFillBoxes.
	self createOwnedCornerTriangle.
	self createOwnedBorderLines.
	ownedElements sort: [ :a :b | a isEdge & b isEdge not ].
	self updateOwnedElements.
	self
		addCallback: (TRExtentCallback block: [ self updateOwnedElements ]).
	self
		addCallback: (TRTranslationCallback block: [ self updateOwnedElements ])
]

{ #category : #'creating - subelements' }
OPNoteFigure >> createOwnedFillBoxes [
	| fillBoxShape |
	fillBoxShape := RTBox new
		color: Color lightYellow;
		borderColor: Color transparent;
		yourself.
	leftFillBox := fillBoxShape elementOn: #left.
	bottomFillBox := fillBoxShape elementOn: #bottom.
	self
		add: leftFillBox;
		add: bottomFillBox
]

{ #category : #'creating - subelements' }
OPNoteFigure >> createOwnedInvisibleBoxes [
	| invisibleBoxShape |
	invisibleBoxShape := RTBox new
		color: Color transparent;
		borderColor: Color transparent;
		width: 1;
		height: 1;
		yourself.
	invisibleBoxes := {(topLeftBox := invisibleBoxShape
		elementOn: #topLeft).
	(upperTopRightBox := invisibleBoxShape elementOn: #upperTopRight).
	(lowerTopRightBox := invisibleBoxShape elementOn: #lowerTopRight).
	(bottomLeftBox := invisibleBoxShape elementOn: #bottomLeft).
	(bottomRightBox := invisibleBoxShape elementOn: #bottomRight).
	(middleLeftBox := invisibleBoxShape elementOn: #middleLeft).
	(middleBottomBox := invisibleBoxShape elementOn: #middleBottom)}
		asGroup.
	self addAll: invisibleBoxes
]

{ #category : #rendering }
OPNoteFigure >> minHeight [
	^ 50
]

{ #category : #rendering }
OPNoteFigure >> minWidth [
	^ 50
]

{ #category : #hooks }
OPNoteFigure >> modelTextSelector [
	^ #text
]

{ #category : #'as yet unclassified' }
OPNoteFigure >> updateOwnedElements [
	bottomRightBox translateTo: self encompassingRectangle bottomRight.
	bottomLeftBox translateTo: self encompassingRectangle bottomLeft.
	topLeftBox translateTo: self encompassingRectangle topLeft.
	upperTopRightBox
		translateTo: self encompassingRectangle topRight + (-20 @ 0).
	lowerTopRightBox
		translateTo: self encompassingRectangle topRight + (0 @ 20).
	middleLeftBox
		translateTo: self encompassingRectangle topLeft + (0 @ 20).
	middleBottomBox
		translateTo: self encompassingRectangle bottomRight + (-20 @ 0).
	triangle
		translateTo: self encompassingRectangle topRight + (-20 @ 20).
	leftFillBox
		extent: self extent + (-20 @ 0);
		translateTo: self position + (-10 @ 0).
	bottomFillBox
		extent: self extent + (0 @ -20);
		translateTo: self position + (0 @ 10)
]
