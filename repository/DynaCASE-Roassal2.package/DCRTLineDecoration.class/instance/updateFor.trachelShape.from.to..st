private
updateFor: anEdge trachelShape: trachelShape from: fromPoint to: toPoint
	trachelShape
		from: fromPoint;
		to: toPoint;
		color: (self colorFor: anEdge);
		width: (self widthFor: anEdge);
		resetPath