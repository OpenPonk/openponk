public
updateLabel: aLabel whenChanged: aValueHolder
	aLabel shape text: aValueHolder value.
	aLabel update.
	aValueHolder
		whenChangedDo: [ :newValue | 
			aLabel shape text: newValue.
			aLabel update.
			aLabel model signalUpdate ]