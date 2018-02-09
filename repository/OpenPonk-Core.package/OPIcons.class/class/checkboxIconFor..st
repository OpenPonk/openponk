instance creation
checkboxIconFor: aBoolean
	^ aBoolean
		ifTrue: [ #checkboxSelected asIcon ]
		ifFalse: [ #checkboxUnselected asIcon ]