as yet unclassified
updateFor: edge trachelShape: trachelShape from: fromPoint to: toPoint
	trachelShape
		from: fromPoint;
		to: toPoint;
		color: (self colorFor: edge);
		width: (self widthFor: edge);
		resetPath