private - layout
verticalFlip
	| els centerY |
	els := self collectClassFigures.
	centerY := els asGroup encompassingRectangle center y.
	els do: [ :each | each translateBy: 0 @ 2 * (centerY - each position y) ].
	self updateView