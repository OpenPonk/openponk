instance creation
initialPositions
	^ {(DCRTLPosition new
		ranking: 1 of: 3;
		orientation: #topRight;
		position: 45 @ -20;
		bounds: (26 @ -39 corner: 64 @ -1)).
	(DCRTLPosition new
		ranking: 1 of: 3;
		orientation: #bottomRight;
		position: 45 @ 20;
		bounds: (26 @ 1 corner: 64 @ 39)).
	(DCRTLPosition new
		ranking: 1 of: 3;
		orientation: #bottomLeft;
		position: 5 @ 20;
		bounds: (-14 @ 1 corner: 24 @ 39)).
	(DCRTLPosition new
		ranking: 1 of: 3;
		orientation: #topLeft;
		position: 5 @ -20;
		bounds: (-14 @ -39 corner: 24 @ -1))}