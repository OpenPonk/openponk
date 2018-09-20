Class {
	#name : #OPRTAnchorConstraintTest,
	#superclass : #TestCase,
	#instVars : [
		'source',
		'target',
		'edge',
		'edgeElement',
		'edgeAnchor',
		'connection',
		'connectionElement',
		'connectionAnchor',
		'view',
		'segment',
		'expected'
	],
	#category : 'OpenPonk-Roassal2-Tests'
}

{ #category : #'instance creation' }
OPRTAnchorConstraintTest >> createConnectionAnchor [
	connection := OPRTStyledConnection new
		attachPoint: OPRTNewRectangleAttachPoint new;
		edgeFrom: source to: target.
	connection shape addPoint: 0 @ 50.
	connection shape addPoint: 50 @ 100.
	connectionElement := RTBox new
		width: 50;
		height: 20;
		element.
	view add: connection.
	view add: connectionElement.
	connectionAnchor := OPRTAnchorConstraint new.
	connectionAnchor
		element: connectionElement;
		edge: connection;
		balance: 0;
		minDistance: 0;
		build
]

{ #category : #'instance creation' }
OPRTAnchorConstraintTest >> createEdgeAnchor [
	edge := RTLine new
		attachPoint: RTBorderAttachPoint new;
		edgeFrom: source to: target.
	edgeElement := RTBox new
		width: 50;
		height: 20;
		element.
	view add: edge.
	view add: edgeElement.
	edgeAnchor := OPRTAnchorConstraint new.
	edgeAnchor
		element: edgeElement;
		edge: edge;
		balance: 0;
		minDistance: 0;
		build
]

{ #category : #running }
OPRTAnchorConstraintTest >> setUp [
	view := RTView new.
	source := RTBox new
		size: 30;
		element.
	target := RTBox new
		size: 30;
		element.
	view add: source.
	view add: target.
	source translateTo: 0 @ 0.
	target translateTo: 100 @ 100.
	self createEdgeAnchor.
	self createConnectionAnchor
]

{ #category : #tests }
OPRTAnchorConstraintTest >> testConnectionPath [
	self
		assert: (connection shape pathFor: connection)
		equals:
			{(0 @ (source height / 2)).
			(0 @ 50).
			(50 @ 100).
			((100 - (target width / 2)) @ 100)}
]

{ #category : #tests }
OPRTAnchorConstraintTest >> testConnectionSegmentsFor [
	| segments |
	expected := {(RTLineSegment from: 0 @ (source height / 2) to: 0 @ 50).
	(RTLineSegment from: 0 @ 50 to: 50 @ 100).
	(RTLineSegment from: 50 @ 100 to: (100 - (target width / 2)) @ 100)}.
	segments := connectionAnchor connectionSegmentsFor: connection.
	self assert: segments equals: expected.
	self assert: connectionAnchor segments segments equals: expected
]

{ #category : #tests }
OPRTAnchorConstraintTest >> testLineSegmentFor [
	true
		ifTrue: [ ^ self skip: 'Not sure what the problem is here' ].
	segment := edgeAnchor lineSegmentFor: edge.
	self assert: segment from equals: source position.
	self assert: segment to equals: target position
]
