private
attachPointFrom: fromElement to: toElement
	| radius angle x y fromPos toPos fromPoint line |
	fromPos := fromElement position.
	toPos := toElement position.
	fromPoint := fromPos x @ fromPos y negated.
	line := DCLineSegment from: fromPoint to: toPos x @ toPos y negated.
	radius := fromElement width * 0.5.
	angle := line angleInRad.
	angle ifNil: [ ^ fromPos ].
	x := radius * angle cos + fromPoint x.
	y := radius * angle sin + fromPoint y.
	^ x @ y negated