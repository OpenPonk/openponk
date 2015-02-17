accessing
line: aLineShape
	(line := aLineShape)
		ifNotNil: [ 
			line attachPoint: attachPoint.
			line color: color ]