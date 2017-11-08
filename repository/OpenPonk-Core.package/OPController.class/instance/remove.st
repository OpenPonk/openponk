deprecated
remove
	self deprecated: 'Use removeController instead.'.
	model ifNotNil: [ model announcer unsubscribe: self ]