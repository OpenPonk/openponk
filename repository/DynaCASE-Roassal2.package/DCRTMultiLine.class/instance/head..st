accessing
head: aLineDecorationShape
	(head := aLineDecorationShape) ifNotNil: [ attachPoint ifNotNil: [ head attachPoint: attachPoint ] ]