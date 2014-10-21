public
createEdgeFrom: fromElement to: toElement
	| edge |
	edge := DCRTMultiLine new
		arrowHead;
		"lineDashdot;"
		edgeFrom: fromElement to: toElement.
	edge shape color: self defaultColor.
	edge shape attachPoint: RTShorterDistanceWithOffsetAttachPoint instance.
	edge @ DCRTFocusable.
	^ edge