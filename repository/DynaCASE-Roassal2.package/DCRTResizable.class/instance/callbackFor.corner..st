hooks
callbackFor: aHandle corner: aCorner
	"The resize is disabled during it's operation to prevent dependent repositioning between the element and its handles."

	self enabled
		ifFalse: [ ^ self ].
	self disable.
	self basicCallbackFor: aHandle corner: aCorner.
	self enable