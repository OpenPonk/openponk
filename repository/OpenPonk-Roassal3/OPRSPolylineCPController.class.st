Class {
	#name : #OPRSPolylineCPController,
	#superclass : #RSAbstractCPController,
	#category : #'OpenPonk-Roassal3-Polyline'
}

{ #category : #hooks }
OPRSPolylineCPController >> controlPointsFor: aLine [

	| lineAttachPoint innerCPs firstSegmentTo lastSegmentFrom firstSegmentLine lastSegmentLine fromPoint toPoint |
	lineAttachPoint := aLine attachPoint.

	innerCPs := self innerControlPointsFor: aLine.

	innerCPs ifEmpty: [ 
		^ { 
			  (lineAttachPoint startingPointOf: aLine).
			  (lineAttachPoint endingPointOf: aLine) } ].

	"create temporary line with same path as first and last segment"
	firstSegmentTo := RSBox new
		                  size: 1;
		                  translateTo: innerCPs first.
	lastSegmentFrom := RSBox new
		                   size: 1;
		                   translateTo: innerCPs last.
	firstSegmentLine := RSLine new
		                    from: aLine from;
		                    to: firstSegmentTo;
		                    yourself.
	lastSegmentLine := RSLine new
		                   from: lastSegmentFrom;
		                   to: aLine to;
		                   yourself.

	"get attach points for the temporary lines representing first and last segment"
	fromPoint := lineAttachPoint startingPointOf: firstSegmentLine.
	toPoint := lineAttachPoint endingPointOf: lastSegmentLine.

	"disconnect temporary lines from the real from/to shapes"
	firstSegmentLine from: firstSegmentTo.
	lastSegmentLine to: lastSegmentFrom.

	^ { fromPoint } , innerCPs , { toPoint }
]

{ #category : #hooks }
OPRSPolylineCPController >> defaultInnerSelfControlPointsFor: aLine [

	| delta encompassingRectangle from corner to |
	delta := 30.
	encompassingRectangle := aLine from encompassingRectangle.
	from := encompassingRectangle topCenter.
	corner := encompassingRectangle topRight.
	to := encompassingRectangle rightCenter.

	^ Array
		  with: from + (0 @ delta negated)
		  with: corner + (delta @ delta negated)
		  with: to + (delta @ 0)
]

{ #category : #hooks }
OPRSPolylineCPController >> innerControlPointsFor: aLine [

	| currentInnerCPs defaultInnerCPs diffs |
	currentInnerCPs := aLine controlPoints
		                   copyFrom: 2
		                   to: aLine controlPoints size - 1.
	aLine from = aLine to ifFalse: [ ^ currentInnerCPs ].

	"self-loop"
	defaultInnerCPs := self defaultInnerSelfControlPointsFor: aLine.
	currentInnerCPs ifEmpty: [ ^ defaultInnerCPs ].
	currentInnerCPs size = defaultInnerCPs size ifFalse: [ 
		^ currentInnerCPs ].
	diffs := (1 to: currentInnerCPs size) collect: [ :index | 
		         (currentInnerCPs at: index) - (defaultInnerCPs at: index) ].
	(diffs allSatisfy: [ :each | 
		 each closeTo: diffs first absolutePrecision: 0.99 ]) ifTrue: [ 
		^ defaultInnerCPs ].
	^ currentInnerCPs
]
