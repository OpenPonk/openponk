removing
removeDiagram: aDiagram
	self assert: (aDiagram isKindOf: DCDiagram).
	diagrams value remove: aDiagram