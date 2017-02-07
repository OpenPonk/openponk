*OpenPonk-Core-accessing
linksDo: aBlock
	| aLink |
	aLink := head.
	[ aLink == nil ]
		whileFalse: [ 
			aBlock value: aLink.
			aLink := aLink nextLink ]