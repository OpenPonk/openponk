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
