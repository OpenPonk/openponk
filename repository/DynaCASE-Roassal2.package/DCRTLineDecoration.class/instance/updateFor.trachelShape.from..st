hooks
updateFor: anEdge trachelShape: trachelShape from: aPoint
	trachelShape
		from: aPoint;
		to: (self targetPointOf: anEdge);
		color: (self colorFor: anEdge);
		width: (self widthFor: anEdge);
		resetPath