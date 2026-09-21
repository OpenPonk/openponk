Class {
	#name : 'OPDiagramGeometrySnapshotTest',
	#superclass : 'TestCase',
	#instVars : [
		'nodeModel',
		'shape',
		'snapshot',
		'canvas'
	],
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
}

{ #category : 'running' }
OPDiagramGeometrySnapshotTest >> setUp [
	super setUp.
	canvas := RSCanvas new.
	nodeModel := OPTestBoundNode new.
	nodeModel bounds: (OPNodeBounds withPosition: 100 @ 100 extent: 50 @ 50).
	nodeModel renderIn: canvas.
	shape := nodeModel roassalShape
]

{ #category : 'running' }
OPDiagramGeometrySnapshotTest >> tearDown [
	snapshot := nil.
	shape := nil.
	nodeModel := nil.
	canvas := nil.
	super tearDown
]

{ #category : 'tests' }
OPDiagramGeometrySnapshotTest >> testDeltaCommandsEmptyWhenNoGeometryChanged [
	snapshot := OPDiagramGeometrySnapshot onNodes: (RSGroup with: shape).
	self assert: snapshot deltaCommands isEmpty
]

{ #category : 'tests' }
OPDiagramGeometrySnapshotTest >> testDeltaCommandsGeneratesChangeAnchoredBoundsCommandWhenAnchorPresent [
	| anchorConstraint commands deltaCommand |
	anchorConstraint := Mock new.
	anchorConstraint stub balance willReturn: 0.4.
	anchorConstraint stub distanceToLine willReturn: 12.
	shape propertyAt: OPRSAnchorConstraint put: anchorConstraint.
	snapshot := OPDiagramGeometrySnapshot onNodes: (RSGroup with: shape).
	shape position: 140 @ 180.
	anchorConstraint stub balance willReturn: 0.75.
	anchorConstraint stub distanceToLine willReturn: 28.
	commands := snapshot deltaCommands.
	self assert: commands size equals: 1.
	deltaCommand := commands first.
	self assert: deltaCommand class equals: OPChangeAnchoredBoundsCommand.
	self assert: deltaCommand oldBalance equals: 0.4.
	self assert: deltaCommand newBalance equals: 0.75.
	self assert: deltaCommand oldDistanceToLine equals: 12.
	self assert: deltaCommand newDistanceToLine equals: 28
]

{ #category : 'tests' }
OPDiagramGeometrySnapshotTest >> testDeltaCommandsGeneratesChangeBoundsCommandWhenNodeMoved [
	| commands deltaCommand |
	snapshot := OPDiagramGeometrySnapshot onNodes: (RSGroup with: shape).
	shape position: 160 @ 220.
	commands := snapshot deltaCommands.
	self assert: commands size equals: 1.
	deltaCommand := commands first.
	self assert: deltaCommand class equals: OPChangeBoundsCommand.
	self assert: deltaCommand element equals: nodeModel.
	self assert: deltaCommand oldBounds position equals: 100 @ 100.
	self assert: deltaCommand newBounds position equals: 160 @ 220
]
