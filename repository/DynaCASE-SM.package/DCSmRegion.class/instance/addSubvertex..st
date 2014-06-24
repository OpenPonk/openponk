accessing
addSubvertex: aSubvertex
	aSubvertex container: self.
	subvertex add: aSubvertex.
	self announce: (DCObjectAdded object: aSubvertex container: self)