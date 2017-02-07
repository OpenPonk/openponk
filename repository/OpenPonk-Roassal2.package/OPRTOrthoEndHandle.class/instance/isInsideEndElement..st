testing
isInsideEndElement: aPosition
	"containsPoint: is not used, because it uses strict comparison (so the element can't be on the border of the rectangle"

	| rect |
	rect := endElement encompassingRectangle.
	^ rect origin <= aPosition and: [ aPosition <= rect corner ]