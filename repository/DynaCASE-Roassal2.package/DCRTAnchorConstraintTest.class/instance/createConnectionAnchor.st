instance creation
createConnectionAnchor
	connection := DCRTStyledConnection new
		attachPoint: DCRTNewRectangleAttachPoint new;
		edgeFrom: source to: target.
	connection shape addPoint: 0 @ 50.
	connection shape addPoint: 50 @ 100.
	connectionElement := RTBox new
		width: 50;
		height: 20;
		element.
	view add: connection.
	view add: connectionElement.
	connectionAnchor := DCRTAnchorConstraint new.
	connectionAnchor
		element: connectionElement;
		edge: connection;
		balance: 0;
		minDistance: 0;
		build