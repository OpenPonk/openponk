attach point
attachPoint: anAttachPoint
	super attachPoint: anAttachPoint.
	tail attachPoint: self attachPoint.
	head attachPoint: self attachPoint.
	line attachPoint: self attachPoint