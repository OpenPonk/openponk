accessing
tail: aLineTail
	(tail := aLineTail)
		ifNotNil: [ 
			tail attachPoint: attachPoint.
			tail color: color ]