as yet unclassified
deleteElement: anElement
	(diagramController findControllerByView: anElement) = focusedController
		ifTrue: [ self cancelFocus ].
	diagramController removeFromView: anElement.
	self signalUpdate