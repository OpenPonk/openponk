protocol-canvas
selectViewElement: anElement
	| controller |
	controller := self findControllerByView: anElement.
	selectionHolder value: controller