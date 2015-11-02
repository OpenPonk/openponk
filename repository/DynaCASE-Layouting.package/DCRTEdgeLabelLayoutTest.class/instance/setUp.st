running
setUp
	view := RTView new.
	elements := RTBox new
		size: 20;
		elementsOn: #(#A #B).
	elements second translateTo: 100 @ 0.
	view addAll: elements.
	edge := RTLine new
		attachPoint: RTRectangleAttachPoint new;
		edgeFrom: elements first to: elements second.
	label := RTLabel new
		text: [ :model | model model ];
		elementOn: edge.
	layout := DCRTEdgeLabelLayout new.
	layout labels: {label}