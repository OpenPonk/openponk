instance creation
initialPositions
	^ {(DCRTLPosition new
		ranking: 1 of: 3;
		orientation: #topRight;
		position: 30 @ -20;
		bounds: (11 @ -39 corner: 49 @ -1)).
	(DCRTLPosition new
		ranking: 1 of: 3;
		orientation: #bottomRight;
		position: 30 @ 20;
		bounds: (11 @ 1 corner: 49 @ 39)).
	(DCRTLPosition new
		ranking: 1 of: 3;
		orientation: #bottomLeft;
		position: -10 @ 20;
		bounds: (-29 @ 1 corner: 9 @ 39)).
	(DCRTLPosition new
		ranking: 1 of: 3;
		orientation: #topLeft;
		position: -10 @ -20;
		bounds: (-29 @ -39 corner: 9 @ -1))}