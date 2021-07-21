Class {
	#name : #OPRTStyledConnectionTest,
	#superclass : #TestCase,
	#instVars : [
		'from',
		'to',
		'edge',
		'view'
	],
	#category : 'OpenPonk-Roassal2-Tests'
}

{ #category : #running }
OPRTStyledConnectionTest >> setUp [
	from := RTBox new
		size: 20;
		element.
	to := RTBox new
		size: 20;
		element.
	view := RTView new
]

{ #category : #tests }
OPRTStyledConnectionTest >> testChangeHead [
	edge := OPRTStyledConnection new edgeFrom: from to: to.
	view add: edge.
	self assert: edge shape head shape equals: RTNoDecorationShape.
	self
		assert: (edge trachelShape shapes atLast: 2) class
		equals: RTNoDecorationShape trachelShapeClass.

	edge shape head: RTSimpleArrow asHead.
	edge update.
	self assert: edge shape head shape equals: RTSimpleArrow.
	self
		assert: (edge trachelShape shapes atLast: 2) class
		equals: RTSimpleArrow trachelShapeClass
]

{ #category : #tests }
OPRTStyledConnectionTest >> testChangeTail [
	edge := OPRTStyledConnection new edgeFrom: from to: to.
	view add: edge.
	self assert: edge shape tail shape equals: RTNoDecorationShape.
	self
		assert: edge trachelShape shapes last class
		equals: RTNoDecorationShape trachelShapeClass.

	edge shape tail: RTSimpleArrow asTail.
	edge update.
	self assert: edge shape tail shape equals: RTSimpleArrow.
	self assert: edge trachelShape shapes last class equals: RTSimpleArrow trachelShapeClass
]

{ #category : #tests }
OPRTStyledConnectionTest >> testPath [
	edge := OPRTStyledConnection new edgeFrom: from to: to.
	view add: edge.
	self
		assert: (edge shape pathFor: edge)
		equals: (Array with: from position with: to position).
	edge shape addPoint: 50 @ 100.
	self
		assert: (edge shape pathFor: edge)
		equals: (Array with: from position with: 50 @ 100 with: to position)
]

{ #category : #tests }
OPRTStyledConnectionTest >> testPath2 [
	from translateTo: 0 @ 0.
	to translateTo: 100 @ 0.
	edge := OPRTStyledConnection new
		attachPoint: OPRTNewRectangleAttachPoint new;
		edgeFrom: from to: to.
	view add: edge.
	self
		assert: (edge shape pathFor: edge)
		equals:
			{(from position + ((from width / 2) @ 0)).
			(to position - ((to width / 2) @ 0))}
]
