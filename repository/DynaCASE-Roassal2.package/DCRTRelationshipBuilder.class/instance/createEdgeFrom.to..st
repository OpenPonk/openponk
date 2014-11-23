public
createEdgeFrom: fromElement to: toElement
	| edge |
	edge := DCRTMultiLine new
		color: self defaultColor;
		arrowHead;
		withShorterDistanceWithOffsetAttachPoint;
		edgeFrom: fromElement to: toElement.
	edge @ DCRTFocusable.
	^ edge