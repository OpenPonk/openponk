accessing
head: aLineHead
	(head := aLineHead)
		ifNotNil: [ 
			head attachPoint: attachPoint.
			head color: color ]