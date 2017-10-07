adornments
showAdornmentsOn: anElement
	| boxes |
	boxes := adornments
		withIndexCollect: [ :each :i | self createAdornmentFrom: each position: i on: anElement ].
	anElement attributeAt: self className put: boxes.
	anElement view addAll: boxes.
	anElement view signalUpdate