public - hooks
startingPointOf: anEdge
	| rectangle fromPoint toPoint offsetShift |
	rectangle := anEdge from encompassingRectangle flipBy: #vertical centerAt: 0 @ 0.
	offsetShift := self offsetNormalFor: anEdge.
	fromPoint := anEdge from position + offsetShift.
	toPoint := anEdge to position + offsetShift.
	^ self attachPointOn: rectangle from: fromPoint to: toPoint