selection handling
focusOnElement: anElement
	self focusOnController: (diagramController findControllerByView: anElement)