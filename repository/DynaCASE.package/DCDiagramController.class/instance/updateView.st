userinterface
updateView
	self view edges
		do: [ :edge | 
			edge trachelShape pushBack.
			edge update ].
	self view signalUpdate