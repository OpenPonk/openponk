"
I attach a RTElement to a RTEdge (works for both line and connection shapes). When the edge or it's extremities are moved, so is the anchor.

Furthermore I will try to move the Element in such a way that it doesn't overlap neither the edge, nor it's extremities, nor their other lines. I will not however prevent overlapping of another elements (e.g. another element or edge nearby).

!! API

==#balance: aNumber==
Specify where the anchor should be positioned. x \in [0, 1] for relative positions (so 0.5 will be exactly middle, 1 at the end, etc.).
x > 1 or x < 0 for absolute positioning. E.g.: 10 - position the anchor 10 pixels from the beginning; -20 - 20 pixels from the end

==#minDistance: aNumber==
A minimum distance (in pixels) that should be maintained between the edge and the element



"
Class {
	#name : #OPRTAnchorConstraint,
	#superclass : #Object,
	#instVars : [
		'element',
		'edge',
		'minDistance',
		'balance',
		'anchorElement',
		'guideEdge',
		'anchorShape',
		'guideLine'
	],
	#category : 'OpenPonk-Roassal2-Constraints'
}

{ #category : #example }
OPRTAnchorConstraint class >> example [
	| v es e rep anchor |
	v := RTView new.
	v @ RTDraggableView.
	v @ OPRTGridView.
	v @ RTZoomableView.

	es := RTBox new
		color: Color green;
		size: 20;
		elementsOn: #(1 2).
	e := OPRTStyledConnection new
		attachPoint: OPRTNewRectangleAttachPoint new;
		color: Color black;
		edgeFrom: es first to: es second.
	e @ OPRTConnectionHandles.

	rep := RTBox new
		color: Color purple;
		size: 20;
		element.
	v add: rep.
	rep translateBy: 30 @ 50.
	rep @ (RTDraggableSnapToGrid new gridSize: 20).

	v addAll: es.
	v add: e.

	anchor := OPRTAnchorConstraint new.
	anchor anchorShape size: 10.
	anchor
		element: rep;
		edge: e;
		balance: 0.5;
		minDistance: 10;
		build.

	es @ (RTDraggableSnapToGrid new gridSize: 20).

	es first translateTo: 70 negated @ 90 negated.
	es second translateTo: 70 @ 110.

	v open
]

{ #category : #example }
OPRTAnchorConstraint class >> example2 [
	| v es e rep anchor |
	v := RTView new.
	v @ RTDraggableView.
	v @ (RTGridView new gridSize: 20).
	v @ RTZoomableView.

	es := RTBox new
		color: Color green;
		size: 150;
		elementsOn: #(1 2).
	e := OPRTStyledConnection new
		attachPoint: OPRTNewRectangleAttachPoint new;
		color: Color black;
		edgeFrom: es first to: es second.
	e @ OPRTConnectionHandles.

	rep := RTBox new
		color: (Color purple alpha: 0.5);
		borderColor: Color purple;
		size: 50;
		width: 300;
		element.
	rep translateBy: 30 @ 50.
	rep @ RTDraggable.

	v addAll: es.
	v add: e.
	v add: rep.

	anchor := OPRTAnchorConstraint new.
	anchor anchorShape size: 10.
	anchor
		element: rep;
		edge: e;
		balance: -10;
		minDistance: 10;
		build.

	es @ (RTDraggableSnapToGrid new gridSize: 20).

	es first translateTo: 70 negated @ 100 negated.
	es second translateTo: 70 @ 110.

	v open
]

{ #category : #example }
OPRTAnchorConstraint class >> exampleSelfEdge [
| v e box start end createAnchor|
v := RTView new.
v @ RTDraggableView.
v @ OPRTGridView.
v @ RTZoomableView.

box := RTBox new
	color: Color green;
	width: 100;
	height: 50;
	element.
e := OPRTStyledConnection new
	attachPoint: OPRTNewRectangleAttachPoint new;
	color: Color black;
	edgeFrom: box to: box.
e shape decorations arrowHead.
e @ OPRTConnectionHandles.

start := RTLabel new
	color: Color black;
	elementsOn: #(sTop sBottom).
	
end := RTLabel new
	color: Color black;
	elementsOn: #(eTop eBottom).


v add: box.
v add: e.
v
	addAll: start;
	addAll: end.


createAnchor := [ :el :bal :side |
	OPRTAnchorConstraint new
		element: el;
		edge: e;
		balance: bal;
		minDistance: side * 5;
		build.
].

createAnchor value: start first value: 10 value: 1.
createAnchor value: start second value: 10 value: -1.

createAnchor value: end first value: -10 value: 1.
createAnchor value: end second value: -10 value: -1.

start @ OPRTRoundedDraggable.
end @ OPRTRoundedDraggable.

box @ (RTDraggableSnapToGrid new gridSize: 20).

box translateBy: 0@0.

v open
]

{ #category : #building }
OPRTAnchorConstraint >> addAnchor [
	anchorElement := self anchorShape element.
	element view add: anchorElement.
	guideEdge := self guideLine edgeFrom: element to: anchorElement.
	element view add: guideEdge
]

{ #category : #building }
OPRTAnchorConstraint >> anchorSegment [
	^ self segments segmentWithPointFor: self balance
]

{ #category : #accessing }
OPRTAnchorConstraint >> anchorShape [
	^ anchorShape
]

{ #category : #accessing }
OPRTAnchorConstraint >> balance [
	^ balance
]

{ #category : #accessing }
OPRTAnchorConstraint >> balance: aNumber [
	balance := aNumber
]

{ #category : #building }
OPRTAnchorConstraint >> build [
	self addAnchor.
	edge from addCallback: (TRTranslationCallback block: [ self update ]).
	edge to addCallback: (TRTranslationCallback block: [ self update ]).
	"Do a symbol-based check, because DCRTConnection is not (yet?) in Roassal"
	edge shape className asSymbol = #OPRTConnection
		| (edge shape className asSymbol = #OPRTStyledConnection)
		ifTrue: [ edge when: #OPRTHandleMoved asClass do: [ self update ] ].
	element
		when: TRMouseDragStart
		do: [ 
			guideLine color: Color gray.
			guideEdge update.
			guideEdge view signalUpdate ].
	element
		when: TRMouseDragEnd
		do:
			[ 
			guideLine color: Color transparent.
			guideEdge update.
			guideEdge view signalUpdate ]
]

{ #category : #'as yet unclassified' }
OPRTAnchorConstraint >> computeExtraDistance [
	"Compute the extra distance required to move the element to not overlap the segment."

	| segment sideOfElement normals |
	segment := self anchorSegment first.
	sideOfElement := segment sideOfPoint: element position.
	normals := element encompassingRectangle corners
		select: [ :each | (segment sideOfPoint: each) ~= sideOfElement ]
		thenCollect: [ :each | each dist: (each nearestPointAlongLineFrom: segment from to: segment to) ].
	normals ifEmpty: [ ^ 0 ].
	^ minDistance sign > 0
		ifTrue: [ normals max ]
		ifFalse: [ normals max negated ]
]

{ #category : #'as yet unclassified' }
OPRTAnchorConstraint >> connectionSegmentsFor: anEdge [
	^ (anEdge shape pathFor: anEdge)
		overlappingPairsCollect: [ :from :to | RTLineSegment from: from to: to ]
]

{ #category : #accessing }
OPRTAnchorConstraint >> edge [
	^ edge
]

{ #category : #accessing }
OPRTAnchorConstraint >> edge: anEdge [
	edge := anEdge
]

{ #category : #accessing }
OPRTAnchorConstraint >> element [
	^ element
]

{ #category : #accessing }
OPRTAnchorConstraint >> element: anElement [
	element := anElement
]

{ #category : #accessing }
OPRTAnchorConstraint >> guideLine [
	^ guideLine
]

{ #category : #initialization }
OPRTAnchorConstraint >> initialize [
	(anchorShape := RTEllipse new)
		size: 0;
		color: Color red.
	(guideLine := RTLine new) color: Color transparent
]

{ #category : #'as yet unclassified' }
OPRTAnchorConstraint >> lineSegmentFor: anEdge [
	^ anEdge lineSegments first
]

{ #category : #accessing }
OPRTAnchorConstraint >> minDistance [
	^ minDistance
]

{ #category : #accessing }
OPRTAnchorConstraint >> minDistance: anInteger [
	minDistance := anInteger
]

{ #category : #'as yet unclassified' }
OPRTAnchorConstraint >> moveAnchor [
	anchorElement translateTo: self anchorSegment last
]

{ #category : #'as yet unclassified' }
OPRTAnchorConstraint >> moveAwayFrom: aRectangle via: aVector [
	"There should be minDistance between the start and the element. Move it in the direction fo the current segment"

	| vector corners segment |
	"source and target of the edge on top of each other... ignore"
	aVector r = 0
		ifTrue: [ ^ self ].
	vector := aVector normalized * (aRectangle origin dist: aRectangle corner).
	corners := element encompassingRectangle corners
		select: [ :each | aRectangle containsPoint: each ].
	segment := (corners
		collect:
			[ :each | 
			| sg |
			sg := RTLineSegment from: each to: each + vector.
			RTLineSegment from: each to: (sg intersectRectangle: aRectangle) anyOne ])
		detectMax: #length.
	segment ifNotNil: [ element translateBy: segment vector ]
	"	segment
		ifNotNil:
			[ element view
				add:
					(RTSVGPath new
						path:
							'M' , segment from x asString , ',' , segment from y asString , 'L' , segment to x asString
								, ',' , segment to y asString;
						element) ]"
]

{ #category : #'as yet unclassified' }
OPRTAnchorConstraint >> moveAwayFromSegment: aSegment [
	(aSegment intersectRectangle: element encompassingRectangle)
		ifNotEmpty:
			[ :crossings | 
			element
				translateBy:
					aSegment vector normal
						* (minDistance + self computeExtraDistance) negated ]
]

{ #category : #'as yet unclassified' }
OPRTAnchorConstraint >> moveElement [
	| segment from to |
	segment := self anchorSegment first.
	element
		translateTo: anchorElement position + (segment vector normal * minDistance negated).
	self moveAwayFromSegment: segment.
	from := edge from encompassingRectangle expandBy: minDistance abs.
	to := edge to encompassingRectangle expandBy: minDistance abs.
	balance > 0 & (element encompassingRectangle intersects: from)
		ifTrue: [ self moveAwayFrom: from via: segment vector ].
	balance < 0 & (element encompassingRectangle intersects: to)
		ifTrue: [ self moveAwayFrom: to via: segment vector negated ]
]

{ #category : #removing }
OPRTAnchorConstraint >> remove [
	anchorElement view ifNotNil: [ anchorElement remove ].
	guideEdge view ifNotNil: [ guideEdge remove ]
]

{ #category : #accessing }
OPRTAnchorConstraint >> segments [
	(edge shape isKindOf: OPRTConnection)
		ifTrue: [ ^ OPRTPolyLineSegment withAll: (self connectionSegmentsFor: edge) ].
	(edge shape isKindOf: RTBezierLine)
		ifTrue: [ ^ self notYetImplemented ].
	^ OPRTPolyLineSegment with: (self lineSegmentFor: edge)
]

{ #category : #updating }
OPRTAnchorConstraint >> update [
	self moveAnchor.
	self moveElement
]
