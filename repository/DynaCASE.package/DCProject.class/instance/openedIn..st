as yet unclassified
openedIn: anEditor
	editor := anEditor.
	self diagrams ifNotEmpty: [ self openDiagramCommand: self diagrams first ]