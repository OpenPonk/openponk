private
cwCirclePath: aBuilder radius: r
	aBuilder
		moveTo: 0 @ r;
		cwArcTo: (0 - r) @ 0 angle: 90 degreesToRadians;
		cwArcTo: 0 @ (0 - r) angle: 90 degreesToRadians;
		cwArcTo: r @ 0 angle: 90 degreesToRadians;
		cwArcTo: 0 @ r angle: 90 degreesToRadians