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
	#category : 'OpenPonk-Roassal-Tests-AnchorConstraint',
	#package : 'OpenPonk-Roassal-Tests',
	#tag : 'AnchorConstraint'
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
OPRSAnchorConstraintTest >> testAddAnchorAndGuideLineIsIdempotentAndMinDistancePreservesLargerDistance [

	| canvasShapeCountBefore |
	constraint
		balance: 0.5;
		distanceToLine: 30;
		minDistanceToLine: 10;
		alwaysShowGuideLine;
		stick: anchoredShape on: line.
	self assert: constraint minDistanceToLine equals: 10.
	self assert: constraint distanceToLine equals: 30.
	canvasShapeCountBefore := canvas shapes size.
	constraint addAnchorAndGuideLine.
	self assert: canvas shapes size equals: canvasShapeCountBefore
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
	self assert: constraint anchorState equals: #( 0.5 20 ).
	self
		assert: constraint anchorShape isInACanvas
		description: 'Anchor shape should be added to canvas when alwaysShowGuideLine is enabled'.
	self
		assert: constraint guideLine isInACanvas
		description: 'Guide line should be added to canvas when alwaysShowGuideLine is enabled'.
	self assert: anchoredShape position x closeTo: 100.
	anchoredShape translateTo: 50 @ 30.
	constraint saveShapePosition.
	self assert: constraint balance closeTo: 0.25.
	self assert: constraint distanceToLine closeTo: 25.0
]

{ #category : 'tests' }
OPRSAnchorConstraintTest >> testBuildEventsMoveAndSaveShapeAndRemoveOnShapeOrLineRemoval [

	| secondConstraint secondShape |
	constraint
		balance: 0.5;
		distanceToLine: 20;
		alwaysShowGuideLine;
		stick: anchoredShape on: line.
	sourceBox translateTo: 20 @ 0.
	line controlPoints: {
			(20 @ 0).
			(200 @ 0) }.
	sourceBox extent: 30 @ 30.
	targetBox translateTo: 220 @ 0.
	line controlPoints: {
			(20 @ 0).
			(220 @ 0) }.
	targetBox extent: 30 @ 30.
	line announce: OPRSDraggedControlPointsEvent new.
	line announce: RSPositionChangedEvent new.
	self assert: anchoredShape position x closeTo: 120.

	anchoredShape translateTo: 70 @ 25.
	anchoredShape announce: RSMouseDragging new.
	self assert: constraint balance closeTo: 0.25.

	anchoredShape remove.
	self deny: constraint anchorShape isInACanvas description: 'Removing anchored shape should remove anchor constraint'.

	secondShape := RSBox new
		               size: 10;
		               yourself.
	canvas add: secondShape.
	secondConstraint := OPRSAnchorConstraint new
		                    balance: 0.5;
		                    alwaysShowGuideLine;
		                    stick: secondShape on: line;
		                    yourself.
	line remove.
	self deny: secondConstraint anchorShape isInACanvas description: 'Removing line should remove anchor constraint'
]

{ #category : 'tests' }
OPRSAnchorConstraintTest >> testBuildGuardsNilLineAndDeferredAlwaysShowGuideLine [

	| partialConstraint deferredShape |
	partialConstraint := OPRSAnchorConstraint new.
	partialConstraint stick: anchoredShape on: nil.
	self assert: (anchoredShape propertyAt: OPRSAnchorConstraint) identicalTo: partialConstraint.
	self deny: partialConstraint anchorShape isInACanvas description: 'Build with nil line should not add anchor shape to canvas'.

	deferredShape := RSBox new
		                 size: 10;
		                 yourself.
	constraint
		balance: 0.5;
		alwaysShowGuideLine;
		stick: deferredShape on: line.
	self deny: constraint anchorShape isInACanvas description: 'Anchor shape should wait until anchored shape is added to canvas'.
	canvas add: deferredShape.
	self
		assert: constraint anchorShape isInACanvas
		description: 'Adding anchored shape to canvas should trigger deferred anchor and guide line addition'
]

{ #category : 'tests' }
OPRSAnchorConstraintTest >> testDragStartAndEndToggleGuideLineWhenNotAlwaysShown [

	constraint
		balance: 0.5;
		stick: anchoredShape on: line.
	self
		deny: constraint anchorShape isInACanvas
		description: 'Anchor shape should be hidden before drag when alwaysShowGuideLine is false'.
	anchoredShape announce: RSMouseLeftDragStart new.
	self assert: constraint anchorShape isInACanvas description: 'Drag start should add anchor shape to canvas'.
	self assert: constraint guideLine isInACanvas description: 'Drag start should add guide line to canvas'.
	anchoredShape announce: RSMouseDragEnd new.
	self deny: constraint anchorShape isInACanvas description: 'Drag end should remove anchor shape from canvas'.
	self deny: constraint guideLine isInACanvas description: 'Drag end should remove guide line from canvas'
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
OPRSAnchorConstraintTest >> testRemoveHandlesMissingEndpointsAndUnattachedConstraint [

	| endpointlessLine unattachedConstraint |
	unattachedConstraint := OPRSAnchorConstraint new.
	unattachedConstraint remove.
	self assert: unattachedConstraint shape identicalTo: nil.
	endpointlessLine := RSPolyline new
		                    controlPoints: {
				                    (0 @ 0).
				                    (100 @ 0) };
		                    yourself.
	canvas add: endpointlessLine.
	constraint
		balance: 0.5;
		stick: anchoredShape on: endpointlessLine.
	constraint remove.
	self
		deny: (endpointlessLine announcer subscriptions subscriptions anySatisfy: [ :each | each subscriber == constraint ])
		description: 'Endpointless line announcer should unsubscribe removed anchor constraint'
]

{ #category : 'tests' }
OPRSAnchorConstraintTest >> testRemoveUnsubscribesFromLineEvents [

	| positionAfterRemove |
	constraint
		balance: 0.5;
		distanceToLine: 20;
		stick: anchoredShape on: line.
	constraint remove.
	self
		deny: (line announcer subscriptions subscriptions anySatisfy: [ :each | each subscriber == constraint ])
		description: 'Line announcer should unsubscribe removed anchor constraint'.
	anchoredShape translateTo: 500 @ 500.
	positionAfterRemove := anchoredShape position.
	line announce: RSPositionChangedEvent new.
	line announce: OPRSDraggedControlPointsEvent new.
	self assert: anchoredShape position equals: positionAfterRemove
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
	self assert: (startRef computeAbsoluteBalanceForLength: 100) closeTo: 25.0.

	endRef := OPRSAnchorConstraintEndDistanceReference distance: 20.
	self assert: (endRef computeAbsoluteBalanceForLength: 100) equals: 80.
	self assert: (endRef segmentIn: constraint) to equals: segments last to.
	self assert: (endRef referencePointOfSegment: segments last) equals: segments last to.
	self assert: (endRef farPointOfSegment: segments last) equals: segments last from.
	endAssoc := endRef anchorSegmentFrom: segments andPointFrom: 80.
	self assert: endAssoc key equals: segments last.
	endRef saveShapePositionIn: constraint.
	self assert: (endRef computeAbsoluteBalanceForLength: 200) closeTo: 25.0.

	balanceRef := OPRSAnchorConstraintBalanceReference balance: 0.5.
	self assert: balanceRef balance equals: 0.5.
	self assert: (balanceRef computeAbsoluteBalanceForLength: 100) equals: 50.0.
	balanceAssoc := balanceRef anchorSegmentFrom: segments andPointFrom: 50.
	self assert: balanceAssoc value equals: 50 @ 0.
	self should: [ balanceRef anchorSegmentFrom: segments andPointFrom: 500 ] raise: Error.
	balanceRef saveShapePositionIn: constraint.
	self assert: balanceRef balance closeTo: 0.125
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
	self assert: constraint balance identicalTo: nil.
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

{ #category : 'tests' }
OPRSAnchorConstraintTest >> testUpdaterAnchorSegmentLazyComputationAndComputeExtraDistanceForZeroExtent [

	| updater zeroShape zeroUpdater |
	constraint
		balance: 0.5;
		distanceToLine: 20;
		stick: anchoredShape on: line.
	updater := constraint createUpdater.
	self assert: updater anchorSegment equals: (OPRSAnchorConstraintSegment from: 0 @ 0 to: 200 @ 0).

	zeroShape := RSBox new
		             extent: 0 @ 0;
		             translateTo: 100 @ 0;
		             yourself.
	canvas add: zeroShape.
	zeroUpdater := OPRSAnchorConstraintUpdater new
		               line: line;
		               shape: zeroShape;
		               positionReference: (OPRSAnchorConstraintBalanceReference balance: 0.5);
		               distanceToLine: 20;
		               minDistanceToLine: 0;
		               yourself.
	self assert: zeroUpdater computeExtraDistance equals: 0
]
