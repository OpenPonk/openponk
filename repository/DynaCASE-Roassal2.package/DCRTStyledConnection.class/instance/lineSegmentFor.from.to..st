public
lineSegmentFor: anEdge from: aSource to: aTarget
	^ TRStyledLineShape new
		dashes: decorations dashes;
		width: (self widthFor: anEdge);
		from: aSource to: aTarget;
		color: (self colorFor: anEdge);
		yourself