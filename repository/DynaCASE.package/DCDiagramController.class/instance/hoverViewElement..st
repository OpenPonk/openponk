protocol-canvas
hoverViewElement: anElement
	| controller |
	controller := self findControllerByView: anElement.
	hoverHolder value: controller