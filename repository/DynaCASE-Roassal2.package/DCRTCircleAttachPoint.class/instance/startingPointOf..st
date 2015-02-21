public - hooks
startingPointOf: anEdge
	| radius fromPoint toPoint offsetShift |
	radius := anEdge from width * 0.5.
	offsetShift := self offsetNormalFor: anEdge.
	fromPoint := anEdge from position + offsetShift.
	toPoint := anEdge to position + offsetShift.
	^ self attachPointOn: radius from: fromPoint to: toPoint