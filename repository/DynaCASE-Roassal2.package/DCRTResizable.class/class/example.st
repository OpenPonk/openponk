example
example
	| v g el edge |
	v := RTView new.

	g := {RTBox new
		size: 100;
		borderColor: Color black;
		borderWidth: 1;
		element.

	RTRoundedBox new
		size: 50;
		borderRadius: 20;
		borderColor: Color black;
		borderWidth: 1;
		element.

	RTEllipse new
		width: 100;
		height: 30;
		borderColor: Color black;
		element} asGroup.
		
	el := RTBox new
		size: 50;
		color: Color black;
		element.
		
	edge := RTLine new
		color: Color black;
		attachPoint: RTRectangleAttachPoint new;
		edgeFrom: g first to: el.

	v addAll: g.
	v
		add: el;
		add: edge.

	RTGridLayout on: v elements.

	v elements @ RTDraggable.
	g @ DCRTResizable.

	v @ RTZoomableView.

	v open