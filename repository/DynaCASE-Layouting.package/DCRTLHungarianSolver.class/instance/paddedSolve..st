public
paddedSolve: aMatrix
	| padded |
	padded := self padWithZeros: aMatrix.
	self solve: padded.
	^ self solution: aMatrix