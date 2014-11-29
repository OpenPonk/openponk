materializing
materializeDiagram: aMaterializedDiagram
	| d |
	d := self materializeDiagramBasic: aMaterializedDiagram.
	(aMaterializedDiagram at: #elements) do: [ :each | d add: (self materializeElement: each) ].
	^ d