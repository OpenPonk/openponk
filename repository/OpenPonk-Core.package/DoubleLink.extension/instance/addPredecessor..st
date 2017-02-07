*OpenPonk-Core-accessing
addPredecessor: aLink
	| oldPredeccessor |
	oldPredeccessor := self previousLink.
	oldPredeccessor nextLink: aLink.
	aLink previousLink: oldPredeccessor.
	aLink nextLink: self.
	self previousLink: aLink