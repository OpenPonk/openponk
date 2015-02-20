as yet unclassified
createLineFrom: fromElement to: toElement
	| edge |
	edge := DCRTMultiLine new
		color: self defaultColor;
	  "withShorterDistanceWithOffsetAttachPoint;"
		attachPoint: DCRTRectangleAttachPoint new;
		edgeFrom: fromElement to: toElement.
	edge @ DCRTFocusable.
	^ edge