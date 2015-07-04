adding
addDiagram: aDiagram
	aDiagram when: DCElementChanged do: [ :event | self beDirty ].
	diagrams add: aDiagram