accessing
accepts
	self hasCompleted
		ifFalse: [ self error: 'The recognition is not yet complete.' ].
	^ accepts