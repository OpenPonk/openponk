hooks
computePath
	| vector r unit |
	vector := self to - self from.
	(r := vector r) = 0
		ifTrue: [ ^ false ].
	unit := vector / r.
	radius := unit / 2 * size.
	center := self to - radius.
	path := self athensCanvas
		createPath: [ :builder | 
			builder
				absolute;
				moveTo: center + radius;
				ccwArcTo: center + radius leftRotated angle: 90 degreesToRadians;
				ccwArcTo: center - radius angle: 90 degreesToRadians;
				ccwArcTo: center - radius leftRotated angle: 90 degreesToRadians;
				ccwArcTo: center + radius angle: 90 degreesToRadians ]