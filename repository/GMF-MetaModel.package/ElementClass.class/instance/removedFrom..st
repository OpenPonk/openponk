removing
removedFrom: aDiagram
	self syncAssociations.	"self generalizations do:[:general|
	(self == (general parent))
	ifTrue:[
		aDiagram remove: (general child).
		].
	
	]."
	super
		removedFrom: aDiagram
		do: [ 
			self relationships do: [ :each | aDiagram remove: each ].
			self generalizations do: [ :each | aDiagram remove: each ] ]