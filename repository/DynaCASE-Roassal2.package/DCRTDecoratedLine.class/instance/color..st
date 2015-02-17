accessing
color: aColor
	color := aColor.
	tail ifNotNil: [ tail color: self color ].
	head ifNotNil: [ head color: self color ].
	line color: self color