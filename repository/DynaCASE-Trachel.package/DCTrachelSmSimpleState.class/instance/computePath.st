private
computePath
	| r |
	canvas ifNil: [ ^ self ].
	r := 0.1 * ((rectangle extent x + rectangle extent y) / 2).
	path := self athensCanvas
		createPath: [ :builder | 
			builder
				absolute;
				moveTo: rectangle topLeft + (0 @ r);
				cwArcTo: rectangle topLeft + (r @ 0) angle: 90 degreesToRadians;
				lineTo: rectangle topRight - (r @ 0);
				cwArcTo: rectangle topRight + (0 @ r) angle: 90 degreesToRadians;
				lineTo: rectangle bottomRight - (0 @ r);
				cwArcTo: rectangle bottomRight - (r @ 0) angle: 90 degreesToRadians;
				lineTo: rectangle bottomLeft + (r @ 0);
				cwArcTo: rectangle bottomLeft - (0 @ r) angle: 90 degreesToRadians;
				lineTo: rectangle topLeft + (0 @ r);
				closePath ]