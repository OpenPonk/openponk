example
example2
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