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
	#superclass : #RTAnchorConstraint,
	#category : #'OpenPonk-Roassal2-Constraints'
}

{ #category : #example }
OPRTAnchorConstraint class >> example [
	| v es e rep anchor |
	v := RTView new.
	v @ RTDraggableView.
	v @ RTGridView.
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
	rep @ (OPRTDraggableSnapToGrid new gridSize: 20).

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

	es @ (OPRTDraggableSnapToGrid new gridSize: 20).

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

	es @ (OPRTDraggableSnapToGrid new gridSize: 20).

	es first translateTo: 70 negated @ 100 negated.
	es second translateTo: 70 @ 110.

	v open
]

{ #category : #example }
OPRTAnchorConstraint class >> exampleSelfEdge [
| v e box start end createAnchor|
v := RTView new.
v @ RTDraggableView.
v @ RTGridView.
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

box @ (OPRTDraggableSnapToGrid new gridSize: 20).

box translateBy: 0@0.

v open
]

{ #category : #building }
OPRTAnchorConstraint >> build [

	super build.
	(edge shape className asSymbol = #OPRTConnection or: [ 
		 edge shape className asSymbol = #OPRTStyledConnection ]) ifFalse: [ 
		^ self ].
	edge
		when: (self class environment at: #OPRTHandleMoved)
		do: [ self update ]
]

{ #category : #accessing }
OPRTAnchorConstraint >> segments [

	(edge shape isKindOf: OPRTConnection) ifTrue: [ 
		^ OPRTPolyLineSegment withAll: (self connectionSegmentsFor: edge) ].
	^ super segments
]
