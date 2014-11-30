removing
removedFrom: aDiagram
	super
		removedFrom: aDiagram
		do: [ 
			self relationships  do: [ :each | aDiagram remove: each ].
			self generalizations do: [ :each | aDiagram remove: each ] ]