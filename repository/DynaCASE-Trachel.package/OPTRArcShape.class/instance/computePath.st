hooks
computePath
	| arc |
	arc := self arc.

	path := self athensCanvas
		createPath: [ :builder | 
			builder
				absolute;
				moveTo: arc from;
				cwArcTo: arc to angle: arc biggerAngle ]