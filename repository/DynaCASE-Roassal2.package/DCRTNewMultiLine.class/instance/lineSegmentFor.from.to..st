public
lineSegmentFor: anEdge from: aSource to: aTarget
	^ TRStyledLineShape new
		dashes: dashes;
		width: width;
		from: aSource to: aTarget;
		color: (self colorFor: anEdge);
		yourself