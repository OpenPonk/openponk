labels
updateLabel: aSymbol whenChanged: aValueHolder
	| label |
	label := self labelNamed: aSymbol.
	label trachelShape text: aValueHolder value.
	aValueHolder
		whenChangedDo: [ :newValue | 
			label trachelShape text: newValue.
			label signalUpdate ]