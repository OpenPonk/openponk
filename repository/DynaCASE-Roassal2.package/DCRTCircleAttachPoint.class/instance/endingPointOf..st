public - hooks
endingPointOf: anEdge
	| radius fromPoint toPoint offsetShift |
	radius := anEdge to width * 0.5.
	offsetShift := self offsetNormalFor: anEdge.
	fromPoint := anEdge to position + offsetShift.
	toPoint := anEdge from position + offsetShift.
	^ self attachPointOn: radius from: fromPoint to: toPoint