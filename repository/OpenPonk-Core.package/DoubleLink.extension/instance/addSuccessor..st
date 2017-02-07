*OpenPonk-Core-accessing
addSuccessor: aLink
	| oldSuccessor |
	oldSuccessor := self nextLink.
	oldSuccessor previousLink: aLink.
	aLink nextLink: oldSuccessor.
	aLink previousLink: self.
	self nextLink: aLink