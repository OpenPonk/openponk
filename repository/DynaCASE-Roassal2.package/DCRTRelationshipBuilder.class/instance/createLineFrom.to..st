as yet unclassified
createLineFrom: fromElement to: toElement
	| edge |
	edge := DCRTMultiLine new edgeFrom: fromElement to: toElement.
	edge shape color: self defaultColor.
	edge shape attachPoint: RTShorterDistanceWithOffsetAttachPoint instance.
	edge @ DCRTFocusable.
	^ edge