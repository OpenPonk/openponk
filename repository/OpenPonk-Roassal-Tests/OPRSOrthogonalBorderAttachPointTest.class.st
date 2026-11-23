"
Verifies orthogonal border attachment point calculation for horizontally overlapping, vertically overlapping, and diagonally separated shapes.
"
Class {
	#name : 'OPRSOrthogonalBorderAttachPointTest',
	#superclass : 'TestCase',
	#instVars : [
		'attachPoint'
	],
	#category : 'OpenPonk-Roassal-Tests-AttachPoints',
	#package : 'OpenPonk-Roassal-Tests',
	#tag : 'AttachPoints'
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
OPRSOrthogonalBorderAttachPointTest >> testGeometryShapesAndZeroExtentTargetRightAndBottomBranches [

	| ellipseShape polygonShape pointTarget lineToRightPoint lineToBottomPoint sourceBox gEllipse gPoint gPolygon gSegment |
	gEllipse := GEllipse center: 10 @ 20 vertex: 25 @ 20 coVertex: 10 @ 30.
	self assert: gEllipse left equals: -5.
	self assert: gEllipse right equals: 25.
	self assert: gEllipse top equals: 10.
	self assert: gEllipse bottom equals: 30.

	gPoint := GPoint x: 7 y: 13.
	self assert: gPoint left equals: 7.
	self assert: gPoint right equals: 7.
	self assert: gPoint top equals: 13.
	self assert: gPoint bottom equals: 13.

	gPolygon := GPolygon vertices: {
			            (0 @ 0).
			            (20 @ 5).
			            (10 @ 15) }.
	self assert: gPolygon left equals: 0.
	self assert: gPolygon right equals: 20.
	self assert: gPolygon top equals: 0.
	self assert: gPolygon bottom equals: 15.

	gSegment := GSegment with: 15 @ 30 with: 5 @ 10.
	self assert: gSegment left equals: 5.
	self assert: gSegment right equals: 15.
	self assert: gSegment top equals: 10.
	self assert: gSegment bottom equals: 30.

	ellipseShape := RSEllipse new
		                extent: 40 @ 20;
		                translateTo: 100 @ 50;
		                yourself.
	polygonShape := RSPolygon new
		                points: {
				                (0 @ 0).
				                (40 @ 0).
				                (20 @ 20) };
		                translateTo: 100 @ 150;
		                yourself.
	self
		assert: (attachPoint startingPointOf: (RSLine new
					  from: ellipseShape;
					  to: polygonShape;
					  attachPoint: attachPoint;
					  yourself)) y
		closeTo: ellipseShape encompassingRectangle bottom.

	sourceBox := RSBox new
		             extent: 20 @ 20;
		             translateTo: 10 @ 10;
		             yourself.
	pointTarget := RSBox new
		               extent: 0 @ 0;
		               translateTo: 20 @ 100;
		               yourself.
	lineToRightPoint := RSLine new
		                    from: sourceBox;
		                    to: pointTarget;
		                    attachPoint: attachPoint;
		                    yourself.
	self assert: (attachPoint startingPointOf: lineToRightPoint) y closeTo: sourceBox encompassingRectangle bottom.

	pointTarget translateTo: 100 @ 20.
	lineToBottomPoint := RSLine new
		                     from: sourceBox;
		                     to: pointTarget;
		                     attachPoint: attachPoint;
		                     yourself.
	self assert: (attachPoint startingPointOf: lineToBottomPoint) x closeTo: sourceBox encompassingRectangle right
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
OPRSOrthogonalBorderAttachPointTest >> testTargetContainedWithinSourceUsesOrthogonalBorderPoints [

	| wideSource narrowTarget verticalLine tallSource shortTarget horizontalLine |
	wideSource := RSBox new
		              extent: 200 @ 40;
		              translateTo: 100 @ 20;
		              yourself.
	narrowTarget := RSBox new
		                extent: 40 @ 40;
		                translateTo: 100 @ 120;
		                yourself.
	verticalLine := RSLine new
		                from: wideSource;
		                to: narrowTarget;
		                attachPoint: attachPoint;
		                yourself.
	self assert: (attachPoint startingPointOf: verticalLine) y closeTo: wideSource encompassingRectangle bottom.

	tallSource := RSBox new
		              extent: 40 @ 200;
		              translateTo: 20 @ 100;
		              yourself.
	shortTarget := RSBox new
		               extent: 40 @ 40;
		               translateTo: 120 @ 100;
		               yourself.
	horizontalLine := RSLine new
		                  from: tallSource;
		                  to: shortTarget;
		                  attachPoint: attachPoint;
		                  yourself.
	self assert: (attachPoint startingPointOf: horizontalLine) x closeTo: tallSource encompassingRectangle right
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
