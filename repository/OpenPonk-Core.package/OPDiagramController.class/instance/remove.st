actions
remove
	super remove.
	[ self controllers isNotEmpty ] whileTrue: [ self controllers last remove ]