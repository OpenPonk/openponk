private
newLabel: aString
	| label |
	label := RTLabel new
		height: 10;
		color: shape color;
		text: aString;
		element.
	label @ RTDraggable.
	^ label