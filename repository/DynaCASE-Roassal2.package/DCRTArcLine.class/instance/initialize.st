initialization
initialize
	super initialize.
	self head: RTNoDecorationShape asHead.
	self tail: RTNoDecorationShape asTail.
	self attachPoint: DCRTCircleSelfAttachPoint new