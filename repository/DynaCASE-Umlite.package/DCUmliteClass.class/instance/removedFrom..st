removing
removedFrom: aDiagram
	super removedFrom: aDiagram do: [ self associations do: [ :each | aDiagram remove: each ] ]