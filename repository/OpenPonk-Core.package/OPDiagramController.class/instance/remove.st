deprecated
remove
	self deprecated: 'There should be no need to call #remove on DiagramController'.
	self error: 'There should be no need to call #remove on DiagramController'.
"	super remove.
	[ self controllers isNotEmpty ] whileTrue: [ self controllers last remove ]"