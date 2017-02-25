registrations handling
hasCorrectArguments: aPragma
	^ aPragma numArgs = 0 or: [ testBlock value: aPragma ]