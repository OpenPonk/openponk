interaction
deactivateElement: anElement
	true
		ifTrue: [ ^ self ].
	activationElement ifNotNil: [ activationElement remove ].
	activationElement := nil.
	(self findControllerByView: anElement) deactivate.
	self updateView