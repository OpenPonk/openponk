trachel shape production
trachelShapeForOneLine: anElement
	| shape |
	shape := TRLabelShape new.
	shape
		text: (self textFor: anElement);
		color: (self colorFor: anElement);
		position: (self positionFor: anElement);
		fontSize: (self heightFor: anElement);
		fontName: (self fontNameFor: anElement).
	^ shape