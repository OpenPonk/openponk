Class {
	#name : #OPRSDraggableCPController,
	#superclass : #RSAbstractCPController,
	#instVars : [
		'selfLineDistance'
	],
	#category : #'OpenPonk-Roassal-Polyline'
}

{ #category : #'instance creation' }
OPRSDraggableCPController class >> withSelfLineDistance: aNumber [

	^ self new
		  selfLineDistance: aNumber;
		  yourself
]

{ #category : #hooks }
OPRSDraggableCPController >> controlPointsFor: aLine [

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
OPRSDraggableCPController >> defaultInnerSelfControlPointsFor: aLine [

	| delta encompassingRectangle |
	delta := 30.
	encompassingRectangle := aLine from encompassingRectangle.
	(aLine isKindOf: RSBezier) ifTrue: [ 
		^ Array
			  with: encompassingRectangle topRight + (0 @ (delta * 2 negated))
			  with: encompassingRectangle topRight + (delta * 2 @ 0) ].

	^ Array
		  with: encompassingRectangle topCenter + (0 @ delta negated)
		  with: encompassingRectangle topRight + (delta @ delta negated)
		  with: encompassingRectangle rightCenter + (delta @ 0)
]

{ #category : #initialization }
OPRSDraggableCPController >> initialize [

	super initialize.
	selfLineDistance := 35
]

{ #category : #hooks }
OPRSDraggableCPController >> innerControlPointsFor: aLine [

	| oldInnerCPs oldShapeEncompassingRectangle newShapeEncompassingRectangle |
	oldInnerCPs := aLine innerControlPoints.

	aLine from = aLine to ifFalse: [ ^ oldInnerCPs ].

	"self-loop"

	oldShapeEncompassingRectangle := aLine
		                                 propertyAt: self class
		                                 ifAbsent: [
		                                 ^ self
			                                   defaultInnerSelfControlPointsFor:
			                                   aLine ].

	newShapeEncompassingRectangle := aLine from encompassingRectangle.
	aLine propertyAt: self class put: newShapeEncompassingRectangle copy.

	^ oldInnerCPs collect: [ :each |
		  each + (Point
			   x: (each x < oldShapeEncompassingRectangle center x
					    ifTrue: [
						    newShapeEncompassingRectangle left
						    - oldShapeEncompassingRectangle left ]
					    ifFalse: [
						    newShapeEncompassingRectangle right
						    - oldShapeEncompassingRectangle right ])
			   y: (each y > oldShapeEncompassingRectangle center y
					    ifTrue: [
						    newShapeEncompassingRectangle bottom
						    - oldShapeEncompassingRectangle bottom ]
					    ifFalse: [
						    newShapeEncompassingRectangle top
						    - oldShapeEncompassingRectangle top ])) ]
]

{ #category : #accessing }
OPRSDraggableCPController >> selfLineDistance: aNumber [

	selfLineDistance := aNumber
]
