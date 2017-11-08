construction
showInDiagram: aDiagramController
	(self allOwnedElementsInModel: self model)
		do: [ :each | 
			| subCtrl |
			subCtrl := aDiagramController newControllerFor: each.
			subCtrl showInDiagram: aDiagramController ]