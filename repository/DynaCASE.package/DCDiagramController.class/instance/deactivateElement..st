interaction
deactivateElement: anElement
	activationElement ifNotNil: [ activationElement remove ].
	activationElement := nil.
	(self findControllerByView: anElement) deactivate.
	self updateView