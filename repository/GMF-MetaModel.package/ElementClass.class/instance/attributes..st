accessing
attributes: aSet
	attributes := aSet.
	attributes ifNil: [ attributes := #() ].
	self changed