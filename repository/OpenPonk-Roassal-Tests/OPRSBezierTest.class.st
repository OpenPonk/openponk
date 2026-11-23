"
Unit tests verifying curve sampling and hit-testing inclusion radius for custom Bezier line shapes.
"
Class {
	#name : 'OPRSBezierTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Roassal-Tests-Polyline',
	#package : 'OpenPonk-Roassal-Tests',
	#tag : 'Polyline'
}

{ #category : 'tests' }
OPRSBezierTest >> testIncludedRadiusAddsOffsetToSuper [

	| bezier superBezier |
	bezier := OPRSBezier new
		          border: (RSBorder new
				           width: 4;
				           yourself);
		          yourself.
	superBezier := RSBezier new
		               border: (RSBorder new
				                width: 4;
				                yourself);
		               yourself.
	self assert: bezier includedRadius equals: superBezier includedRadius + 3
]

{ #category : 'tests' }
OPRSBezierTest >> testLinesReturnsNilForFewerThanThreeControlPoints [

	| bezier |
	bezier := OPRSBezier new
		          controlPoints: {
				          (0 @ 0).
				          (100 @ 0) };
		          yourself.
	self assert: bezier lines identicalTo: nil
]

{ #category : 'tests' }
OPRSBezierTest >> testLinesSamplesQuadraticAndCubicCurves [

	| quadratic cubic quadraticPoints cubicPoints |
	quadratic := OPRSBezier new
		             controlPoints: {
				             (0 @ 0).
				             (50 @ 100).
				             (100 @ 0) };
		             yourself.
	quadraticPoints := quadratic lines.
	self assert: quadraticPoints size equals: 21.
	self assert: quadraticPoints first equals: 0 @ 0.
	self assert: quadraticPoints last closeTo: 100 @ 0.

	cubic := OPRSBezier new
		         controlPoints: {
				         (0 @ 0).
				         (0 @ 100).
				         (100 @ 100).
				         (100 @ 0) };
		         yourself.
	cubicPoints := cubic lines.
	self assert: cubicPoints size equals: 21.
	self assert: cubicPoints first equals: 0 @ 0.
	self assert: cubicPoints last closeTo: 100 @ 0.
	self assert: (cubicPoints at: 11) closeTo: 50 @ 75
]
