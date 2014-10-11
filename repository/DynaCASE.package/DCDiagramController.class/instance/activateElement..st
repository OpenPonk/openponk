interaction
activateElement: anElement
	true
		ifTrue: [ ^ self ].
	(activationElement := (self findControllerByView: anElement) activate) ifNotNil: [ self view add: activationElement ].
	self updateView