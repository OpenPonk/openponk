"
A DCRTEdgeEndConstraint is a utility class that contains methods to position elements against the start or the end of edges
"
Class {
	#name : #OPRTEdgeEndConstraint,
	#superclass : #OPRTEdgeAbstractConstraint,
	#instVars : [
		'distance',
		'origin'
	],
	#category : 'OpenPonk-Roassal2-Constraints'
}

{ #category : #'public - sticking' }
OPRTEdgeEndConstraint class >> fix: aShape nearEndOfEdge: anEdge [
	"keeps current position of aShape against anEdge. Uses orthogonal distance from line and distance from end of the line along it"

	^ self new
		shape: aShape;
		edge: anEdge;
		nearEnd;
		fix;
		yourself
]

{ #category : #'public - sticking' }
OPRTEdgeEndConstraint class >> fix: aShape nearStartOfEdge: anEdge [
	"keeps current position of aShape against anEdge. Uses orthogonal distance from line and distance from start of the line along it"

	^ self new
		shape: aShape;
		edge: anEdge;
		nearStart;
		fix;
		yourself
]

{ #category : #'public - moving' }
OPRTEdgeEndConstraint class >> move: aShape nearEndOfEdge: anEdge distance: aNumber offset: anotherNumber [
	"changes position of aShape against anEdge, with orthogonal offset distance from it and aNumber distance from end of the line"

	^ self new
		shape: aShape;
		edge: anEdge;
		nearEnd;
		distance: aNumber;
		offset: anotherNumber;
		move;
		yourself
]

{ #category : #'public - moving' }
OPRTEdgeEndConstraint class >> move: aShape nearStartOfEdge: anEdge distance: aNumber offset: anotherNumber [
	"changes position of aShape against anEdge, with orthogonal offset distance from it and aNumber distance from start of the line"

	^ self new
		shape: aShape;
		edge: anEdge;
		nearStart;
		distance: aNumber;
		offset: anotherNumber;
		move;
		yourself
]

{ #category : #'public - sticking' }
OPRTEdgeEndConstraint class >> stick: aShape nearEndOfEdge: anEdge distance: aNumber offset: anotherNumber [
	"keeps position of aShape against anEdge, with orthogonal offset distance from it and aNumber distance from end of the line"

	^ self new
		shape: aShape;
		edge: anEdge;
		nearEnd;
		distance: aNumber;
		offset: anotherNumber;
		stick;
		yourself
]

{ #category : #'public - sticking' }
OPRTEdgeEndConstraint class >> stick: aShape nearStartOfEdge: anEdge distance: aNumber offset: anotherNumber [
	"keeps position of aShape against anEdge, with orthogonal offset distance from it and aNumber distance from start of the line"

	^ self new
		shape: aShape;
		edge: anEdge;
		nearStart;
		distance: aNumber;
		offset: anotherNumber;
		stick;
		yourself
]

{ #category : #accessing }
OPRTEdgeEndConstraint >> distance: aDistance [
	distance := aDistance
]

{ #category : #running }
OPRTEdgeEndConstraint >> fix [
	"a little math... reverse process of move: gets settings according to shape and edge positions"

	| startPoint endPoint originPoint nearestPoint edgeVector positionVector |
	startPoint := edge shape startingPointOf: edge.
	endPoint := edge shape endingPointOf: edge.
	originPoint := origin = #start
		ifTrue: [ startPoint ]
		ifFalse: [ endPoint ].
	nearestPoint := shape position nearestPointAlongLineFrom: startPoint to: endPoint.
	edgeVector := endPoint - startPoint.
	positionVector := shape position - nearestPoint.
	offset := shape position dist: nearestPoint.
	(edgeVector + positionVector rightRotated) r > edgeVector r
		ifTrue: [ offset := offset negated ].
	distance := nearestPoint dist: originPoint.
	(shape position nearestPointOnLineFrom: startPoint to: endPoint) = originPoint
		ifTrue: [ distance := distance negated ].
	self stick
]

{ #category : #initialization }
OPRTEdgeEndConstraint >> initialize [
	super initialize.
	distance := 0.
	origin := #end
]

{ #category : #running }
OPRTEdgeEndConstraint >> move [
	"moves shape according to edge positions and settings"

	| startPoint endPoint vector distVector |
	startPoint := edge shape startingPointOf: edge.
	endPoint := edge shape endingPointOf: edge.
	shape
		translateTo:
			(origin = #start
				ifTrue: [ startPoint ]
				ifFalse: [ endPoint ]).
	(vector := endPoint - startPoint) isZero
		ifFalse: [ 
			distVector := distance * vector normalized.
			origin = #end
				ifTrue: [ distVector := distVector negated ].
			shape translateBy: vector normal * offset + distVector ]
]

{ #category : #accessing }
OPRTEdgeEndConstraint >> near [
	^ origin
]

{ #category : #accessing }
OPRTEdgeEndConstraint >> nearEnd [
	origin := #end
]

{ #category : #accessing }
OPRTEdgeEndConstraint >> nearStart [
	origin := #start
]
