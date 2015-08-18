removing
removeFirstSegment
	self next remove.
	self next next remove.
	self next next removeLink.
	self next removeLink.
	self realignWith: self next