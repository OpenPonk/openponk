as yet unclassified
lineSegmentFor: anEdge from: aSource to: aTarget
	^ TRLineShape new
		width: width;
		from: aSource to: aTarget;
		color: (self colorFor: anEdge);
		yourself