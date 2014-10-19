as yet unclassified
deleteElement: anElement
	diagramController removeFromView: anElement.
	self signalUpdate