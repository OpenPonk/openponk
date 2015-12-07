example
exampleSelfEdge
| v e box start end createAnchor|
v := RTView new.
v @ RTDraggableView.
v @ DCRTGridView.
v @ RTZoomableView.

box := RTBox new
	color: Color green;
	width: 100;
	height: 50;
	element.
e := DCRTStyledConnection new
	attachPoint: DCRTNewRectangleAttachPoint new;
	color: Color black;
	edgeFrom: box to: box.
e shape decorations arrowHead.
e @ DCRTConnectionHandles.

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
	DCRTAnchorConstraint new
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

start @ DCRTRoundedDraggable.
end @ DCRTRoundedDraggable.

box @ (RTDraggableSnapToGrid new gridSize: 20).

box translateBy: 0@0.

v open