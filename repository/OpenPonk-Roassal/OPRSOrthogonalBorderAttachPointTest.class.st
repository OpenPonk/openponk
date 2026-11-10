"
Verifies orthogonal border attachment point calculation for horizontally overlapping, vertically overlapping, and diagonally separated shapes.
"
Class {
	#name : 'OPRSOrthogonalBorderAttachPointTest',
	#superclass : 'TestCase',
	#instVars : [
		'attachPoint'
	],
	#category : 'OpenPonk-Roassal-Tests',
	#package : 'OpenPonk-Roassal',
	#tag : 'Tests'
}

{ #category : 'running' }
OPRSOrthogonalBorderAttachPointTest >> setUp [
	super setUp.
	attachPoint := OPRSOrthogonalBorderAttachPoint new
]

{ #category : 'tests' }
OPRSOrthogonalBorderAttachPointTest >> testDiagonalNonOverlappingFallsBackToBorderAttachPoint [
	| source target line startPoint |
	source := RSBox new extent: 20 @ 20; translateTo: 0 @ 0; yourself.
	target := RSBox new extent: 20 @ 20; translateTo: 200 @ 200; yourself.
	line := RSLine new from: source; to: target; attachPoint: attachPoint; yourself.
	startPoint := attachPoint startingPointOf: line.
	self assert: startPoint equals: 10 @ 10
]

{ #category : 'tests' }
OPRSOrthogonalBorderAttachPointTest >> testHorizontalOverlapUsesOrthogonalYBorderPoint [
	| source target line startPoint endPoint sourceRect targetRect |
	source := RSBox new extent: 40 @ 60; translateTo: 50 @ 100; yourself.
	target := RSBox new extent: 40 @ 60; translateTo: 150 @ 110; yourself.
	sourceRect := source encompassingRectangle.
	targetRect := target encompassingRectangle.
	line := RSLine new from: source; to: target; attachPoint: attachPoint; yourself.
	startPoint := attachPoint startingPointOf: line.
	endPoint := attachPoint endingPointOf: line.
	self assert: startPoint x closeTo: sourceRect right.
	self assert: endPoint x closeTo: targetRect left.
	self
		assert: (startPoint y between: sourceRect top and: sourceRect bottom)
		description: 'Orthogonal start point Y should lie within vertical bounds of source shape'
]

{ #category : 'tests' }
OPRSOrthogonalBorderAttachPointTest >> testVerticalOverlapUsesOrthogonalXBorderPoint [
	| source target line startPoint endPoint sourceRect targetRect |
	source := RSBox new extent: 60 @ 40; translateTo: 100 @ 50; yourself.
	target := RSBox new extent: 60 @ 40; translateTo: 110 @ 150; yourself.
	sourceRect := source encompassingRectangle.
	targetRect := target encompassingRectangle.
	line := RSLine new from: source; to: target; attachPoint: attachPoint; yourself.
	startPoint := attachPoint startingPointOf: line.
	endPoint := attachPoint endingPointOf: line.
	self assert: startPoint y closeTo: sourceRect bottom.
	self assert: endPoint y closeTo: targetRect top.
	self
		assert: (startPoint x between: sourceRect left and: sourceRect right)
		description: 'Orthogonal start point X should lie within horizontal bounds of source shape'
]
