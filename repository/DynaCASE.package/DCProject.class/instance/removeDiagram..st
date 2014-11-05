removing
removeDiagram: aDiagram
	diagrams remove: aDiagram.
	aDiagram announcer unsubscribe: self