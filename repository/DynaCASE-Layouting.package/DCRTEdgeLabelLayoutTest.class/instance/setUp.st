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
	label := RTBox new
		size: 38;
		elementOn: edge.
	layout := DCRTEdgeLabelLayout new.
	layout spacing: 50.
	layout elements: elements.
	layout edges: {edge}.
	layout labels: {label}