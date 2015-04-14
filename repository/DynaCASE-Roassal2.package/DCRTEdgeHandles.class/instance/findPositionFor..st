as yet unclassified
findPositionFor: aPoint
	bendPoints ifEmpty: [ ^ 2 ].
	^ (2 to: bendPoints size)
		detect: [ :i | 
			| fromPoint toPoint |
			fromPoint := bendPoints at: i - 1.
			toPoint := bendPoints at: i.
			aPoint onLineFrom: fromPoint to: toPoint within: 5 ]