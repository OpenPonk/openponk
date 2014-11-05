removing
removedFrom: anOwner do: aBlock
	self assert: self owner = anOwner.
	aBlock value.
	owner := nil.
	self changed