"
I have no idea how to describe this. :(

[[[
self example
]]]
"
Class {
	#name : #OPRTRailsConstraint,
	#superclass : #Object,
	#instVars : [
		'element',
		'connection',
		'segmentsRetriever',
		'gripElement',
		'gripLine',
		'gripShape',
		'gripEdge',
		'distance'
	],
	#category : 'OpenPonk-Roassal2-Constraints'
}

{ #category : #public }
OPRTRailsConstraint class >> element: anElement connection: aConnection [
	self new element: anElement connection: aConnection
]

{ #category : #example }
OPRTRailsConstraint class >> example [
	| v shape a b c conn |
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

	OPRTRailsConstraint element: c connection: conn.

	a @ RTDraggable.
	b @ RTDraggable.
	c @ RTDraggable.

	v open
]

{ #category : #building }
OPRTRailsConstraint >> addGrip [
	gripElement := gripShape element.
	element view add: gripElement.
	gripEdge := gripLine edgeFrom: element to: gripElement.
	element view add: gripEdge
]

{ #category : #building }
OPRTRailsConstraint >> build [
	self addGrip.
	element addCallback: (TRTranslationCallback block: [ self updatePosition ]).
	connection from addCallback: (TRTranslationCallback block: [ self updatePosition ]).
	connection to addCallback: (TRTranslationCallback block: [ self updatePosition ]).
	connection when: OPRTHandleMoved do: [ self updatePosition ].
	self updatePosition
]

{ #category : #accessing }
OPRTRailsConstraint >> connection: aConnection [
	connection := aConnection
]

{ #category : #accessing }
OPRTRailsConstraint >> distance: aNumber [
	distance := aNumber
]

{ #category : #accessing }
OPRTRailsConstraint >> element: anElement [
	element := anElement
]

{ #category : #accessing }
OPRTRailsConstraint >> element: anElement connection: aConnection [
	self
		element: anElement;
		connection: aConnection;
		build
]

{ #category : #accessing }
OPRTRailsConstraint >> gripLine [
	^ gripLine
]

{ #category : #accessing }
OPRTRailsConstraint >> gripShape [
	^ gripShape
]

{ #category : #building }
OPRTRailsConstraint >> initialize [
	(gripShape := RTBox new)
		size: 0;
		color: Color red.
	(gripLine := RTLine new)
		attachPoint: RTBorderAttachPoint new;
		color: Color black
]

{ #category : #accessing }
OPRTRailsConstraint >> segments [
	^ self segmentsForConnection: connection
]

{ #category : #accessing }
OPRTRailsConstraint >> segmentsForConnection: aConnection [
	^ (aConnection shape pathFor: aConnection)
		overlappingPairsCollect: [ :a :b | Array with: a with: b ]
]

{ #category : #'private - layout' }
OPRTRailsConstraint >> updatePosition [
	| nearestPoints min |
	nearestPoints := self segments
		collect: [ :each | element position nearestPointOnLineFrom: each first to: each second ].
	min := nearestPoints detectMin: [ :each | element position dist: each ].
	gripElement translateTo: min
]

{ #category : #'private - layout' }
OPRTRailsConstraint >> updatePositionWithoutDistance [
	| nearestPoints min |
	nearestPoints := self segments
		collect: [ :each | element position nearestPointOnLineFrom: each first to: each second ].
	min := nearestPoints detectMin: [ :each | element position dist: each ].
	gripElement translateTo: min
]
