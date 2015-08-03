instance creation
newBackground
	^ RTRoundedBox new
		size: 50;
		borderRadius: 25;
		borderWidth: 1.5;
		color: Color transparent;
		borderColor: Color black;
		elementOn: ''