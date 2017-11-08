deprecated
attachTo: aDiagramController
	self deprecated: 'Use createInModel:andShowInDiagram: instead.'.
	"self diagramController: aDiagramController.
	aDiagramController controllers add: self.

	self loadModel.
	self registerModelEvents: model.
	self attachFigure"