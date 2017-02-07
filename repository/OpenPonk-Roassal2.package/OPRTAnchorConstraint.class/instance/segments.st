accessing
segments
	(edge shape isKindOf: OPRTConnection)
		ifTrue: [ ^ OPRTPolyLineSegment withAll: (self connectionSegmentsFor: edge) ].
	(edge shape isKindOf: RTBezierLine)
		ifTrue: [ ^ self notYetImplemented ].
	^ OPRTPolyLineSegment with: (self lineSegmentFor: edge)