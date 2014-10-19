as yet unclassified
deleteElement: anElement
	| controller |
	controller := diagramController findControllerByView: anElement.
	diagram remove: controller model