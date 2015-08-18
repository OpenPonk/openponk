removing
removeLastSegment
	self previous remove.
	self previous previous remove.
	self previous previous removeLink.
	self previous removeLink.
	self realignWith: self previous