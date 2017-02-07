private
newLabel: aString
	^ (RTLabel new
		height: 10;
		color: shape color;
		text: aString;
		element)
		@ RTDraggable;
		yourself