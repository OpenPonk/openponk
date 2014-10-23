adding
addDiagram: aDiagram
	self assert: (aDiagram isKindOf: DCDiagram).
	diagrams value add: aDiagram