instance creation
newLabelFor: aString
	^ RTLabel new
		color: Color black;
		height: 10;
		elementOn: aString