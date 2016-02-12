adding
addDiagram: aDiagram
	(Smalltalk hasClassNamed: #MooseEntityAnnouncement)
		ifTrue: [ aDiagram announcer
				when: #MooseEntityAnnouncement asClass
				do: [ :event | self beDirty ] ].
	aDiagram announcer when: DCElementChanged do: [ :event | self beDirty ].
	diagrams add: aDiagram