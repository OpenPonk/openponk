adding
deactivateElement: anElement
	activationShape ifNotNil: [ activationShape remove ].
	activationShape := nil.
	(self findControllerByView: anElement) deactivate.
	self updateView