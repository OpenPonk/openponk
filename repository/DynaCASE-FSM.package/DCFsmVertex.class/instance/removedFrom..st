removing
removedFrom: aDiagram
	self assert: self owner = aDiagram.

	self incoming do: [ :each | aDiagram remove: each ].
	self outgoing do: [ :each | aDiagram remove: each ]