"
I am a Connection that supports addition of head/tail styles and line styles.
"
Class {
	#name : #OPRTStyledConnection,
	#superclass : #OPRTConnection,
	#instVars : [
		'decorations'
	],
	#category : 'OpenPonk-Roassal2-Connection'
}

{ #category : #examples }
OPRTStyledConnection class >> example [
	|v es e visible|
v := RTView new.
es := (RTEllipse new color: Color black; size: 20; elementsOn: #(1 2)).
e := OPRTStyledConnection new
	decorate: [ :deco |
		deco
			dashdotLine;
			emptyDiamondTail;
			filledArrowHead
	];
	withBorderAttachPoint;
	color: Color red;
	edgeFrom: es first to: es second.
	e shape addPoint: -50 @ 10.
e shape addPoint: -50 @ 80.
e shape addPoint: 200 @ 80.
e shape addPoint: 200 @ 10.
v addAll: es; add: e.
es @ RTDraggable.
RTHorizontalLineLayout new horizontalGap: 100; on: es.
visible := false.
e @ OPRTConnectionHandles.

v open
]

{ #category : #accessing }
OPRTStyledConnection >> attachPoint: anAttachPoint [
	decorations attachPoint: anAttachPoint.
	attachPoint := anAttachPoint
]

{ #category : #rendering }
OPRTStyledConnection >> changeDecorationsFor: anEdge trachelShape: trachelShape [
	| path oldTail oldHead |
	path := self pathFor: anEdge.
	oldTail := trachelShape shapes last.
	oldTail class = decorations tail trachelShapeClass
		ifFalse:
			[ 
			| newTail |
			newTail := decorations tail trachelShapeFor: anEdge from: path second.
			trachelShape removeLast remove.
			trachelShape addShape: newTail.
			newTail element: trachelShape element.
			newTail announcer: trachelShape element announcer.
			newTail addedIn: trachelShape canvas ].

	oldHead := trachelShape shapes atLast: 2.
	oldHead class = decorations head trachelShapeClass
		ifFalse:
			[ 
			| newHead |
			newHead := decorations head trachelShapeFor: anEdge from: (path atLast: 2).
			(trachelShape removeAt: trachelShape shapes size - 1) remove.
			trachelShape addShape: newHead beforeIndex: trachelShape shapes size.
			newHead element: trachelShape element.
			newHead announcer: trachelShape element announcer.
			newHead addedIn: trachelShape canvas ]
]

{ #category : #accessing }
OPRTStyledConnection >> color: aColor [
	decorations color: aColor.
	color := aColor
]

{ #category : #rendering }
OPRTStyledConnection >> createLineToSelfFor: anEdge [
	| radius right top topRight rect |
	radius := 30.
	rect := anEdge from encompassingRectangle.
	right := rect right @ rect center y + (radius @ 0).
	top := rect center x @ rect top - (0 @ radius)
		+ ((2 * (self attachPoint offsetNormalFor: anEdge) x) @ 0).
	topRight := right x @ top y.
	anEdge from
		addCallback: (TRTranslationCallback block: [ :s :step | self translateBy: step for: anEdge ]).
	self
		addPoint: right;
		addPoint: topRight;
		addPoint: top
]

{ #category : #accessing }
OPRTStyledConnection >> decorate: aBlock [
	aBlock value: decorations
]

{ #category : #accessing }
OPRTStyledConnection >> decorations [
	^ decorations
]

{ #category : #accessing }
OPRTStyledConnection >> head [
	^ decorations head
]

{ #category : #accessing }
OPRTStyledConnection >> head: aDecoration [
	decorations head: aDecoration
]

{ #category : #initialization }
OPRTStyledConnection >> initialize [
	super initialize.
	decorations := OPRTLineDecorationBuilder new
]

{ #category : #public }
OPRTStyledConnection >> lineSegmentFor: anEdge from: aSource to: aTarget [
	^ TRStyledLineShape new
		dashes: decorations dashes;
		width: (self widthFor: anEdge);
		from: aSource to: aTarget;
		color: (self colorFor: anEdge);
		yourself
]

{ #category : #rendering }
OPRTStyledConnection >> pathFor: anEdge [
	| fromPoint toPoint |
	(anEdge from = anEdge to and: [ self points isEmpty ])
		ifTrue: [ self createLineToSelfFor: anEdge ].
	fromPoint := attachPoint startingPointOf: anEdge.
	toPoint := attachPoint endingPointOf: anEdge.
	^ {fromPoint} , self points , {toPoint}
]

{ #category : #accessing }
OPRTStyledConnection >> tail [
	^ decorations tail
]

{ #category : #accessing }
OPRTStyledConnection >> tail: aDecoration [
	decorations tail: aDecoration
]

{ #category : #public }
OPRTStyledConnection >> trachelShapeFor: anEdge [
	| multiShape path |
	multiShape := super trachelShapeFor: anEdge.
	path := self pathFor: anEdge.
	multiShape
		addShape: (decorations head trachelShapeFor: anEdge from: path allButLast last);
		addShape: (decorations tail trachelShapeFor: anEdge from: path second).
	^ multiShape
]

{ #category : #public }
OPRTStyledConnection >> updateFor: anEdge trachelShape: trachelShape [
	| path |
	super updateFor: anEdge trachelShape: trachelShape.
	self changeDecorationsFor: anEdge trachelShape: trachelShape.
	path := self pathFor: anEdge.
	decorations head
		updateFor: anEdge
		trachelShape: trachelShape shapes allButLast last
		from: path allButLast last.
	decorations tail updateFor: anEdge trachelShape: trachelShape shapes last from: path second.
	trachelShape canvas ifNotNil: [ trachelShape pushFront ].
	^ trachelShape
]

{ #category : #'attach point' }
OPRTStyledConnection >> withBorderAttachPoint [
	self attachPoint: (RTBorderAttachPoint new offset: 20)
]

{ #category : #'attach point' }
OPRTStyledConnection >> withContinuousCircleAttachPoint [
	self attachPoint: RTBorderAttachPoint new
]

{ #category : #'attach point' }
OPRTStyledConnection >> withContinuousRectangleAttachPoint [
	self attachPoint: RTBorderAttachPoint new
]

{ #category : #'attach point' }
OPRTStyledConnection >> withOrthogonalAttachPoint [
	self attachPoint: (OPRTOrthogonalAttachPoint new offset: 20)
]

{ #category : #'attach point' }
OPRTStyledConnection >> withShorterDistanceWithOffsetAttachPoint [
	self attachPoint: RTShorterDistanceWithOffsetAttachPoint new
]
