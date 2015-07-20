public - layout
onController: aDiagramController
	diagramController := aDiagramController.
	self layoutHierarchy.
	self verticalFlip.
	self adjustHierarchy.
	self layoutAssociations.
"	self layoutLabels"