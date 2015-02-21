private
attachPointOn: radius from: fromPos to: toPos
	| angle x y fromPoint line |
	fromPoint := fromPos x @ fromPos y negated.
	line := DCLineSegment from: fromPoint to: toPos x @ toPos y negated.
	angle := line angleInRad.
	angle ifNil: [ ^ fromPos ].
	x := radius * angle cos + fromPoint x.
	y := radius * angle sin + fromPoint y.
	^ x @ y negated