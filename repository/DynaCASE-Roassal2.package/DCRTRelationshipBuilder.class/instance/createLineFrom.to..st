as yet unclassified
createLineFrom: fromElement to: toElement
	| edge |
	edge := DCRTMultiLine new
		color: self defaultColor;
		withShorterDistanceWithOffsetAttachPoint;
		edgeFrom: fromElement to: toElement.
	edge @ DCRTFocusable.
	^ edge