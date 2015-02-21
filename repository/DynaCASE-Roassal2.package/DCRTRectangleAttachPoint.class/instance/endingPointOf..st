public - hooks
endingPointOf: anEdge
	| rectangle fromPoint toPoint offsetShift |
	rectangle := anEdge to encompassingRectangle flipBy: #vertical centerAt: 0 @ 0.
	offsetShift := self offsetNormalFor: anEdge.
	fromPoint := anEdge to position + offsetShift.
	toPoint := anEdge from position + offsetShift.
	^ self attachPointOn: rectangle from: fromPoint to: toPoint