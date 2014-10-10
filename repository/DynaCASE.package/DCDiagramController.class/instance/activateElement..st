interaction
activateElement: anElement
	(activationElement := (self findControllerByView: anElement) activate) ifNotNil: [ self view add: activationElement ].
	self updateView