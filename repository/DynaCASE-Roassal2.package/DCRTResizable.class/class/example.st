example
example
	| v g |
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

	v addAll: g.

	RTGridLayout on: g.

	g @ RTDraggable.
	g @ DCRTResizable.

	v @ RTZoomableView.

	v open