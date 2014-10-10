as yet unclassified
activate
	^ RTBox new
		extent: self view encompassingRectangle extent;
		color: Color transparent;
		borderColor: Color blue