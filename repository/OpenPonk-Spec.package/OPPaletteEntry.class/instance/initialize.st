initialization
initialize
	super initialize.
	self action: [ self palette selectEntry: self ].
	self icon: #'blank' asIcon.