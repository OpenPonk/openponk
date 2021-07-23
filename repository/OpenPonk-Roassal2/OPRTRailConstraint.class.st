"
I keep element ""on a rail"" defined by the connection. If the connection is moved, so is the element.

[[[
self example
]]]

!! Public Attributes

- initialPosition - the +initial+ position along the connection.
This can be either a fraction (0 <=  x <= 1) of connection's length,
or absolute distance (x > 1 ||  x < 0), with negative distance starting from the connection's end.
Note that dragging the element will always revert to relative position.
	
- distance - the distance that should be maintained between the element and the connection.
"
Class {
	#name : #OPRTRailConstraint,
	#superclass : #Object,
	#instVars : [
		'element',
		'connection',
		'gripElement',
		'gripLine',
		'gripShape',
		'gripEdge',
		'distance',
		'relativePosition',
		'position'
	],
	#category : #'OpenPonk-Roassal2-Constraints'
}

{ #category : #public }
OPRTRailConstraint class >> element: anElement connection: aConnection [
	self new element: anElement connection: aConnection
]

{ #category : #public }
OPRTRailConstraint class >> element: anElement connection: aConnection relativePosition: aPosition distance: aDistance [
	self new element: anElement connection: aConnection relativePosition: aPosition distance: aDistance
]

{ #category : #example }
OPRTRailConstraint class >> example [
	| v shape a b c conn const |
	v := RTView new.

	(shape := RTBox new)
		size: 10;
		color: Color black.

	a := shape elementOn: 'a'.
	b := shape elementOn: 'b'.
	c := shape elementOn: 'drag me'.

	v
		addAll:
			{a.
			b.
			c}.

	v elements @ (RTLabeled new color: Color black).

	conn := OPRTConnection new
		color: Color black;
		edgeFrom: a to: b.
	conn @ OPRTConnectionHandles.
	b translateBy: 0 @ 100.
	c translateBy: 50 @ 30.

	v add: conn.

	const := OPRTRailConstraint new.
	const gripLineColor: Color blue.
	const gripShape size: 10.
	const
		initialPosition: 0.2;
		distance: 30.
	const element: c connection: conn.


	a @ RTDraggable.
	b @ RTDraggable.
	c @ RTDraggable.

	v open
]

{ #category : #building }
OPRTRailConstraint >> addGrip [
	gripElement := gripShape element.
	element view add: gripElement.
	gripLine color = Color transparent
		ifTrue: [ ^ self ].
	gripEdge := gripLine edgeFrom: element to: gripElement.
	element view add: gripEdge
]

{ #category : #building }
OPRTRailConstraint >> build [
	self addGrip.
	element when: TRMouseDragging do: [ self updateParameters ].
	element when: TRMouseDragEnd do: [ self updateParameters ].
	"	element addCallback: (TRTranslationCallback block: [ self updatePosition ])."
	connection from addCallback: (TRTranslationCallback block: [ self updatePosition ]).
	connection to addCallback: (TRTranslationCallback block: [ self updatePosition ]).
	connection when: OPRTHandleMoved do: [ self updatePosition ].
	self updatePosition
]

{ #category : #'as yet unclassified' }
OPRTRailConstraint >> computePosition [
	position > 1
		ifTrue: [ ^ self connectionLength min: position ].
	position < 0
		ifTrue: [ ^ 0 max: self connectionLength - position ].
	^ self connectionLength * position
]

{ #category : #accessing }
OPRTRailConstraint >> connection: aConnection [
	connection := aConnection
]

{ #category : #'as yet unclassified' }
OPRTRailConstraint >> connectionLength [

	^ self segments
		  inject: 0
		  into: [ :sum :each | sum + (each first distanceTo: each second) ]
]

{ #category : #accessing }
OPRTRailConstraint >> distance: aNumber [
	distance := aNumber
]

{ #category : #accessing }
OPRTRailConstraint >> element: anElement [
	element := anElement
]

{ #category : #accessing }
OPRTRailConstraint >> element: anElement connection: aConnection [
	self
		element: anElement;
		connection: aConnection;
		build
]

{ #category : #accessing }
OPRTRailConstraint >> gripLine [
	^ gripLine
]

{ #category : #accessing }
OPRTRailConstraint >> gripLineColor: aColor [
	gripLine color: aColor
]

{ #category : #accessing }
OPRTRailConstraint >> gripShape [
	^ gripShape
]

{ #category : #accessing }
OPRTRailConstraint >> initialPosition: aNumber [
	position := aNumber
]

{ #category : #building }
OPRTRailConstraint >> initialize [
	(gripShape := RTBox new)
		size: 0;
		color: Color red.
	(gripLine := RTLine new)
		attachPoint: RTBorderAttachPoint new;
		color: Color black
]

{ #category : #accessing }
OPRTRailConstraint >> noGripLine [
	self gripLineColor: Color transparent
]

{ #category : #'as yet unclassified' }
OPRTRailConstraint >> pointBetween: a and: b distance: dist [

	| denom |
	denom := a distanceTo: b.
	^ denom > 0
		  ifTrue: [ a + (b - a / denom * dist) ]
		  ifFalse: [ "
	^ a + ((b - a) / (a dist: b) * dist)" a ]
]

{ #category : #'as yet unclassified' }
OPRTRailConstraint >> segmentForPosition: aPosition [

	| sum newSum |
	sum := 0.
	self segments do: [ :each | 
		| length |
		length := each first distanceTo: each second.
		newSum := sum + length.
		sum <= aPosition & (aPosition <= newSum) ifTrue: [ 
			^ { 
				  each first.
				  each second.
				  (self
					   pointBetween: each first
					   and: each second
					   distance: aPosition - sum) } ].
		sum := newSum ].
	self segments ifNotEmpty: [ 
		^ { 
			  self segments first first.
			  self segments first second.
			  (self segments first first + (aPosition @ aPosition)) } ].
	self error: 'failed to find a segment'
]

{ #category : #accessing }
OPRTRailConstraint >> segments [
	^ self segmentsForConnection: connection
]

{ #category : #accessing }
OPRTRailConstraint >> segmentsForConnection: aConnection [
	^ (aConnection shape pathFor: aConnection)
		overlappingPairsCollect: [ :a :b | Array with: a with: b ]
]

{ #category : #'private - layout' }
OPRTRailConstraint >> updateParameters [
	| segmentsWithDistances closestSegment sum |
	self connectionLength isZero
		ifTrue: [ ^ self segments first first ].
	segmentsWithDistances := self segments
		withIndexCollect: [ :each :i | 
			Array
				with: i
				with: each first
				with: each second
				with: (element position nearestPointOnLineFrom: each first to: each second) ].
	closestSegment := segmentsWithDistances
		detectMin: [ :each | element position dist: each fourth ].
	sum := (self segments first: closestSegment first - 1)
		inject: 0
		into: [ :s :next | s + (next first dist: next second) ].
	sum := sum + (closestSegment second dist: closestSegment fourth).
	gripElement trachelShape
		doWithoutCallbacks: [ position := sum / self connectionLength.
			distance := element position dist: closestSegment fourth.
			(self
				windingOrder: element position
				segment:
					{closestSegment second.
					closestSegment third}) < 0
				ifTrue: [ distance := distance negated ].
			gripElement translateTo: closestSegment fourth ]
]

{ #category : #'private - layout' }
OPRTRailConstraint >> updatePosition [
	| segment |
	segment := self segmentForPosition: self computePosition.
	gripElement translateTo: segment third.
	element translateTo: segment third + ((segment second - segment first) normal * distance negated)
]

{ #category : #'private - layout' }
OPRTRailConstraint >> updatePositionWithoutDistance [
	| nearestPoints min |
	nearestPoints := self segments
		collect: [ :each | element position nearestPointOnLineFrom: each first to: each second ].
	min := nearestPoints detectMin: [ :each | element position dist: each ].
	gripElement translateTo: min
]

{ #category : #'private - layout' }
OPRTRailConstraint >> windingOrder: aPoint segment: aSegment [
	"A=(x1,y1) to B=(x2,y2) a point P=(x,y)
	d=(x−x1)(y2−y1)−(y−y1)(x2−x1)"

	^ (aPoint x - aSegment first x) * (aSegment second y - aSegment first y)
		- ((aPoint y - aSegment first y) * (aSegment second x - aSegment first x))
]
