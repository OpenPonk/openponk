hooks
computePath
	| vector r u unit middle |
	vector := self to - self from.
	r := vector r.
	r = 0
		ifTrue: [ ^ false ].
	u := vector normal.
	unit := vector / r.
	middle := self to - (unit * size).
	left := middle - (u * size * 0.5).
	right := middle + (u * size * 0.5).
	path := self athensCanvas
		createPath: [ :builder | 
			builder
				absolute;
				moveTo: self to;
				lineTo: left;
				lineTo: right;
				lineTo: self to ]