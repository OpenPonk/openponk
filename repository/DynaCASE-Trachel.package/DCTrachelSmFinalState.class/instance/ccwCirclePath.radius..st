private
ccwCirclePath: aBuilder radius: r
	aBuilder
		moveTo: 0 @ r;
		ccwArcTo: r @ 0 angle: 90 degreesToRadians;
		ccwArcTo: 0 @ (0 - r) angle: 90 degreesToRadians;
		ccwArcTo: (0 - r) @ 0 angle: 90 degreesToRadians;
		ccwArcTo: 0 @ r angle: 90 degreesToRadians