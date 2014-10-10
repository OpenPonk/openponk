adding
deactivateAllElements
	activationShape ifNotNil: [ activationShape remove ].
	activationShape := nil.
	self controllers do: [ :controller | controller deactivate ].
	self updateView