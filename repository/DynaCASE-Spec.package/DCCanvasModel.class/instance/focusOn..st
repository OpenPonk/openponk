selection handling
focusOn: anElement
	self focusOnController: (diagramController findControllerByView: anElement)