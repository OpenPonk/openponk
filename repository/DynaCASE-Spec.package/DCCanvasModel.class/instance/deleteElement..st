as yet unclassified
deleteElement: anElement
	anElement = focusedElement
		ifTrue: [ self cancelFocus ].
	diagramController removeFromView: anElement.
	self signalUpdate