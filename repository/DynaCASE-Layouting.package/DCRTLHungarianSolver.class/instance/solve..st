public
solve: aMatrix
	self
		assert: [ aMatrix numberOfRows = aMatrix numberOfColumns ]
		description: 'aMatrix must be a square, or use #paddedSolve:'.
	matrix := aMatrix copy.
	self setup.
	self minimizeRows.
	self minimizeColumns.
	self initialMarks.
	self step1.
	^ self solution: aMatrix