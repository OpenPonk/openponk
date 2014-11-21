accessing
attachPoint: anAttachPoint
	tail ifNotNil: [ tail attachPoint: anAttachPoint ].
	head ifNotNil: [ head attachPoint: anAttachPoint ].
	attachPoint := anAttachPoint