"
Verifies anchor constraint attachment, balance and fixed-distance references, guide line lifecycle, and shape updates upon line movement.
"
Class {
	#name : 'OPRSAnchorConstraintTest',
	#superclass : 'TestCase',
	#instVars : [
		'canvas',
		'sourceBox',
		'targetBox',
		'line',
		'anchoredShape',
		'constraint'
	],
	#category : 'OpenPonk-Roassal-Tests',
	#package : 'OpenPonk-Roassal',
	#tag : 'Tests'
}

{ #category : 'running' }
OPRSAnchorConstraintTest >> setUp [
	super setUp.
	canvas := RSCanvas new.
	sourceBox := RSBox new
		size: 20;
		translateTo: 0 @ 0;
		yourself.
	targetBox := RSBox new
		size: 20;
		translateTo: 200 @ 0;
		yourself.
	line := RSPolyline new
		from: sourceBox;
		to: targetBox;
		controlPoints: { 0 @ 0 . 200 @ 0 };
		yourself.
	anchoredShape := RSBox new
		size: 10;
		yourself.
	canvas
		add: sourceBox;
		add: targetBox;
		add: line;
		add: anchoredShape.
	constraint := OPRSAnchorConstraint new
]

{ #category : 'running' }
OPRSAnchorConstraintTest >> tearDown [
	constraint ifNotNil: [
		(constraint shape isNotNil and: [ constraint line isNotNil ])
			ifTrue: [ constraint remove ] ].
	constraint := nil.
	anchoredShape := nil.
	line := nil.
	sourceBox := nil.
	targetBox := nil.
	canvas := nil.
	super tearDown
]

{ #category : 'tests' }
OPRSAnchorConstraintTest >> testBalanceReferenceMovesShapeAndSavesPosition [
	constraint
		balance: 0.5;
		minDistanceToLine: 20;
		alwaysShowGuideLine;
		stick: anchoredShape on: line.
	self assert: constraint shape equals: anchoredShape.
	self assert: constraint line equals: line.
	self assert: constraint balance equals: 0.5.
	self assert: constraint minDistanceToLine equals: 20.
	self assert: constraint distanceToLine equals: 20.
	self assert: constraint anchorState equals: #(0.5 20).
	self
		assert: constraint anchorShape isInACanvas
		description: 'Anchor shape should be added to canvas when alwaysShowGuideLine is enabled'.
	self
		assert: constraint guideLine isInACanvas
		description: 'Guide line should be added to canvas when alwaysShowGuideLine is enabled'.
	self assert: anchoredShape position x closeTo: 100.
	anchoredShape translateTo: 50 @ 30.
	constraint saveShapePosition.
	self
		assert: (constraint balance between: 0.2 and: 0.3)
		description: 'Saved balance should reflect new relative position along line'.
	self
		assert: constraint distanceToLine > 0
		description: 'Saved distanceToLine should be positive when shape is below horizontal line'
]

{ #category : 'tests' }
OPRSAnchorConstraintTest >> testRemoveDetachesAnchorAndGuideLine [
	constraint
		balance: 0.5;
		alwaysShowGuideLine;
		stick: anchoredShape on: line.
	self
		assert: constraint anchorShape isInACanvas
		description: 'Anchor shape should be in canvas before removal'.
	self
		assert: constraint guideLine isInACanvas
		description: 'Guide line should be in canvas before removal'.
	constraint remove.
	self
		deny: constraint anchorShape isInACanvas
		description: 'Anchor shape should be removed from canvas after constraint removal'.
	self
		deny: constraint guideLine isInACanvas
		description: 'Guide line should be removed from canvas after constraint removal'
]

{ #category : 'tests' }
OPRSAnchorConstraintTest >> testStartAndEndAndBalanceReferences [
	| startRef endRef balanceRef segments startAssoc endAssoc balanceAssoc |
	constraint
		balance: 0.5;
		stick: anchoredShape on: line.
	segments := constraint createUpdater segments.

	startRef := OPRSAnchorConstraintStartDistanceReference distance: 15.
	self assert: (startRef guideLineTargetFor: constraint) identicalTo: constraint anchorShape.
	self assert: (startRef computeAbsoluteBalanceForLength: 100) equals: 15.
	self assert: (startRef segmentIn: constraint) from equals: segments first from.
	self assert: (startRef referencePointOfSegment: segments first) equals: segments first from.
	self assert: (startRef farPointOfSegment: segments first) equals: segments first to.
	startAssoc := startRef anchorSegmentFrom: segments andPointFrom: 15.
	self assert: startAssoc key equals: segments first.
	anchoredShape translateTo: 25 @ 10.
	startRef saveShapePositionIn: constraint.
	self
		assert: (startRef computeAbsoluteBalanceForLength: 100) > 0
		description: 'Saved start distance should be positive'.

	endRef := OPRSAnchorConstraintEndDistanceReference distance: 20.
	self assert: (endRef computeAbsoluteBalanceForLength: 100) equals: 80.
	self assert: (endRef segmentIn: constraint) to equals: segments last to.
	self assert: (endRef referencePointOfSegment: segments last) equals: segments last to.
	self assert: (endRef farPointOfSegment: segments last) equals: segments last from.
	endAssoc := endRef anchorSegmentFrom: segments andPointFrom: 80.
	self assert: endAssoc key equals: segments last.
	endRef saveShapePositionIn: constraint.
	self
		assert: (endRef computeAbsoluteBalanceForLength: 200) < 200
		description: 'Saved end distance should be less than total length'.

	balanceRef := OPRSAnchorConstraintBalanceReference balance: 0.5.
	self assert: balanceRef balance equals: 0.5.
	self assert: (balanceRef computeAbsoluteBalanceForLength: 100) equals: 50.0.
	balanceAssoc := balanceRef anchorSegmentFrom: segments andPointFrom: 50.
	self assert: balanceAssoc value equals: 50 @ 0.
	self
		should: [ balanceRef anchorSegmentFrom: segments andPointFrom: 500 ]
		raise: Error.
	balanceRef saveShapePositionIn: constraint.
	self
		assert: (balanceRef balance between: 0 and: 1)
		description: 'Saved balance should lie between 0 and 1'
]

{ #category : 'tests' }
OPRSAnchorConstraintTest >> testStartAndEndDistanceReferencesAndGuideLineModes [
	| updater |
	constraint
		positionFromStart: 40;
		distanceToLine: 15;
		noGuideLine;
		stick: anchoredShape on: line.
	self assert: constraint guideLine color equals: Color transparent.
	self assert: constraint balance equals: nil.
	constraint moveShape.
	self assert: anchoredShape position x closeTo: 40.
	anchoredShape translateTo: 60 @ 25.
	constraint saveShapePosition.
	updater := constraint createUpdater.
	self assert: updater lengthFromStartOfBalance closeTo: 60.
	constraint
		positionFromEnd: 30;
		useGuideLine;
		moveShape.
	self assert: anchoredShape position x closeTo: 170.
	anchoredShape translateTo: 150 @ -25.
	constraint saveShapePosition.
	self assert: constraint createUpdater lengthFromStartOfBalance closeTo: 150
]
