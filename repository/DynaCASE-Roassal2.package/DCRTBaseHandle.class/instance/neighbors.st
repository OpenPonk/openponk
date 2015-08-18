accessing
neighbors
	^ {self next.
	self previous} reject: #isNil