userinterface
updateView
	self view edges do: [ :edge | edge trachelShape pushBack ].
	self view signalUpdate.
	self controllers do: [ :ctrl | ctrl reloadViewPosition ].