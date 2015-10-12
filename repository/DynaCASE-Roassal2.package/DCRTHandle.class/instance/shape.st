accessing
shape
	^ RTEllipse new
		size: 9;
		color: [ :e | e shape colorFor: e ];
		borderColor: Color black;
		yourself