hooks
updateFor: edge trachelShape: trachelShape
	tail
		ifFalse: [ self updateAsHeadFor: edge trachelShape: trachelShape ]
		ifTrue: [ self updateAsTailFor: edge trachelShape: trachelShape ]