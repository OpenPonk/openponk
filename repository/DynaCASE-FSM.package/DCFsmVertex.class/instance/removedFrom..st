removing
removedFrom: aDiagram
	super removedFrom: aDiagram.

	self incoming do: [ :each | aDiagram remove: each ].
	self outgoing do: [ :each | aDiagram remove: each ]