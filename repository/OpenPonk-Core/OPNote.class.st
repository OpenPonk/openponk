Class {
	#name : #OPNote,
	#superclass : #OPDiagramOnlyShape,
	#traits : 'OPTResizableFigureWithText',
	#classTraits : 'OPTResizableFigureWithText classTrait',
	#instVars : [
		'text',
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
		'invisibleBoxes',
		'baseShape'
	],
	#category : #'OpenPonk-Core-CommonElements'
}

{ #category : #'ston-core' }
OPNote class >> stonAllInstVarNames [

	"Override to encode my instances using a custom set of instance variables or to define their order."

	^ super stonAllInstVarNames , #( #text )
]

{ #category : #'creating - subelements' }
OPNote >> createOwnedBorderLines [

	| lineShape innerLineShape |
	lineShape := RSLine new
		             color: Color darkGray;
		             width: 1;
		             yourself.
	innerLineShape := RSLine new
		                  color: Color gray;
		                  width: 1;
		                  yourself.
	lines := { 
		         (lineShape copy
			          from: upperTopRightBox;
			          to: lowerTopRightBox).
		         (lineShape copy
			          from: lowerTopRightBox;
			          to: bottomRightBox).
		         (lineShape copy
			          from: bottomRightBox;
			          to: bottomLeftBox).
		         (lineShape copy
			          from: bottomLeftBox;
			          to: topLeftBox).
		         (lineShape copy
			          from: topLeftBox;
			          to: upperTopRightBox) } asGroup.
	roassalShape canvas addAll: lines
]

{ #category : #'creating - subelements' }
OPNote >> createOwnedCornerTriangle [

	triangle := RSSVGPath new
		            svgPath: 'M0,0L20,0L0,-20Z';
		            color: Color lightYellow darker;
		            borderColor: Color lightGray;
		            model: self;
		            yourself.
	self canvas add: triangle
]

{ #category : #'creating - subelements' }
OPNote >> createOwnedFillBoxes [

	| fillBoxShape |
	fillBoxShape := RSBox new
		                color: Color lightYellow;
		                borderColor: Color transparent;
		                yourself.
	leftFillBox := fillBoxShape model: #left.
	bottomFillBox := fillBoxShape copy model: #bottom.
	self canvas
		add: leftFillBox;
		add: bottomFillBox
]

{ #category : #'creating - subelements' }
OPNote >> createOwnedInvisibleBoxes [

	| invisibleBoxShape |
	invisibleBoxShape := RSBox new
		                     color: Color transparent;
		                     borderColor: Color transparent;
		                     width: 1;
		                     height: 1;
		                     yourself.
	invisibleBoxes := { 
		                  (topLeftBox := invisibleBoxShape copy model:
			                                 #topLeft).
		                  (upperTopRightBox := invisibleBoxShape copy 
			                                       model: #upperTopRight).
		                  (lowerTopRightBox := invisibleBoxShape copy 
			                                       model: #lowerTopRight).
		                  (bottomLeftBox := invisibleBoxShape copy model:
			                                    #bottomLeft).
		                  (bottomRightBox := invisibleBoxShape copy model:
			                                     #bottomRight).
		                  (middleLeftBox := invisibleBoxShape copy model:
			                                    #middleLeft).
		                  (middleBottomBox := invisibleBoxShape copy model:
			                                      #middleBottom) } asGroup.
	self canvas addAll: invisibleBoxes
]

{ #category : #initialization }
OPNote >> initialize [
	super initialize.
	text := ''
]

{ #category : #printing }
OPNote >> printOn: aStream [

	super printOn: aStream.
	aStream nextPutAll: '('''.

	self text size <= 20
		ifTrue: [ 
			aStream
				nextPutAll: self text;
				nextPut: $' ]
		ifFalse: [ 
			aStream
				nextPutAll: (self text first: (17 min: self text size));
				nextPutAll: '''...' ].
	aStream nextPutAll: ')'
]

{ #category : #'as yet unclassified' }
OPNote >> renderBasicShape [

	roassalShape := RSBox new
		                color: Color transparent;
		                borderColor: Color transparent;
		                width: 150;
		                height: 100;
		                yourself
]

{ #category : #'creating - subelements' }
OPNote >> renderShapeDetails [

	self createOwnedInvisibleBoxes.
	self createOwnedFillBoxes.
	self createOwnedCornerTriangle.
	self createOwnedBorderLines.
	roassalShape
		@ OPRSSelectable;
		@ OPRSSelectionDraggable;
		@ OPRSResizable.
	self updateOwnedElements.
	self roassalShape
		when: RSPositionChangedEvent do: [ self updateOwnedElements ];
		when: RSExtentChangedEvent do: [ self updateOwnedElements ].
	self renderLabel
]

{ #category : #accessing }
OPNote >> text [
	^ text
]

{ #category : #accessing }
OPNote >> text: aString [

	text := aString
]

{ #category : #'as yet unclassified' }
OPNote >> updateOwnedElements [

	bottomRightBox translateTo:
		roassalShape encompassingRectangle bottomRight.
	bottomLeftBox translateTo:
		roassalShape encompassingRectangle bottomLeft.
	topLeftBox translateTo: roassalShape encompassingRectangle topLeft.
	upperTopRightBox translateTo:
		roassalShape encompassingRectangle topRight + (-20 @ 0).
	lowerTopRightBox translateTo:
		roassalShape encompassingRectangle topRight + (0 @ 20).
	middleLeftBox translateTo:
		roassalShape encompassingRectangle topLeft + (0 @ 20).
	middleBottomBox translateTo:
		roassalShape encompassingRectangle bottomRight + (-20 @ 0).
	triangle translateTo:
		roassalShape encompassingRectangle topRight +(-10@10).
	leftFillBox
		extent: roassalShape extent + (-20 @ 0);
		translateTo: roassalShape position + (-10 @ 0).
	bottomFillBox
		extent: roassalShape extent + (0 @ -20);
		translateTo: roassalShape position + (0 @ 10)
]
