private
attachPointFor: anEdge from: fromRect to: toRect
	| angle x y fromPoint toPoint offsetShift radius |
	offsetShift := self offsetNormalFor: anEdge.
	fromPoint := fromRect center + offsetShift.
	toPoint := toRect center + offsetShift.
	radius := fromRect width * 0.5.
	angle := (DCLineSegment from: fromPoint to: toPoint) angleInRad ifNil: [ 2 ].
	(toPoint dist: fromPoint) < (toRect width * 0.5 - radius)
		ifTrue: [ angle := angle + Float pi ].	"fromCircle is inside toCircle"
	offsetShift isZero
		ifFalse: [ radius := radius * (offsetShift r / radius) arcSin cos ].	"recalculates radius based on offset"
	x := radius * angle cos + fromPoint x.
	y := radius * angle sin + fromPoint y.
	^ x @ y