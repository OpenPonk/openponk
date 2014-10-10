adding
activateElement: anElement
	(activationShape := (self findControllerByView: anElement) activate)
		ifNotNil: [ 
			activationShape := activationShape element.
			TRConstraint stick: activationShape onTheCenterOf: anElement.
			self view add: activationShape ].
	self updateView