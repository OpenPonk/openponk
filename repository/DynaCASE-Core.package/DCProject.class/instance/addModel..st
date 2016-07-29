adding
addModel: aModel
	(Smalltalk hasClassNamed: #MooseEntityAnnouncement)
		ifTrue: [ aModel announcer when: #MooseEntityAnnouncement asClass do: [ :event | self beDirty ] ].
	aModel announcer when: DCElementChanged do: [ :event | self beDirty ].
	models add: aModel.
	(aModel respondsTo: #project:)
		ifTrue: [ aModel project: self ]