public
createEdgeFrom: fromElement to: toElement
	| edge |
	edge := DCRTMultiLine new
		color: self defaultColor;
		arrowHead;
"		withShorterDistanceWithOffsetAttachPoint;"
		attachPoint: DCRTRectangleAttachPoint new;
		edgeFrom: fromElement to: toElement.
	edge @ DCRTFocusable.
	^ edge