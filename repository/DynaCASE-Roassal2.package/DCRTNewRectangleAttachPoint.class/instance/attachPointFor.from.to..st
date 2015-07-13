private
attachPointFor: anEdge from: fromRect to: toRect
	| intersections offsetShift fromPoint toPoint |
	offsetShift := self offsetNormalFor: anEdge.
	fromPoint := fromRect center + offsetShift.
	toPoint := toRect center + offsetShift.
	fromRect = toRect
		ifTrue: [ ^ fromRect topLeft ].
	(fromRect containsRect: toRect)
		ifTrue: [ ^ fromRect pointNearestTo: toPoint ].
	(toRect containsRect: fromRect)
		ifTrue: [ ^ fromRect pointNearestTo: (toRect pointNearestTo: fromPoint) ].
	intersections := (RTLineSegment from: fromPoint to: toPoint) intersectRectangle: fromRect.
	intersections ifEmpty: [ ^ fromRect pointNearestTo: toPoint ].
	^ intersections detectMin: [ :each | each r ]