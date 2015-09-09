adding
addDiagram: aDiagram
	aDiagram announcer
		when: MooseEntityAnnouncement
		do: [ :event | self beDirty ].
	aDiagram announcer
		when: DCElementChanged
		do: [ :event | self beDirty ].
	diagrams add: aDiagram