accessing
derivated: anObject
	derivated isNil 
		ifTrue: [ derivated := anObject ];
		ifFalse: [ self error: 'Is not allowed to change derivated of this association.' ]
	