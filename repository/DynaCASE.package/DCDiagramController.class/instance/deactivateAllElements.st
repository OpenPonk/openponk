interaction
deactivateAllElements
	true
		ifTrue: [ ^ self ].
	activationElement ifNotNil: [ activationElement remove ].
	activationElement := nil.
	self controllers do: [ :controller | controller deactivate ].
	self updateView