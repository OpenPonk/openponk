announcement
announceChanged
	self announce: (DCObjectChanged object: self).
	self announcer announce: (DCModelChanged model: self)