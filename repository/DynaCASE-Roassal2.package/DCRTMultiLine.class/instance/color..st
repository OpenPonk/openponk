accessing
color: aColor
	tail ifNotNil: [tail color: aColor].
	head ifNotNil: [head color: aColor].
	color := aColor