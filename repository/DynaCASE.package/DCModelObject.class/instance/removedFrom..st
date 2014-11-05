removing
removedFrom: anOwner
	self assert: self owner = anOwner.
	owner := nil.
	self changed