retrieving
displayFor: aDiagramView
	^ '[' , aDiagramView name , '] ' , (adapters displayFor: aDiagramView model)