private
attachPointFrom: fromElement to: toElement
	| radius angle x y fromPos toPos fromPoint toPoint |
	fromPos := fromElement position.
	toPos := toElement position.
	fromPoint := fromPos x @ fromPos y negated.
	toPoint := toPos x @ toPos y negated.
	radius := fromElement width * 0.5.
	angle := fromPoint angleWith: toPoint.
	x := radius * angle cos + fromPoint x.
	y := radius * angle sin + fromPoint y.
	Transcript
		show: ' a: ' , angle asString , ' toPoint: ' , toPoint asString;
		cr.
	^ x @ y negated