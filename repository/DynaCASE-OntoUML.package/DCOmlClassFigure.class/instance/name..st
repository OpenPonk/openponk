accessing
name: aString
	name model: aString.
	name update.
	name view ifNil: [ ^ self ].
	name view signalUpdate.
	self update.
	self update