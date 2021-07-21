"
A DCRTEdgeEndConstraint is a utility class that contains methods to position elements against any point on edge
"
Class {
	#name : #OPRTEdgeAlongConstraint,
	#superclass : #OPRTEdgeAbstractConstraint,
	#instVars : [
		'balance'
	],
	#category : 'OpenPonk-Roassal2-Constraints'
}

{ #category : #'public - sticking' }
OPRTEdgeAlongConstraint class >> fix: aShape alongEdge: anEdge [
	"keeps current position of aShape against anEdge. Uses orthogonal distance from line and proportional distance from middle of line along it"

	^ self new
		shape: aShape;
		edge: anEdge;
		fix;
		yourself
]

{ #category : #'public - moving' }
OPRTEdgeAlongConstraint class >> move: aShape alongEdge: anEdge balance: aFloat offset: aNumber [
	"changes position of aShape against anEdge, with orthogonal offset distance from it.
	balance = 0.5 => in the middle of line
	balance = 0 => on the starting point of line
	balance = 1 => on the ending point of line"

	^ self new
		shape: aShape;
		edge: anEdge;
		balance: aFloat;
		offset: aNumber;
		move;
		yourself
]

{ #category : #'public - moving' }
OPRTEdgeAlongConstraint class >> move: aShape alongEdge: anEdge offset: aNumber [
	"changes position of aShape against anEdge, in the middle of edge, with orthogonal offset distance from it"

	^ self new
		shape: aShape;
		edge: anEdge;
		offset: aNumber;
		move;
		yourself
]

{ #category : #'public - sticking' }
OPRTEdgeAlongConstraint class >> stick: aShape alongEdge: anEdge balance: aFloat offset: aNumber [
	"keeps position of aShape against anEdge, with orthogonal offset distance from it.
	balance = 0.5 => in the middle of line
	balance = 0 => on the starting point of line
	balance = 1 => on the ending point of line"

	^ self new
		shape: aShape;
		edge: anEdge;
		balance: aFloat;
		offset: aNumber;
		stick;
		yourself
]

{ #category : #'public - sticking' }
OPRTEdgeAlongConstraint class >> stick: aShape alongEdge: anEdge offset: aNumber [
	"keeps position of aShape against anEdge, in the middle of edge, with orthogonal offset distance from it"

	^ self new
		shape: aShape;
		edge: anEdge;
		offset: aNumber;
		stick;
		yourself
]

{ #category : #accessing }
OPRTEdgeAlongConstraint >> balance: aBalance [
	balance := aBalance
]

{ #category : #running }
OPRTEdgeAlongConstraint >> fix [
	"a little math... reverse process of move: gets settings according to shape and edge positions"

	| startPoint endPoint nearestPoint edgeVector nearestPointVector positionVector edgeVectorR |
	startPoint := edge shape startingPointOf: edge.
	endPoint := edge shape endingPointOf: edge.
	edgeVector := endPoint - startPoint.
	nearestPoint := shape position nearestPointAlongLineFrom: startPoint to: endPoint.
	positionVector := shape position - nearestPoint.
	edgeVectorR := edgeVector r.
	offset := shape position dist: nearestPoint.
	(edgeVector + positionVector rightRotated) r > edgeVectorR
		ifTrue: [ offset := offset negated ].
	edgeVectorR < 5
		ifTrue: [ balance := 0.5 ]
		ifFalse: [ 
			nearestPointVector := nearestPoint - startPoint.
			edgeVector x = 0
				ifTrue: [ balance := nearestPointVector y / edgeVector y ]
				ifFalse: [ 
					edgeVector y = 0
						ifTrue: [ balance := nearestPointVector x / edgeVector x ]
						ifFalse: [ balance := nearestPointVector / edgeVector ] ] ].
	self stick
]

{ #category : #initialization }
OPRTEdgeAlongConstraint >> initialize [
	super initialize.
	balance := 0.5
]

{ #category : #running }
OPRTEdgeAlongConstraint >> move [
	"moves shape according to edge positions and settings"

	| vector startPoint endPoint |
	startPoint := edge shape startingPointOf: edge.
	endPoint := edge shape endingPointOf: edge.
	vector := endPoint - startPoint.
	^ shape translateTo: startPoint + (vector * balance) + (vector normal * offset)
]
