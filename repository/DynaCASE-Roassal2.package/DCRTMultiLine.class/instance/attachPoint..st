accessing
attachPoint: anAttachPoint
	head ifNotNil: [ head attachPoint: anAttachPoint ].
	attachPoint := anAttachPoint