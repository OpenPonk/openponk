announcement
announceChanged
	self announce: (DCObjectChanged object: self).
	self announcer announce: (DCModelChanged object: self)