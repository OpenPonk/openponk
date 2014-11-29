materializing
materializeDiagramBasic: aMaterializedDiagram
	| d |
	d := (aMaterializedDiagram at: #className) asClass new.
	d name: (aMaterializedDiagram at: #name).
	d dcID: (aMaterializedDiagram at: #dcID).
	^ d