rendering
lineSegmentFor: anEdge from: aSource to: aTarget
	^ TRLineShape new
		width: (self widthFor: anEdge);
		from: aSource to: aTarget;
		color: (self colorFor: anEdge);
		yourself