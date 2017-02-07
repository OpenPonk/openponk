instance creation
createEdgeAnchor
	edge := RTLine new
		attachPoint: RTBorderAttachPoint new;
		edgeFrom: source to: target.
	edgeElement := RTBox new
		width: 50;
		height: 20;
		element.
	view add: edge.
	view add: edgeElement.
	edgeAnchor := OPRTAnchorConstraint new.
	edgeAnchor
		element: edgeElement;
		edge: edge;
		balance: 0;
		minDistance: 0;
		build