api - highlight
highlightElement: anElement with: aColor
	self unhighlightElement: anElement.
	anElement attributeAt: self name put: anElement shape borderColor.
	anElement shape borderColor: aColor.
	anElement update.
	anElement signalUpdate