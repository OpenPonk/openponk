private - layout
updatePosition
	| segment |
	segment := self segmentForPosition: self computePosition.
	gripElement translateTo: segment third.
	element translateTo: segment third + ((segment second - segment first) normal * distance negated)