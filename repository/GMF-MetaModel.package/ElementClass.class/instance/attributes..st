accessing
attributes: aSet
	attributes := aSet.
	attributes ifNil: [ attributes := Set new ].
	self changed