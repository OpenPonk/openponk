public
createEdgeFrom: fromElement to: toElement head: aDecorationClass
	| edge |
	edge := DCRTMultiLine new
		color: self defaultColor;
		head: aDecorationClass asHead;
		attachPoint: DCRTRectangleAttachPoint new;
		edgeFrom: fromElement to: toElement.
	edge @ DCRTFocusable.
	^ edge