Class {
	#name : 'DCRTEdgeLabelLayoutTest',
	#superclass : 'TestCase',
	#instVars : [
		'view',
		'elements',
		'edge',
		'layout',
		'label'
	],
	#category : 'DynaCASE-Layouting-GlobalEdgeLabels',
	#package : 'DynaCASE-Layouting',
	#tag : 'GlobalEdgeLabels'
}

{ #category : 'asserting' }
DCRTEdgeLabelLayoutTest >> assertPosition: actual equals: expected [
	#(#ranking #maxRanking #position #orientation #bounds)
		do: [ :each | self assert: (actual perform: each) equals: (expected perform: each) ]
]

{ #category : 'instance creation' }
DCRTEdgeLabelLayoutTest >> initialPositions [
	^ {(DCRTLPosition new
		ranking: 1 of: 3;
		orientation: #topRight;
		position: 45 @ -20;
		bounds: (26 @ -39 corner: 64 @ -1)).
	(DCRTLPosition new
		ranking: 1 of: 3;
		orientation: #bottomRight;
		position: 45 @ 20;
		bounds: (26 @ 1 corner: 64 @ 39)).
	(DCRTLPosition new
		ranking: 1 of: 3;
		orientation: #bottomLeft;
		position: 5 @ 20;
		bounds: (-14 @ 1 corner: 24 @ 39)).
	(DCRTLPosition new
		ranking: 1 of: 3;
		orientation: #topLeft;
		position: 5 @ -20;
		bounds: (-14 @ -39 corner: 24 @ -1))}
]

{ #category : 'instance creation' }
DCRTEdgeLabelLayoutTest >> positions [
	^ {(label
		->
			{(DCRTLPositionNode new
				model: self initialPositions first;
				index: 1).
			(DCRTLPositionNode new
				model: self initialPositions second;
				index: 2)})} asOrderedDictionary
]

{ #category : 'running' }
DCRTEdgeLabelLayoutTest >> setUp [
	view := RTView new.
	elements := RTBox new
		size: 20;
		elementsOn: #(#A #B).
	elements second translateTo: 100 @ 0.
	view addAll: elements.
	edge := RTLine new
		attachPoint: RTRectangleAttachPoint new;
		edgeFrom: elements first to: elements second.
	label := RTBox new
		size: 38;
		elementOn: edge.
	layout := DCRTEdgeLabelLayout new.
	layout spacing: 50.
	layout elements: elements.
	layout edges: {edge}.
	layout labels: {label}
]

{ #category : 'tests' }
DCRTEdgeLabelLayoutTest >> testEdgeMarks [
	| marks |
	layout spacing: 30.
	marks := layout edgeMarksFor: edge.
	self
		assert: marks
		equals:
			{(25 @ 0).
			(40 @ 0).
			(70 @ 0).
			(75 @ 0)}
]

{ #category : 'tests' }
DCRTEdgeLabelLayoutTest >> testIndexPositions [
	| positions |
	positions := layout removeFeatureOverlapsFor: label positions: self initialPositions.
	positions := (layout indexPositions: {(label -> positions)} asDictionary) at: label.
	self assertPosition: positions first model equals: self initialPositions first.
	self assert: positions first index equals: 1.
	self assertPosition: positions second model equals: self initialPositions second.
	self assert: positions second index equals: 2
]

{ #category : 'tests' }
DCRTEdgeLabelLayoutTest >> testInitialPositions [
	| positions |
	layout spacing: 50.
	positions := layout initialPositionsFor: label.
	self assert: positions size equals: 12.
	self assertPosition: positions first equals: self initialPositions first.
	self assertPosition: positions second equals: self initialPositions second.
	self assertPosition: positions third equals: self initialPositions third.
	self assertPosition: positions fourth equals: self initialPositions fourth
]

{ #category : 'tests' }
DCRTEdgeLabelLayoutTest >> testOverlapGraphFor [
	| graph |
	graph := layout overlapGraphFor: self positions.
	self assert: graph nodes size equals: 3.
	self assert: (graph nodes select: #isFeature) size equals: 1.
	self assert: (graph nodes select: #isPosition) size equals: 2.
	self assert: graph edges size equals: 2
]

{ #category : 'tests' }
DCRTEdgeLabelLayoutTest >> testRemoveFeatureOverlaps [
	| positions |
	positions := layout removeFeatureOverlapsFor: label positions: self initialPositions.
	self assert: positions size equals: 2.
	self assertPosition: positions first equals: self initialPositions first.
	self assertPosition: positions second equals: self initialPositions second
]
