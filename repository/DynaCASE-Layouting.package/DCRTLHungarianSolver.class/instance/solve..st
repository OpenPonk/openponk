protocol
solve: aMatrix
	matrix := aMatrix copy.
	self setup.
	self minimizeRows.
	self minimizeColumns.
	self initialMarks.
	self step1.
	^ self solution: aMatrix