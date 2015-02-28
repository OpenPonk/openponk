as yet unclassified
in: aRectangle offset: anOffset
	| y |
	y := aRectangle top + anOffset.
	self
		from: aRectangle left @ y;
		to: aRectangle right @ y