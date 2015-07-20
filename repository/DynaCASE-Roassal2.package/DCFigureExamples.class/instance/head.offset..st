adding
head: aName offset: aNumber
	| e1 e2 l1 boxShape |
	boxShape := RTBox new.
	e1 := boxShape element.
	e2 := boxShape element.
	l1 := DCRTStyledMultiLine new
		perform: aName asSymbol;
		edgeFrom: e1 to: e2.
	l1 model: aName.
	l1 shape color: Color black.
	view
		add: e1;
		add: e2;
		add: l1.

	e1 translateBy: -110 @ aNumber.
	e2 translateBy: 110 @ aNumber.

	RTLabelled new
		color: Color black;
		initializeElement: l1