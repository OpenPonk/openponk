"
I am a connection between two points. This connection can be straight line or a sequence of line segments.
"
Class {
	#name : #OPRTConnection,
	#superclass : #RTAbstractLine,
	#instVars : [
		'router'
	],
	#category : 'OpenPonk-Roassal2-Connection'
}

{ #category : #examples }
OPRTConnection class >> example [
|v es e|
v := RTView new.
es := (RTEllipse new color: Color black; size: 20; elementsOn: #(1 2)).
e := OPRTConnection new color: Color red; edgeFrom: es first to: es second.
e shape addPoint: 30 @ 80.
v addAll: es; add: e.
es @ RTDraggable.
RTHorizontalLineLayout new horizontalGap: 50; on: es.
e @ OPRTConnectionHandles.

v open

]

{ #category : #rendering }
OPRTConnection >> addOrRemoveLinesFor: anEdge trachelShape: trachelShape [
	| segmentsCount pointsCount shape canvas |
	canvas := trachelShape canvas.
	segmentsCount := (trachelShape shapes select: [ :each | each isKindOf: TRAbstractLineShape ]) size - 1.	"-1 base segment"
	pointsCount := self points size.
	pointsCount - segmentsCount
		timesRepeat: [ 
			"add segments"
			shape := self lineSegmentFor: anEdge from: 0 @ 0 to: 0 @ 0.

			trachelShape addShapeFirst: shape.
			shape element: trachelShape element.
			shape announcer: trachelShape element announcer.
			shape addedIn: canvas ].

	segmentsCount - pointsCount
		timesRepeat: [ 
			"remove segments"
			trachelShape removeFirst remove ]
]

{ #category : #adding }
OPRTConnection >> addPoint: aPoint [
	router addPoint: aPoint
]

{ #category : #initialization }
OPRTConnection >> initialize [
	super initialize.
	router := OPRTInteractiveRouter new
]

{ #category : #rendering }
OPRTConnection >> lineSegmentFor: anEdge from: aSource to: aTarget [
	^ TRLineShape new
		width: (self widthFor: anEdge);
		from: aSource to: aTarget;
		color: (self colorFor: anEdge);
		yourself
]

{ #category : #rendering }
OPRTConnection >> pathFor: anEdge [
	| fromPoint toPoint |
	fromPoint := attachPoint startingPointOf: anEdge.
	toPoint := attachPoint endingPointOf: anEdge.
	^ {fromPoint} , self points , {toPoint}
]

{ #category : #accessing }
OPRTConnection >> points [
	^ router points
]

{ #category : #accessing }
OPRTConnection >> router [
	^ router
]

{ #category : #accessing }
OPRTConnection >> router: aRouter [
	router := aRouter
]

{ #category : #rendering }
OPRTConnection >> trachelShapeFor: anEdge [
	| shape multiShape path |
	path := self pathFor: anEdge.
	multiShape := TRCompositeShape new.
	path overlappingPairsDo: [ :a :b |
		shape := self lineSegmentFor: anEdge from: a to: b.
		multiShape addShape: shape ].
	^ multiShape
]

{ #category : #updating }
OPRTConnection >> translateBy: aPoint for: anEdge [
	router translateAllBy: aPoint.
	anEdge update.
	anEdge signalUpdate
]

{ #category : #rendering }
OPRTConnection >> updateFor: anEdge trachelShape: trachelShape [
	| shape col path |
	col := self colorFor: anEdge.
	path := self pathFor: anEdge.

	self addOrRemoveLinesFor: anEdge trachelShape: trachelShape.

	2 to: path size do: [ :i | 
		shape := trachelShape shapes at: i - 1.
		shape width: (self widthFor: anEdge).
		shape from: (path at: i - 1) to: (path at: i).
		shape color: col ].
	^ trachelShape
]
