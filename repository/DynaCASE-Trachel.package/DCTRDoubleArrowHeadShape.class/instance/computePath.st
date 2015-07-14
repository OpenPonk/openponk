hooks
computePath
	| vector r u unit middle halfWidthShift arrowLengthShift source |
	vector := self to - self from.
	r := vector r.
	r isZero
		ifTrue: [ ^ false ].
	u := vector normal.
	unit := vector / r.
	halfWidthShift := u * size * 0.5.
	arrowLengthShift := unit * size.
	middle := self to - arrowLengthShift.
	source := middle - arrowLengthShift.
	path := self athensCanvas
		createPath: [ :builder | 
			builder
				absolute;
				moveTo: self to;
				lineTo: middle + halfWidthShift;
				lineTo: middle;
				lineTo: source + halfWidthShift;
				lineTo: source - halfWidthShift;
				lineTo: middle;
				lineTo: middle - halfWidthShift;
				lineTo: self to ]