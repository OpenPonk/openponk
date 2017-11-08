construction
showInDiagram: aDiagramController
	aDiagramController addController: self.
	self renderFigureIn: aDiagramController view.
	(self allOwnedElementsInModel: self model)
		do: [ :each | 
			| subCtrl |
			subCtrl := aDiagramController newControllerFor: each.
			subCtrl showInDiagram: aDiagramController ]