materializing
materializeProject: aMaterializedProject
	| p |
	p := self materializeProjectBasic: aMaterializedProject.
	(aMaterializedProject at: #diagrams) do: [ :each | p addDiagram: (self materializeDiagram: each) ].
	p layouts: (aMaterializedProject at: #layouts).
	^ p