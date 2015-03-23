public
updateLabel: aLabel whenChanged: aValueHolder
	aLabel trachelShape text: aValueHolder value.
	aValueHolder
		whenChangedDo: [ :newValue | 
			aLabel trachelShape text: newValue.
			aLabel model signalUpdate ]