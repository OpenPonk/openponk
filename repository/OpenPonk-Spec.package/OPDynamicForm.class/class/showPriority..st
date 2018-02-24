specs
showPriority: aBoolean
	aBoolean
		ifTrue: [ self installLink ]
		ifFalse: [ self uninstallLink ]