events - registering
attachTo: aDiagramController
	self loadModel.

	self diagramController: aDiagramController.
	aDiagramController controllers add: self.

	self registerModelEvents: model.

	self attachFigure