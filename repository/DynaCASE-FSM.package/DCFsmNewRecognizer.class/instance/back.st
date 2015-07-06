stepping
back
	path ifEmpty: [ ^ self ].
	self goTo: path pop.
	current isVertex
		ifTrue: [ input push: consumed pop ]