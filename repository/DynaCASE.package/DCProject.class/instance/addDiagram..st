adding
addDiagram: aDiagram
	self assert: (aDiagram isKindOf: DCDiagram).
	aDiagram when: DCElementChanged do: [ :event | self beDirty ].
	diagrams add: aDiagram