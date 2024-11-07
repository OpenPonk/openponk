Class {
	#name : 'OPNote',
	#superclass : 'OPDiagramOnlyShapeWithText',
	#traits : 'OPTColoredAsFillAndBorderColoredAsStroke',
	#classTraits : 'OPTColoredAsFillAndBorderColoredAsStroke classTrait',
	#instVars : [
		'text',
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
		'lines'
	],
	#category : 'OpenPonk-Core-CommonElements',
	#package : 'OpenPonk-Core',
	#tag : 'CommonElements'
}

{ #category : 'ston-core' }
OPNote class >> stonAllInstVarNames [

	"Override to encode my instances using a custom set of instance variables or to define their order."

	^ super stonAllInstVarNames , #( #text )
]

{ #category : 'accessing' }
OPNote >> attachedElementShapes [

	^ {
		  topLeftBox.
		  upperTopRightBox.
		  lowerTopRightBox.
		  bottomLeftBox.
		  bottomRightBox.
		  middleLeftBox.
		  middleBottomBox.
		  leftFillBox.
		  bottomFillBox.
		  triangle }
]

{ #category : 'accessing' }
OPNote >> attachedShapes [

	^ super attachedShapes , self attachedElementShapes , lines
]

{ #category : 'creating - subelements' }
OPNote >> createOwnedBorderLines [

	| lineShape innerLineShape |
	lineShape := RSLine new
		             width: 1;
		             yourself.
	innerLineShape := RSLine new
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

{ #category : 'creating - subelements' }
OPNote >> createOwnedCornerTriangle [

	triangle := RSSVGPath new
		            svgPath: 'M0,0L20,0L0,-20Z';
		            model: self;
		            yourself.
	self canvas add: triangle
]

{ #category : 'creating - subelements' }
OPNote >> createOwnedFillBoxes [

	| fillBoxShape |
	fillBoxShape := RSBox new
		                borderColor: Color transparent;
		                yourself.
	leftFillBox := fillBoxShape model: #left.
	bottomFillBox := fillBoxShape copy model: #bottom.
	self canvas
		add: leftFillBox;
		add: bottomFillBox
]

{ #category : 'creating - subelements' }
OPNote >> createOwnedInvisibleBoxes [

	| invisibleBoxShape invisibleBoxes |
	invisibleBoxShape := RSBox new
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

{ #category : 'accessing' }
OPNote >> defaultFillColor [

	^ OPDiagramFigureYellowFillColorCommand new color
]

{ #category : 'initialization' }
OPNote >> initialize [

	super initialize.
	text := ''.
	self
		when: OPElementTextAttributeChanged
		send: #updateRenderFromSelf
		to: self
]

{ #category : 'printing' }
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

{ #category : 'removing' }
OPNote >> removeRender [

	super removeRender.
	topLeftBox := nil.
	upperTopRightBox := nil.
	lowerTopRightBox := nil.
	bottomLeftBox := nil.
	bottomRightBox := nil.
	middleLeftBox := nil.
	middleBottomBox := nil.
	leftFillBox := nil.
	bottomFillBox := nil.
	triangle := nil.
	lines removeAll.
]

{ #category : 'rendering' }
OPNote >> renderBasicShape [

	^ RSBox new
		  color: Color transparent;
		  width: 150;
		  height: 100;
		  yourself
]

{ #category : 'creating - subelements' }
OPNote >> renderShapeDetails [

	super renderShapeDetails.

	self createOwnedInvisibleBoxes.
	self createOwnedFillBoxes.
	self createOwnedCornerTriangle.
	self createOwnedBorderLines.
	self updateOwnedElements.
	self roassalShape
		when: RSPositionChangedEvent
		do: [ self updateOwnedElements ]
		for: self;
		when: RSExtentChangedEvent
		do: [ self updateOwnedElements ]
		for: self
]

{ #category : 'interactions' }
OPNote >> selectableInteraction [

	^ OPRSSelectable
]

{ #category : 'creating - subelements' }
OPNote >> shouldBePositionableByUser [

	^ true
]

{ #category : 'interactions' }
OPNote >> shouldBeResizableByUser [

	^ true
]

{ #category : 'accessing' }
OPNote >> text [
	^ text
]

{ #category : 'accessing' }
OPNote >> text: aString [

	text := aString
]

{ #category : 'rendering' }
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

{ #category : 'initialization' }
OPNote >> updateRoassalShapeBorderColorFromStyles [

	lines do: [ :each | each color: self borderColor ].
	triangle borderColor:
		(self borderColor alphaMixed: 0.35 with: Color white)
]

{ #category : 'initialization' }
OPNote >> updateRoassalShapeColorFromStyles [

	self attachedElementShapes do: [ :each | each color: self color ].
	triangle color: self color slightlyDarker
]
