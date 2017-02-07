example
example
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