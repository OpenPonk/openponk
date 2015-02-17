accessing
attachPoint: anAttachPoint
	super attachPoint: anAttachPoint.
	tail ifNotNil: [ tail attachPoint: self attachPoint ].
	head ifNotNil: [ head attachPoint: self attachPoint ].
	line attachPoint: self attachPoint