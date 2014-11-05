removing
removeDiagram: aDiagram
	self assert: (aDiagram isKindOf: DCDiagram).
	diagrams remove: aDiagram.
	aDiagram announcer unsubscribe: self