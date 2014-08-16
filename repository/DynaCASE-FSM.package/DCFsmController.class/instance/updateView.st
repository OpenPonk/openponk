private
updateView
	self view edges do: [ :edge | edge trachelShape pushBack ].
	self view signalUpdate