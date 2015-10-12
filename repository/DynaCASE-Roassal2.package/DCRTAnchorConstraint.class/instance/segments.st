accessing
segments
	(edge shape isKindOf: DCRTConnection)
		ifTrue: [ ^ DCRTPolyLineSegment withAll: (self connectionSegmentsFor: edge) ].
	(edge shape isKindOf: RTBezierLine)
		ifTrue: [ ^ self notYetImplemented ].
	^ DCRTPolyLineSegment with: (self lineSegmentFor: edge)