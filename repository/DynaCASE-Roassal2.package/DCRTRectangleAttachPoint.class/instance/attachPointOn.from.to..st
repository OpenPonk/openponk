private
attachPointOn: aRectangle from: fromPoint to: toPoint
	| line intersection |
	line := DCLineSegment from: fromPoint x @ fromPoint y negated to: toPoint x @ toPoint y negated.
	intersection := line intersectRectangle: aRectangle.
	intersection ifNil: [ ^ fromPoint ].
	^ intersection x @ intersection y negated