removing
removedFrom: aDiagram
	super
		removedFrom: aDiagram
		do: [ 
			self incoming do: [ :each | aDiagram remove: each ].
			self outgoing do: [ :each | aDiagram remove: each ] ]