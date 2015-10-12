accessing
segments
	(edge shape isKindOf: DCRTConnection)
		ifTrue: [ ^ DCRTPolyLineSegments withAll: (self connectionSegmentsFor: edge) ].
	(edge shape isKindOf: RTBezierLine)
		ifTrue: [ ^ self notYetImplemented ].
	^ DCRTPolyLineSegments with: (self lineSegmentFor: edge)