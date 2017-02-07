*OpenPonk-Core-accessing
tail
	self isEmpty
		ifTrue: [ CollectionIsEmpty signalWith: self ].
	^ tail