initialization
initialize
	super initialize.
	self head: DCRTNoDecorationShape asHead.
	self tail: DCRTNoDecorationShape asTail.
	self attachPoint: DCRTCircleSelfAttachPoint new