destruction
removeAllControllers
	[ self controllers isNotEmpty ] whileTrue: [ self controllers last removeController ]