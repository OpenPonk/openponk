events - registering
attachTo: aDiagramController
	self diagramController: aDiagramController.
	aDiagramController controllers add: self.

	self loadModel.
	self registerModelEvents: model.
	self attachFigure