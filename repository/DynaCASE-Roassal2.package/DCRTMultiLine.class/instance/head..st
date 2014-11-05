accessing
head: aLineDecorationShape
	head := aLineDecorationShape.
	head ifNotNil: [ attachPoint ifNotNil: [ head attachPoint: attachPoint ] ]